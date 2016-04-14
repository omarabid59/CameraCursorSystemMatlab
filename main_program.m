clear all
%% Setup simulating the mouse
import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;
screenSize = get(0, 'screensize');
xScreenSize = screenSize(3);
yScreenSize = screenSize(4);
scalePercent = 0.8;
yB = round(scalePercent*yScreenSize);
xB = round(yB*(xScreenSize/yScreenSize));

%% Capture a series
% Here assume that the images are already captures
global cam prev_img curr_img;
% Cropped region of interest to send to 'classifyHandGesture'
global centroidBuffer dirBuffer;
global trackCoordinates;
global trackCoordinatesTemp;
global beginAKFTracking;
    
%% Initialize the variables
beginAKFTracking = 0;
trackCoordinates = [];
nBuffer = 10;
nSamples = 2;
sampleSize = 3;
centroidBuffer = zeros(nSamples,nBuffer);  % Initialize the buffer to zeroes
trackCoordinatesTemp = zeros(nSamples,floor(nBuffer/2));
dirBuffer = zeros(1,sampleSize);

%% Variables accessable to classifyHand Gesture
global x_t_store;
dataCollect = 2;
x_t_store = zeros(dataCollect,4); % [x,y,x_velocity,y_velocity]



imageSequenceFromFile = 0;
image_delay_period = 0.1;
delay_period = 0.05;

%% Setup the camera acquisition
cameraTimerFcn = timer('TimerFcn', @CameraAcquisition, 'Period', image_delay_period, 'ExecutionMode', 'fixedRate');

 %% Supress warnings
 warning('off','images:initSize:adjustingMag')

 %% start image acquisition
cam = webcam;
start(cameraTimerFcn)
disp ('Press any key to begin calibrating points');
% Calibrate the skin segmentation (temporarily)
%[mean_cr,mean_cb,sigma_cr,sigma_cb] = calibratePoints();
%sigma_cr = sigma_cr * 1.5;
%sigma_cb = sigma_cb * 1.5;
mean_cr = 134.7289;
mean_cb = 120.0473;
sigma_cr = 5;
sigma_cb = 5;

disp('Any key to continue')



%% Do all the initialization stuff
[ySize,xSize,~] = size(curr_img);
for i = 1:-1:1
    disp(['Beginning in: ',num2str(i)])
    pause(1)
end


showIm = false;
clickFlag = false;

%% run loop
while true
    img_t = curr_img;
    img_t_prev = prev_img;

    
    %% Use the Kalman Filter for tracking the location of the hand.

    % Step 1: get the points of interest
    if (beginAKFTracking == 0)
        [P_t,x_t,z_t, w_Q, w_r] = updateAKFTrack();
    else
        [~,~,z_t,~,~] = updateAKFTrack(); % After init, only need the estimation points
    end
    % Step 2 : Feed this into AKFTracking function
    if (beginAKFTracking == 1)
        [P_t, x_t w_Q w_r] =AKFTracking ( P_t , x_t , z_t,w_Q,w_r );
        x_t_store = [x_t_store(2:end,:); x_t'];
    end

    %% Display the box and image (trackHand draws the rectangle)
    [blob_cropped_image, left_point, right_point,top_point,bottom_point] = trackHand(curr_img,xSize,ySize);
    
    %% Full Screen
    if (~isempty(x_t))
        %% Control the mouse programatically
         x_new = round((x_t(1)/xSize)*xB + round((xScreenSize-xB)/2));
         y_new = round((x_t(2)/ySize)*yB + round((yScreenSize-yB)/2));
         
         x_v_new = round((x_t(3)/xSize)*xB + round((xScreenSize-xB)/2));
         y_v_new = round((x_t(4)/ySize)*yB + round((yScreenSize-yB)/2));
         %% Get the updated velocity and direction to move.
         %[p_x, p_y] = updateMouse(x_v_new,y_v_new);
         mouse.mouseMove(x_new,y_new);
         if (showIm==true)
            imshow(skin_seg_image)
            % This displays the current tracking of the AKF
            rectangle('Position',[floor(x_t(1)),floor(x_t(2)),5,5], ...
                'EdgeColor','r','LineWidth',2,'FaceColor',[0 0.5 0.5] )
            title ('Image with detected position from kalman filter...')
         end
    end

    %% Classify hand gesture and perform respective command
    cropped_image_output = img_t(top_point:min(top_point+bottom_point,ySize),left_point:min(left_point+right_point,xSize),:);
    
    
     outGestures = classifyHandGesture (blob_cropped_image);
     handPose = outGestures(1);
     directionMovement = outGestures(2);
     % When we see an open hand, reset the system to detect
     % further button clicks
     if (handPose == NamedConst.open_hand_pose)
         clickFlag = false;
     elseif (handPose == NamedConst.thumbs_up_pose && clickFlag == false)
         clickFlag = true;
         mouse.mousePress(InputEvent.BUTTON2_MASK);
         mouse.mouseRelease(InputEvent.BUTTON2_MASK);
         disp('Mouse clicked!')
     end
         
 
     if (handPose ~= 0 || directionMovement ~= 0)
         x_t_store = x_t_store * 0;
     end



    pause(delay_period) 
        
end



