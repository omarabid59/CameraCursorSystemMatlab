%% Hog Features

%%
% Load training and test data using imageSet.
trainDir   = 'tempFiles';

% imageSet recursively scans the directory tree containing the images.
trainingSet = imageSet(trainDir,   'recursive');


%% Choosing the right parameters
img = read(trainingSet(2), 4);

% Extract HOG features and HOG visualization
[hog_2x2, vis2x2] = extractHOGFeatures(img,'CellSize',[2 2]);
[hog_4x4, vis4x4] = extractHOGFeatures(img,'CellSize',[4 4]);
[hog_32x32, vis32x32] = extractHOGFeatures(img,'CellSize',[32 32]);
[hog_16x16, vis16x16] = extractHOGFeatures(img,'CellSize',[16 16]);

% Show the original image
figure;
subplot(2,3,1:3); imshow(img);

% Visualize the HOG features
subplot(2,3,4);
plot(vis2x2);
title({'CellSize = [2 2]'; ['Feature length = ' num2str(length(hog_2x2))]});

subplot(2,3,5);
plot(vis4x4);
title({'CellSize = [4 4]'; ['Feature length = ' num2str(length(hog_4x4))]});


subplot(2,3,6);
plot(vis16x16);
title({'CellSize = [16 16]'; ['Feature length = ' num2str(length(hog_16x16))]});


%% Set the appropriate parameters
cellSize = [16 16];
hogFeatureSize = length(hog_16x16);

%% Train using this

trainingFeatures = [];
trainingLabels   = [];

for digit = 1:numel(trainingSet)

    numImages = trainingSet(digit).Count;
    features  = zeros(numImages, hogFeatureSize, 'single');

    for i = 1:numImages

        img = read(trainingSet(digit), i);

        % Apply pre-processing steps
        lvl = graythresh(img);
        img = im2bw(img, lvl);

        features(i, :) = extractHOGFeatures(img, 'CellSize', cellSize);
    end

    % Use the imageSet Description as the training labels. The labels are
    % the digits themselves, e.g. '0', '1', '2', etc.
    labels = repmat(trainingSet(digit).Description, numImages, 1);

    trainingFeatures = [trainingFeatures; features];   %#ok<AGROW>
    trainingLabels   = [trainingLabels;   labels  ];   %#ok<AGROW>

end


%% Fit a model based on this shit
% fitcecoc uses SVM learners and a 'One-vs-One' encoding scheme.
classifier = fitcecoc(trainingFeatures, trainingLabels);



%% Now test. First extract the important key features
%[testFeatures, testLabels] = helperExtractHOGFeaturesFromImageSet(trainingSet, hogFeatureSize, cellSize);
[hog_16x16, vis16x16] = extractHOGFeatures(img,'CellSize',[16 16]);


%% Make class prediction based on this
predictedLabels = predict(classifier, hog_16x16);
