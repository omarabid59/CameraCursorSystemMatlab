function trainNewImageClassifier()
    global cam curr_img prev_img;
    delay_period = 0.1;
    global handClassifier;
    xSize = 0;
    
    %% Setup the camera acquisition
    cameraTimerFcn = timer('TimerFcn', @CameraAcquisition, 'Period', delay_period, 'ExecutionMode', 'fixedRate');
    cam = webcam;
    start(cameraTimerFcn)
    disp('Camera started successfully')
    while (xSize == 0)
        [ySize,xSize,~] = size(curr_img);
    end
    disp(['xSize ',num2str(xSize),' ySize ',num2str(ySize)]);
    pause
    
    
    %% Get the images
    numImages = 250;
    disp ('Please calibrate the one finger pose')
    pause
    bunnyPose = zeros(50,50,numImages);
    for i = 1:numImages
        bunnyPose(:,:,i) = getImage();
        if (mod(i,10) == 0)
            disp(['Current Image: ',num2str(i)]);
        end
        pause(delay_period)
    end
    disp ('Please calibrate the null hand pose')
    pause
    openHandPose = zeros(50,50,numImages);
    for i = 1:numImages
        openHandPose(:,:,i) = getImage();
        if (mod(i,10) == 0)
            disp(['Current Image: ',num2str(i)]);
        end
        pause(delay_period)
    end
    %{
    disp ('Please calibrate the fist pose')
    pause
    fistPose = zeros(50,50,numImages);
    for i = 1:numImages
        fistPose(:,:,i) = getImage();
        if (mod(i,10) == 0)
            disp(['Current Image: ',num2str(i)]);
        end
        pause(delay_period)
    end
    
    disp ('Please calibrate the thumbs up pose')
    pause
    thumbsUpPose = zeros(50,50,numImages);
    for i = 1:numImages
        thumbsUpPose(:,:,i) = getImage();
        if (mod(i,10) == 0)
            disp(['Current Image: ',num2str(i)]);
        end
        pause(delay_period)
    end
    %}
    %% Store this into specific folders temporarily
    folderDir = 'tempFiles/';
    bunnyDir = 'thumbsUp/';
    openHandDir = 'nullPose/';
    fistDir = 'fist/';
    thumbsUpDir = 'thumbsUp/';
    mkdir([folderDir,bunnyDir])
    mkdir([folderDir,openHandDir])
    mkdir([folderDir,fistDir])
    mkdir([folderDir,thumbsUpDir])

    for i = 1:numImages
        imwrite((bunnyPose(:,:,i)),[folderDir,bunnyDir,num2str(i),'.jpg']);
        imwrite((openHandPose(:,:,i)),[folderDir,openHandDir,num2str(i),'.jpg']);
        %imwrite(uint8(fistPose(:,:,i)),[folderDir,fistDir,num2str(i),'.jpg']);
        %imwrite(uint8(thumbsUpPose(:,:,i)),[folderDir,thumbsUpDir,num2str(i),'.jpg']);
    end
    
    
    %% get the directory
    imgSets = imageSet('tempFiles', 'recursive');
    %%
    [trainingSets, testSets] = partition(imgSets, 0.7, 'randomize');

    %%
    bag = bagOfFeatures(trainingSets,'Verbose',false);
    %%
    categoryClassifier = trainImageCategoryClassifier(trainingSets, bag);
    
    %% clean up
    
    
    handClassifier.categoryClassifier = categoryClassifier;

    
    %rmdir('tempFiles','s')
    function img_out = getImage()
            img_t = curr_img;
            img_t_prev = prev_img;


            %% Display the box and image (trackHand draws the rectangle)
            [left_point, right_point,top_point,bottom_point] = trackHand(curr_img,xSize,ySize);

            %% Full Screen
            subplot(2,1,1)
            imshow(img_t)
            
               

            %% Output cropped image
            cropped_image_output = img_t(top_point:top_point+bottom_point,left_point:left_point+right_point,:);
            subplot(2,1,2)
            imshow(uint8(cropped_image_output))
            img_out = cropped_image_output;
            if (~isempty(img_out))
                 %img_out = imresize(rgb2gray(img_out),[50 50]);
                 img_out = imresize((img_out),[50 50]);
            else
                img_out = getImage();
            end
    end


end


