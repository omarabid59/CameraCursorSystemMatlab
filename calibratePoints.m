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
    %figure;
    %imshow(B)
    YcBcRMap = rgb2ycbcr(B);
    Y_comp = YcBcRMap(:,:,1); % Don't need this
    cB_comp = YcBcRMap(:,:,2);
    cR_comp = YcBcRMap(:,:,3);
    
    mean_cr = mean2(cR_comp);
    mean_cb = mean2(cB_comp);
    sigma_cr = std2(cR_comp);
    sigma_cb = std2(cB_comp);
    
    sigma_cr = max(5,sigma_cr);
    sigma_cb = max(5,sigma_cb);
    
end