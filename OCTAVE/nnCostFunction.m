function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));


m = size(X, 1);
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

X = [ones(m, 1) X];
a2 = sigmoid(X*Theta1');
a2 = [ones(size(a2,1),1) a2];
a3 = sigmoid(a2*Theta2');
yv=[1:num_labels] == y;
cost=0;

for i=1:m,
    for k=1:num_labels,
        currentY = yv(i,k);
        currentHypothesis = a3(i,k);
        cost = cost + currentY*log(currentHypothesis)+((1-currentY) * log(1-currentHypothesis));
    end;
end;

J = (-1/m)*cost;

% Regularization term
% Since its three lays

%first layer
firstLayerInputLength = input_layer_size + 1;
firstLayerOutPutSize = hidden_layer_size;
layer1regularization = 0;
for o=1:firstLayerOutPutSize,
    for i = 2:firstLayerInputLength,
        layer1regularization = layer1regularization + Theta1(o,i)^2;
    end;
end;


%second layer
secondLayerInputSize = hidden_layer_size + 1;
secondLayerOutputSzize = num_labels;
layer2regularization = 0;
for o=1:secondLayerOutputSzize,
    for i = 2:secondLayerInputSize,
          layer2regularization = layer2regularization + Theta2(o,i)^2; 
    end;
end;

finalRegularization = (lambda/(2*m)) * (layer1regularization + layer2regularization);
J = J + finalRegularization;


% for t=1:m,

a1 = X;
z2 = a1*Theta1';
a2 = sigmoid(z2);
a2 = [ones(m, 1) a2];
z3 = a2 * Theta2';
a3 = sigmoid(z3);
delta_3 = a3 - yv;


delta_2 = (delta_3 * Theta2(:,2:end)) .* sigmoidGradient(z2);


DELTA_1 = delta_2' * a1;
DELTA_2 = delta_3' * a2;

Theta1_grad = (1/m) * DELTA_1;
Theta2_grad = (1/m) * DELTA_2;


Theta1_first_column = Theta1(:,1);
Theta2_first_column = Theta2(:,1);

Theta1(:,1) = 0;
Theta2(:,1) = 0;


Theta1 = ((lambda/m) * Theta1);
Theta2 = (lambda/m) * Theta2;

Theta1_grad = Theta1_grad + Theta1;
Theta2_grad = Theta2_grad + Theta2;

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];



end
