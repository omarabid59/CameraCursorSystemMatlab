    
function CameraAcquisition(~,~)
  global cam prev_img curr_img;
  
  h = fspecial('gaussian',[5 5],2);
  scale = 0.4;
  if (isempty(prev_img))
      prev_img = imresize(snapshot(cam),scale);
      A(:,:,1) = conv2(double(prev_img(:,:,1)),h);
      A(:,:,2) = conv2(double(prev_img(:,:,2)),h);
      A(:,:,3) = conv2(double(prev_img(:,:,3)),h);
      prev_img = fliplr(uint8(A));
  else      
      prev_img = curr_img;
  end

  
  curr_img = snapshot(cam);
  curr_img = imresize(curr_img,scale);
  A(:,:,1) = conv2(double(curr_img(:,:,1)),h);
  A(:,:,2) = conv2(double(curr_img(:,:,2)),h);
  A(:,:,3) = conv2(double(curr_img(:,:,3)),h);
  curr_img = fliplr(uint8(A));


end 
