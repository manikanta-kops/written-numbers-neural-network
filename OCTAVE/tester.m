
clear ; close all; clc

addpath('./helpers');
addpath('./helpers/sigmoid');
addpath('./helpers/gradient_check');

input_layer_size  = 10000;  % 100x100 Input Images of Digits
hidden_layer_size = 25;     % 25 hidden units
num_labels = 10;   


load('./trainded_nn_params.mat');



% load('../DATA/X.csv');
% load('../DATA/y.csv');

load('../DATA/node_data/test_set/X.csv');
load('../DATA/node_data/test_set/y.csv');
sel = X(1:100,:);

displayData(sel,100);

fprintf('Program paused. Press enter to continue.\n');
pause;


Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));






pred = predict(Theta1, Theta2, X)

AB = [pred, y]




fprintf('\nCross validation Set Accuracy: %f\n', mean(double(pred == y)) * 100);