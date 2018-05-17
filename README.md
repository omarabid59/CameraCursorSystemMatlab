# Real time classification and tracking
This project is part of [this report](http://omar-abid.com/wp_portfolio/wp-content/uploads/2018/02/CSE-6329-HCI-Camera-Cursor-System-Report.pdf) that can be found on my [website](http://omar-abid.com). It involves using [HOG Features](https://en.wikipedia.org/wiki/Histogram_of_oriented_gradients) for feature extraction and using this as the input to a 3 layer neural network. 

The pipeline for hand tracking and classification is shown below.

![Image Processing Pipeline](https://github.com/omarabid59/Hand-Gesture-and-Tracking-as-a-Mouse/blob/master/image_processing_pipeline.png)

Object localization is performed using [background subtraction](https://en.wikipedia.org/wiki/Background_subtraction) and [Color Segmentation](https://en.wikipedia.org/wiki/Image_segmentation). The extracted subset of the image using these two methods is combined together using a weighting function and the result is a binary output with an example shown below.

![Gesture Binary Output](https://github.com/omarabid59/Hand-Gesture-and-Tracking-as-a-Mouse/blob/master/hci_project_image.png)

This project is no longer maintained. If you would like more information to get it up and working, contact me at omar(dot)abid4(at)gmail(dot)com


