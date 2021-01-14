%% Initialization
clear ; close all; clc

addpath('./helpers');
addpath('./helpers/sigmoid');
addpath('./helpers/gradient_check');

%% Setup the parameters you will use for this exercise
input_layer_size  = 10000;  % 100x100 Input Images of Digits
hidden_layer_size = 25;     % 25 hidden units
num_labels = 10;            % 10 labels, from 1 to 10   
                            % (note that we have mapped "0" to label 10)
lambda = 1;

load('../DATA/node_data/X.csv');
load('../DATA/node_data/y.csv');



m = size(X, 1);

% Randomly select 100 data points to display
% sel = randperm(size(X, 1));
sel = X(1:100,:);

displayData(sel,100);

fprintf('Program paused. Press enter to continue.\n');
pause;


% Gradient Checking
% lambda = 3;
% checkNNGradients(lambda);

initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];


options = optimset('MaxIter', 50);
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);

[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));



save ("-binary", "trainded_nn_params.mat","nn_params");


pred = predict(Theta1, Theta2, X);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);



