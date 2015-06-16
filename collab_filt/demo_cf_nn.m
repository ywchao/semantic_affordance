
config;

load(mcoco_file);

% ensure reproducibility
rseed;

% set parameters
param.n_set       = 'pascal';
param.kernel_type = 'path';  % 'path', 'lch', 'wup'
param.gt_thres    = gt_thres;

% print parameters
fprintf('params:\n');
fprintf('  n_set:          %s\n',param.n_set);
fprintf('  kernel_type:    %s\n',param.kernel_type);
fprintf('  gt_thres.score: %4.2f\n',param.gt_thres.score);
fprintf('  gt_thres.pos_n: %d\n',param.gt_thres.pos_n);
fprintf('  gt_thres.neg_n: %d\n',param.gt_thres.neg_n);
fprintf('  cf_base:        %s\n',cf_base);
fprintf('  eval_base:      %s\n',eval_base);

% run nn
cf_nn(param);

% evaluate nn
eval_nn(param);


