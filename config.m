
base_dir = [pwd '/'];

% change this to the path of the folder affordance_data/
data_dir = '/z/ywchao/datasets/affordance_data/';

mcoco_file = fullfile(data_dir,'mcoco.mat');
gt_base    = fullfile(base_dir,'cache/vn_gt/');
wnsim_base = fullfile(base_dir,'cache/wn_similarity/');
cf_base    = fullfile(base_dir,'cache/collab_filt/');
eval_base  = fullfile(base_dir,'cache/evaluation/');
vis_base   = fullfile(base_dir,'cache/visualize/');

% wordnet similarities
n_list_file = [wnsim_base 'n_mscoco_list'];
n_sim_file  = [wnsim_base 'n_mscoco_list_sim'];
n_sim_mat   = [wnsim_base 'n_sim_data_mscoco.mat'];
pos         = 'n';
is_sim_root = 0;

% gt thresholds
gt_thres.score = 4;
gt_thres.pos_n = 2;
gt_thres.neg_n = 2;

