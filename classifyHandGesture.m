function out = classifyHandGesture(cropped_image_output)
    persistent handPose directionMovement;
    global x_t_store;
    persistent initData;% handClassifier;
    global handClassifier;
    if (isempty(initData))
        initData = 0;
        handClassifier = load('categoryClassifier')
        handPose = 0;
        directionMovement = 0;
         
        clear categoryClassifier;
    end

    %% Threshold value to compute movement
    movementThreshold = 15;
    %% Extract the velocities
    if (x_t_store(1,1) == 0)
        out = [0 0];
        handPose = 0;
        directionMovement = 0;
        return
    end
    xVel = x_t_store(:,3);
    yVel = x_t_store(:,4);
    if (x_t_store(:,1) == 0)
        handPose = 0;
        directionMovement = 0;
        out = [handPose directionMovement];
        return
    end
    
    
    %% Take the mean over the past 3 datapoints or so
    xPosAverage = mean(xVel);
    yPosAverage = mean(yVel);
    x_dir = 1;
    y_dir = 1;
    %disp(['xPosAverage: ',num2str(xPosAverage),' yPosAverage:',num2str(yPosAverage)])
    if (xPosAverage < 0)
        x_dir = -1;
    end
    if (yPosAverage < 0)
        y_dir = -1;
    end
    xPosAverage = abs(xPosAverage);
    yPosAverage = abs(yPosAverage);
    
    if (xPosAverage > movementThreshold && yPosAverage > movementThreshold)
        % Do nothing
    elseif (xPosAverage > movementThreshold)
        if (x_dir == 1)
            directionMovement = NamedConst.move_left;
        else
            directionMovement = NamedConst.move_right;
        end
    elseif (yPosAverage > movementThreshold)
        if (y_dir == 1)
            directionMovement = NamedConst.move_down;
        else
            directionMovement = NamedConst.move_up;
        end
    else
        directionMovement = NamedConst.no_movement;
   
        
    end
    
    %% Classify and output it
    persistent labelOut count;
    [sizeX,sizeY,~] = size(cropped_image_output);
    if (~isempty(cropped_image_output) && sizeX*sizeY > 400)

%         [labelIdx, score] = predict(handClassifier.categoryClassifier, (imresize(cropped_image_output,[50 50])));
        
         %% Try to use HOG Features instead
         [hog_16x16, ~] = extractHOGFeatures((imresize(cropped_image_output,[50 50])),'CellSize',[16 16]);
         [labelIdx, score] = predict(handClassifier.categoryClassifier, hog_16x16);
           %% Now to temporarily store this to let for motion detection
        if (strcmp(handClassifier.categoryClassifier.ClassNames(1,:), labelIdx))
            labelIdx = 1;
        else
            labelIdx = 2;
        end
        score = abs(score(labelIdx));
        if (score < 0.3)
            tempHandPose = labelIdx;
        else
            tempHandPose = NamedConst.no_pose;   
        end
        
        if (tempHandPose ~= NamedConst.no_pose)
            handPose = tempHandPose;
            %labelOut = handClassifier.categoryClassifier.Labels(handPose);
            labelOut = handClassifier.categoryClassifier.ClassNames(handPose,:);
            count = 0;
        end
        
         count = count + 1;
        if (count > 10) % about two seconds
            count = 0;
            handPose = NamedConst.no_pose;
            labelOut = 'no_pose';
        end
        if (~exist('labelOut','var'))
            labelOut = 'no_pose';
            handPose = 0;
        end
        
        %disp(['handPose: ',num2str(handPose),' ',labelOut,' directionMovement', ...
        %    num2str(directionMovement),' ', NamedConst.move_string(directionMovement+1),' score: ', num2str(score)])

    else
        disp('nothing detected')
    end
    out = [handPose directionMovement];
    
  
end



  
    
    
            
        
        

    

