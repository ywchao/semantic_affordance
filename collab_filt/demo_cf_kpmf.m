
config;

load(mcoco_file);

% ensure reproducibility
rseed;

% set parameters
param.n_set       = 'pascal';
param.kernel_type = 'path';  % 'path', 'lch', 'wup'
param.gt_thres    = gt_thres;

param.kpmf.D        = 3;        % Latent dimension
param.kpmf.sigma_r  = 0.4;      % Variance of entries
param.kpmf.lambda   = 5;        % Variance for default kernel
param.kpmf.gamma    = 0.1;      % Parameter for graph kernel
param.kpmf.eta      = 0.01;     % Learning rate
param.kpmf.epsilon  = 1e-10;    % Tolerance
param.kpmf.init     = [];
param.kpmf.maxIters = 1000;
param.kpmf.minIters = 50;
param.kpmf.verbose  = false;

% print parameters
fprintf('params:\n');
fprintf('  n_set:          %s\n',param.n_set);
fprintf('  kernel_type:    %s\n',param.kernel_type);
fprintf('  gt_thres.score: %4.2f\n',param.gt_thres.score);
fprintf('  gt_thres.pos_n: %d\n',param.gt_thres.pos_n);
fprintf('  gt_thres.neg_n: %d\n',param.gt_thres.neg_n);
fprintf('  cf_base:        %s\n',cf_base);
fprintf('  eval_base:      %s\n',eval_base);
fprintf('kpmf params:\n');
fprintf('  D:        %d\n',param.kpmf.D);
fprintf('  sigma_r:  %4.2f\n',param.kpmf.sigma_r);
fprintf('  lambda:   %4.2f\n',param.kpmf.lambda);
fprintf('  gamma:    %4.2f\n',param.kpmf.gamma);
fprintf('  eta:      %.2e\n',param.kpmf.eta);
fprintf('  epsilon:  %.2e\n',param.kpmf.epsilon);
fprintf('  maxIters: %d\n',param.kpmf.maxIters);
fprintf('  minIters: %d\n',param.kpmf.minIters);

% run kpmf
cf_kpmf(param);

% evaluate kpmf
eval_kpmf(param);


