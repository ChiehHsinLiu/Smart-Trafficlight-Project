vid = videoinput('macvideo', 2);
start(vid);
inputSize = net.Layers(1).InputSize(1 : 2) % resize the input image

h = figure;

while
    ishandle(h) % continue capturing image from the webcam
    im = getsnapshot(camera);
    image(im)
    im = imresize(im, inputSize);
    [ label, score ] = classify(net, im);
    title({char(label), num2str(max(score), 2)});
    drawnow
end

digitDatasetPath = fullfile('/Users/liujiexin/MATLAB/projects/lab2/image');
imds = imageDatastore(digitDatasetPath, ... 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
% use file names as the label name
numTrainFiles = 75; %number of training set

[imdsTrain, imdsValidation] =
    splitEachLabel(imds, numTrainFiles, 'randomize');
layers = [
    imageInputLayer([244 244 3])
    convolution2dLayer(3, 8, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
        
    maxPooling2dLayer(2, 'Stride', 2)
    convolution2dLayer(3, 16, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    Evaluate the classifier code:
    maxPooling2dLayer(2, 'Stride', 2)
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];
    
options = trainingOptions('sgdm', ... 
    'InitialLearnRate', 0.01, ... 
    'MaxEpochs', 4, ... 
    'Shuffle', 'every-epoch', ... 
    'ValidationData', imdsValidation, ... 
    'ValidationFrequency', 30, ... 
    'Verbose', false, ... 'Plots', 'training-progress');
net = trainNetwork(imdsTrain, layers, options);

%load pretrained network
net = resnet50();
%create augmentedImageDatastore for resize dataset
%resize images and make images RGB
imageSize = net.Layers(1).InputSize;
augmentedTrainingSet = augmentedImageDatastore(imageSize, trainingSet,
'ColorPreprocessing', 'gray2rgb');
augmentedTestSet = augmentedImageDatastore(imageSize, testSet,
'ColorPreprocessing', 'gray2rgb');
featureLayer = 'fc1000';
%train multiclass SVM classifier using a fast linear solver
trainingFeatures = activations(net, augmentedTrainingSet, featureLayer,
...
    'MiniBatchSize', 32, 'OutputAs', 'columns');
%extract features
testFeatures = activations(net, augmentedTestSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');
%pass image features to trained classifier
predictedLabels = predict(classifier, testFeatures, 'ObservationsIn',
'columns');
testLabels = testSet.Labels;

%make confusion matrix
confMat = confusionmat(testLabels, predictedLabels);
%convert confusion matrix to percentage
confMat = bsxfun(@rdivide,confMat,sum(confMat,2))
%mean accuracy rate
mean(diag(confMat))