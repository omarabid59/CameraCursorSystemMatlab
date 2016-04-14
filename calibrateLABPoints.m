function [mean_cr,mean_cb,sigma_cr,sigma_cb] = calibratePoints()
    global curr_img;
    button = 0;
    disp('Click to take picture')
    for i = 5:-1:1
       imshow(curr_img) 
       disp(['Picture in ', num2str(i),' seconds'])
       pause(1)
    end
    
    A = curr_img;
    %A = a;
    imshow(A)
    disp('Please choose points for calibration')
    [x,y] = ginput(4);
    % Bind a box around the four given points
    minX = floor(min(x));
    minY = floor(min(y));
    maxX = floor(max(x));
    maxY = floor(max(y));
    % Take out this image portion
    B = A(minY:maxY,minX:maxX,:);

    %% Convert to other 
    segment = rgb2lab(B);
    whole_image = rgb2lab(A);
    

    %% Calculate the means
    a = segment(:,:,2);
    b = segment(:,:,3);
    aW = whole_image(:,:,2);
    bW = whole_image(:,:,2);
    color_markers = zeros([1, 2]);

    color_marks(1) = mean2(a);
    color_marks(2) = mean2(b);
    
    %% Classify each pixel with NN rule
    color_labels = 0;
    aW = double(aW);
    bW = double(bW);
    distance = zeros(size(aW));
    distance(:,:) = ( (aW - color_markers(1)).^2 + ...
                          (bW - color_markers(2)).^2 ).^0.5;

    [~, label] = min(distance,[],3);
    label = color_labels(label);
    clear distance;
    
    %% Display results for red
    rgb_label = repmat(label,[1 1 3]);
    segmented_images = zeros(size(A),'uint8');

    
      color = A;
      color(rgb_label ~= color_labels) = 0;
      segmented_images(:,:,:) = color;
   

    imshow(segmented_images(:,:,:)), title('red objects');

    
end