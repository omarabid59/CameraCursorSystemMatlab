%% Sample AKFTracking Code

% Use the moving average to smooth out data over the last few points(in
% tempStuff.m) and give it here. Note that I should take into account the
% time interval so I can sync it. For the midway I won't consider this.
function [P_t,x_t,z_t w_Q w_r] = updateAKFTrack()
    global beginAKFTracking; % Used to set initial values for the kalman filter
    global trackCoordinatesTemp;

    numPoints = 2; %% Calculated over the last 5 points, which means 0.5 second interval
    %% Ensure that atleast 10 points are present else exit this tracking code.
    if (trackCoordinatesTemp(1,1) == 0)
        disp('Not enough data for tracking available')
        P_t = eye(4);
        x_t = [];
        z_t = [];
        w_Q = [];
        w_r = [];
        return;
    end
    xPosActual = tsmovavg(trackCoordinatesTemp(1,:),'s',numPoints);
    yPosActual = tsmovavg(trackCoordinatesTemp(2,:),'s',numPoints);

    xPosActual = xPosActual(numPoints:end);
    yPosActual = yPosActual(numPoints:end);

    xPosActual = mean(xPosActual);
    yPosActual = mean(yPosActual);
    if (beginAKFTracking == 0)
        xPosPredicted = xPosActual;
        yPosPredicted = yPosActual;
        xVelocityP = 0;
        yVelocityP = 0;
        P_t = eye(4);
        beginAKFTracking = 1;
        x_t = [xPosPredicted yPosPredicted xVelocityP yVelocityP]'; %% This is the predicted value
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
    z_t = [xPosActual yPosActual]; 
end