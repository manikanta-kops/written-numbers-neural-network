clear ; close all; clc

addpath('./helpers');
addpath('./helpers/sigmoid');
addpath('./helpers/gradient_check');

input_layer_size  = 10000;  % 100x100 Input Images of Digits
hidden_layer_size = 25;     % 25 hidden units
num_labels = 10;   


load('./trainded_nn_params.mat');

load('../DATA/X.csv');
load('../DATA/y.csv');

load('../DATA/CV/Xcv.csv');
load('../DATA/CV/ycv.csv');
% X = Xcv;
% y = ycv;


lambda = 0;
[error_train, error_val] = ...
    learningCurve([ones(size(X,1), 1) X], y, ...
                  [ones(size(Xcv, 1), 1) Xcv], ycv, ...
                  lambda);

plot(1:m, error_train, 1:m, error_val);
title('Learning curve for linear regression')
legend('Train', 'Cross Validation')
xlabel('Number of training examples')
ylabel('Error')
axis([0 13 0 150])

fprintf('# Training Examples\tTrain Error\tCross Validation Error\n');
for i = 1:m
    fprintf('  \t%d\t\t%f\t%f\n', i, error_train(i), error_val(i));
end

fprintf('Program paused. Press enter to continue.\n');