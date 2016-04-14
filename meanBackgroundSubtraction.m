%% Attempt a mean filter
function meanBackgroundSubtraction(img_t)
    persistent prev_img sizeX sizeY dim;
    persistent numImages = 5; % Number of images to do the averaging over
    if (isempty(prev_img))
        [sizeX, sizeY, dim] = size(img_t);
        prev_img = zeros(sizeX,sizeY,dim,numImages);
    end
    
    
    trackCoordinates = [trackCoordinates; floor(xCenter) floor(yCenter)];
    
    nBuffer = 10;
    nSamples = [10 10 3];
    
    
    trackCoordinatesTemp = zeros(nSamples,floor(nBuffer/2));
 
    
    temp_img = zeros(sizeX,sizeY,dim,5);