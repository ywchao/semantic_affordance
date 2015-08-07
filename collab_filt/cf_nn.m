function [  ] = cf_nn( param )
% affordance prediction using NN

config;

% set paramters
n_set       = param.n_set;
kernel_type = param.kernel_type;
gt_thres    = param.gt_thres;
postfix1    = sprintf('_%s_%s',n_set,kernel_type);
postfix2    = sprintf('_vn_gt_%4.2f_%d_%d',gt_thres.score,gt_thres.pos_n,gt_thres.neg_n);

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

% run cf_nn
fprintf('running cf_nn ... \n');

PRED_RAW = zeros(num_noun,size(GTMAT,2));
for n = 1:num_noun
    nname = NNAME{n};
    fprintf('  test on %02d %-15s   ',n,nname);
    
    [~,ii] = sort(n_kernel(n,:),'descend');
    ii = ii(2);
    fprintf('nn: %-15s  ',NNAME{ii});
    
    PRED_RAW(n,:) = GTMAT(ii,:);
    fprintf('#pos: %3d  #neg: %3d',sum(PRED_RAW(n,:)==1),sum(PRED_RAW(n,:)==-1));
    fprintf('\n');
end

% save result
res_file = [cf_base sprintf('res_nn%s%s.mat',postfix1,postfix2)];
if ~exist(res_file,'file')
    save(res_file,'NNAME','VID','VNAME','GTMAT','PRED_RAW');
end

fprintf('done.\n');

