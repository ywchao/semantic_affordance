function [  ] = cf_kpmf( param )
% affordance prediction using KPMF

config;

% set paramters
n_set       = param.n_set;
kernel_type = param.kernel_type;
gt_thres    = param.gt_thres;

D        = param.kpmf.D;        % Latent dimension
sigma_r  = param.kpmf.sigma_r;  % Variance of entries
lambda   = param.kpmf.lambda;   % Variance for default kernel
gamma    = param.kpmf.gamma;    % Parameter for graph kernel
eta      = param.kpmf.eta;      % Learning rate
epsilon  = param.kpmf.epsilon;  % Tolerance
init     = param.kpmf.init;
maxIters = param.kpmf.maxIters;
minIters = param.kpmf.minIters;
verbose  = param.kpmf.verbose;

postfix1 = sprintf('_%s_%s_d%d_s%4.2f_l%4.2f_g%4.2f', ...
    n_set, ...
    kernel_type, ...
    D, ...
    sigma_r, ...
    lambda, ...
    gamma ...
    );
postfix2 = sprintf('_vn_gt_%4.2f_%d_%d', ...
    gt_thres.score, ...
    gt_thres.pos_n, ...
    gt_thres.neg_n ...
    );

% make directories
makedir(cf_base);

% load nname
NNAME = load_nname(n_set);
NNAME = sort(NNAME);  % for reproducibility
num_noun = numel(NNAME);

% load gt
gt_dir = [gt_base sprintf('vn_gt_%4.2f_%d_%d/',gt_thres.score,gt_thres.pos_n,gt_thres.neg_n)];
[GTMAT,VNAME,VID] = build_matrix(gt_dir,NNAME);  %#ok

% load kernel
vis_base  = [cf_base 'vis_n_kernel/'];
n_kernel  = load_kernel(n_sim_mat, NNAME, 'NNAME', kernel_type, vis_base, n_set);
GK        = graphKernel(n_kernel, gamma);
K_u_inv   = inv(GK);
K_v_inv   = lambda*eye(size(GTMAT,2),size(GTMAT,2));
        
% run cf_nn
fprintf('running cf_kpmf ... \n');

% init variables
UU   = cell(num_noun,1);
VV   = cell(num_noun,1);
PRED_RAW = zeros(size(GTMAT));
PRED_OUT = zeros(size(GTMAT));

% start prediction
for n = 1:num_noun
    tot_th = tic;
    nname = NNAME{n};
    fprintf('  test on %02d %-15s   ',n,nname);
    
    trainSet      = GTMAT;
    trainSet(n,:) = 0;
    mask_train    = ones(size(trainSet)) & trainSet;

    % run kpmf
    [U, V, ~, ~, numIters] = kpmf_gd_ywc( ...
        trainSet, ...
        mask_train, ...
        D, ...
        K_u_inv, ...
        K_v_inv, ...
        sigma_r, ...
        eta, ...
        trainSet, ...
        mask_train, ...
        init, ...
        epsilon, ...
        maxIters, ...
        minIters, ...
        verbose ...
        );
    
    % get the prediction
    R_raw = U*V';
    R_out = R_raw;
    R_out(R_out >= 0) = 1;
    R_out(R_out < 0)  = -1;
    pred_raw = R_raw(n,:);
    pred_out = R_out(n,:);
    
    fprintf('iter: %04d  ',numIters);
    fprintf('(mu,std) = (%6.4f,%6.4f)  ',mean(pred_raw),std(pred_raw));
    fprintf('#pos: %3d  #neg: %3d   ',sum(pred_out==1),sum(pred_out==-1));
    fprintf('time: %.3fs',toc(tot_th));
    fprintf('\n');
    
    % save result
    UU{n} = U;
    VV{n} = V;
    PRED_RAW(n,:) = pred_raw;
    PRED_OUT(n,:) = pred_out;
end


% save result
res_file = [cf_base sprintf('res_kpmf%s%s.mat',postfix1,postfix2)];
if ~exist(res_file,'file')
    save(res_file,'NNAME','VID','VNAME','GTMAT','UU','VV','PRED_RAW','PRED_OUT');
end

fprintf('done.\n');

