function [blob_cropped_image,left_point, right_point,top_point,bottom_point] = findHand(A)
    sizeOfImage = size(A);
    if (length(sizeOfImage) < 3)
        left_point = 1;
        right_point = 1;
        top_point = 1;
        bottom_point = 1;
        return;
    end
    r = A(:, :, 1);             % red channel
    g = A(:, :, 2);             % green channel
    b = A(:, :, 3); 
    [h,w,~]=size(A);
    %% just show the redness
    %R = 0-80
    %G = 60-120
    %B > 100
    %imshow (r > 100)
    %% Relative color
    %R = r - max(g,b);
    %B = b - max(g,r);
    %G = g - max(r,b);

    im_thresh = (r<80 & g > 60 & g < 120 & b > 100);
    %imshow(im_thresh)

    %% Sub sample the image so we are not looking at the whole image
    [row ,col] = find(im_thresh);
    numPoints = length(row);
    thres = 25; % Minimum 20 points must be present in order to detect as a moving hand


    z = sortrows([col row],1);
    left_point = min(z(:,1));
    right_point = max(z(:,1))-left_point;
    top_point = min(z(:,2));
    bottom_point = max(z(:,2))-top_point;
    % Ensure they are within the boundary
    left_point = min(max(1,left_point),w);
    right_point = min(max(1,right_point),w);
    top_point = min(max(1,top_point),h);
    bottom_point = min(max(1,bottom_point),h);

    %% Cropped image
    cropped_image = im_thresh(top_point:top_point+bottom_point,left_point:left_point+right_point);
    %subplot(3,1,1)
    %imshow(cropped_image)



    %% fill holes
    se90 = strel('line', 3, 90);
    se0 = strel('line', 3, 0);
    BWsdil = imdilate(im_thresh, [se90 se0]);
    BWdfill = imfill(BWsdil, 'holes');
    %subplot(3,1,2)
    %imshow(BWdfill)

    %% Find largest blob
    largestBlob = bwlargestblob(BWdfill,8);
    %subplot(3,1,3)
    %imshow(largestBlob)

    %% Subsample on the largest blob
    [row ,col] = find(largestBlob);
    numPoints = length(row);
    thres = 25; % Minimum 20 points must be present in order to detect as a moving hand


    z = sortrows([col row],1);
    left_point = min(z(:,1));
    right_point = max(z(:,1))-left_point;
    top_point = min(z(:,2));
    bottom_point = max(z(:,2))-top_point;
    % Ensure they are within the boundary
    left_point = min(max(1,left_point),w);
    right_point = min(max(1,right_point),w);
    top_point = min(max(1,top_point),h);
    bottom_point = min(max(1,bottom_point),h);

    %% Cropped image
    blob_cropped_image = largestBlob(top_point:top_point+bottom_point,left_point:left_point+right_point);
    
end
