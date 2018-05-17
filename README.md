# Real time classification and tracking
This project is part of [this report](http://omar-abid.com/wp_portfolio/wp-content/uploads/2018/02/CSE-6329-HCI-Camera-Cursor-System-Report.pdf) that can be found on my [website](http://omar-abid.com). It involves using [HOG Features](https://en.wikipedia.org/wiki/Histogram_of_oriented_gradients) for feature extraction and using this as the input to a 3 layer neural network. 

The pipeline for hand tracking and classification is shown below.

**Show pipeline**

Object localization is performed using [background subtraction](https://en.wikipedia.org/wiki/Background_subtraction) and [Color Segmentation](https://en.wikipedia.org/wiki/Image_segmentation). The extracted subset of the image 


