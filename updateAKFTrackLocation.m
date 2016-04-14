%% Sample AKFTracking Code
%% Modified to take in [left point, right point, top point, bottom point]  = new_coordinate
% Use the moving average to smooth out data over the last few points(in
% tempStuff.m) and give it here. Note that I should take into account the
% time interval so I can sync it. For the midway I won't consider this.
function [P_t,x_t,z_t w_Q w_r] = updateAKFTrackLocation(new_coordinate)
    global beginAKFTrackingLoc; % Used to set initial values for the kalman filter
    global trackCoordinatesLocation;

    numPoints = 2; %% Calculated over the last 5 points, which means 0.5 second interval
    %% If the list is originally empty update them
    if (isempty(trackCoordinatesLocation))
        nSamples = 4;
        nBuffer = 10;
        trackCoordinatesLocation = zeros(nSamples,floor(nBuffer/2));
    end
    
    %% Update location
    trackCoordinatesLocation = [trackCoordinatesLocation(:,2:end) floor(new_coordinate(:))];           
        
    %% Ensure that atleast 10 points are present else exit this tracking code.
    if (trackCoordinatesLocation(1,1) == 0)
        disp('Not enough data for tracking available')
        P_t = eye(4);
        x_t = [];
        z_t = [];
        w_Q = [];
        w_r = [];
        return;
    end
    averagePosVectorOutput = tsmovavg(trackCoordinatesLocation(:,:),'s',numPoints);
    xPosActual = tsmovavg(trackCoordinatesLocation(1,:),'s',numPoints);
    yPosActual = tsmovavg(trackCoordinatesLocation(2,:),'s',numPoints);

    xPosActual = xPosActual(numPoints:end);
    yPosActual = yPosActual(numPoints:end);
    averagePosVectorOutput = averagePosVectorOutput(:,numPoints:end);

    xPosActual = mean(xPosActual);
    yPosActual = mean(yPosActual);
    averagePosVectorOutput = mean(averagePosVectorOutput');
    if (isempty(beginAKFTrackingLoc))
        xPosPredicted = xPosActual;
        yPosPredicted = yPosActual;
        
        predictedPosVector = averagePosVectorOutput;
        predictedVelocityVector = zeros(1,length(predictedPosVector));
        
        xVelocityP = 0;
        yVelocityP = 0;
        P_t = eye(4);
        beginAKFTrackingLoc = 1;
        %x_t = [xPosPredicted yPosPredicted xVelocityP yVelocityP]'; %% This is the predicted value
        x_t = [predictedPosVector predictedVelocityVector]';
        w_Q = 1;
        w_r = 1;
    else
        %% Actual position (z_t) and predicted via kalman filter (x_t) 
         % Just so it doesn't complain
         x_t = [];
         P_t = [];
         w_Q = [];
         w_r = [];
    end
    z_t = [averagePosVectorOutput]; 
end