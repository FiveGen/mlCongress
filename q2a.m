function q2a()
% This script requires the following functions to be implemented:
% q2_initialize
% q2_predict
% q2_loglik
% q2_gradient
% q2_train
% q2_error

%assert(checking('q2a')==0);


% load data
%S = load('parkinsons.mat');
%X = S.trainsetX;
%Y = S.trainsetY;
%disp(size(X));
%disp(size(Y));

labels = dlmread('./labels.txt', ',');
X = dlmread('./topic_dist.txt', ','); %X is m x K, where X(m, k) = P(topic k | document m)
disp(size(X));
Y = [ones(labels(1), 1); zeros(labels(2), 1)];

Xtest = dlmread('./topic_dist_test.txt', ',');
disp(size(Xtest));
Ytest = [ones(labels(3), 1); zeros(labels(4), 1)];
disp('---');
%   146    22

%   146     1

%Xtest = S.testsetX;
%Ytest = S.testsetY;

clear S;

% add constant feature set to 1 in order to implement the bias term
m = size(X,1);
X = [ones(m,1) X];
m = size(Xtest,1);
Xtest = [ones(m,1) Xtest];


alpha = 1e-6; % learning rate / step size
tol = 6; % tolerance on the norm of the gradient to decide when to stop

% initialize weights
theta_init = q2_initialize(X, Y, 'heuristic');

[theta, n_iter, loglik] = q2_train(X, Y, theta_init, alpha, tol);

[pred_Y, ~] = q2_predict(X, theta);
train_error = q2_error(Y, pred_Y);

[pred_Ytest, ~] = q2_predict(Xtest, theta);
test_error = q2_error(Ytest, pred_Ytest);

fprintf('Number of iterations: %d\n', n_iter);
fprintf('Misclassification rate on the training set: %f%%\n', train_error*100);
fprintf('Misclassification rate on the test set: %f%%\n', test_error*100);

% close figures
close all;

plot(1:n_iter, loglik, 'o-');
%disp(size(loglik));
%axis([1, n_iter, -210.872, -210.8704])
%dlmwrite('./loglik_niter.txt', )
ylabel('Log likelihood');
title('Log likelihood as a function of the number of iterations');
xlabel('Number of iterations');
grid on;

saveas(gcf, 'Loglik.fig');
