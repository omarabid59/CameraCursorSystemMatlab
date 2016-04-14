function [blob_cropped_image, left_point, right_point,top_point,bottom_point] = trackHand(k,w_image,l_image)
    global trackCoordinates;
    global trackCoordinatesTemp;
    [blob_cropped_image, left_point, right_point,top_point,bottom_point] = findHand(k);

    xCenter = left_point + round(right_point/2);
    yCenter = top_point + round(bottom_point/2);
    
    if (isempty(left_point) |isempty(right_point) |isempty(top_point)| isempty(bottom_point) & numPoints > thres)
        left_point = -1;
        right_point = -1;
        top_point = -1;
        bottom_point = -2;
        temp = [-1 -1];
        trackCoordinates = [trackCoordinates; -1 -1];
        %trackCoordinatesTemp = [trackCoordinatesTemp(:,2:end) temp(:)];
    else
        %rectangle('Position',[left_point,top_point,right_point,bottom_point], 'EdgeColor','r','LineWidth',2 )
        temp = [floor(xCenter) floor(yCenter)];
        trackCoordinates = [trackCoordinates; floor(xCenter) floor(yCenter)];
        trackCoordinatesTemp = [trackCoordinatesTemp(:,2:end) temp(:)];           
    end
    
    
    %% Begin testing the kalman filter
    global beginAKFTrackingLocation;
    % Step 1: get the points of interest
    if (isempty(beginAKFTrackingLocation))
        track_location = [];
        [P_t_x,track_location,observed_location, w_Q_x, w_r_x] = updateAKFTrackLocation([left_point right_point top_point bottom_point]);
        P_t_y = P_t_x;
        w_Q_y = w_Q_x;
        w_r_y = w_r_x;
        if (~isempty(track_location))
          track_location_x = [track_location(1:2); track_location(5:6)];
          track_location_y = [track_location(3:4); track_location(7:8)];
          beginAKFTrackingLocation = 1;
        end
    else
        [~,~,observed_location,~,~] = updateAKFTrackLocation([left_point right_point top_point bottom_point]); % After init, only need the estimation points
    end
    %% Step 2 : Feed this into AKFTracking function
    if (exist('track_location','var'))
        if (~isempty(track_location))
        
        %[P_t_x, track_location_x w_Q_x w_r_x] =AKFTracking ( P_t_x , track_location_x , observed_location(1:2), w_Q_x, w_r_x );
        %[P_t_y, track_location_y w_Q_y w_r_y] =AKFTracking ( P_t_y , track_location_y , observed_location(3:4), w_Q_y, w_r_y );
        [P_t_x, track_location_x w_Q_x w_r_x] =AKFTracking ( P_t_x , track_location_x , [left_point right_point], w_Q_x, w_r_x );
        [P_t_y, track_location_y w_Q_y w_r_y] =AKFTracking ( P_t_y , track_location_y , [top_point bottom_point], w_Q_y, w_r_y );
%        x_t_store = [x_t_store(2:end,:); track_location_x'];
        %left_point = track_location_x(1);
        right_point = track_location_x(2);
        %top_point = track_location_y(1);
        bottom_point = track_location_y(2);
        end
    end
    
    
    
    left_point = min(max(1,round(left_point)),w_image);
    top_point = min(max(1,round(top_point)),l_image);
    right_point = min(min(left_point+right_point,w_image),right_point);
    bottom_point = min(min(left_point+bottom_point,w_image),bottom_point);
    

end


