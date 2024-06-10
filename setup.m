
config;

% get ground-truth binary labels
get_gt_run;
fprintf('\n');

% get wordnet similarities for mscoco objects
%   WordNet and the NLTK python package are required for runnning
%   get_wn_sim_run.m
try
    get_wn_sim_run;
catch err
    if ~exist(n_sim_mat,'file')
        system('wget https://umich-ywchao-semantic-affordance.github.io/data/wn_similarity.tar.gz -P cache');
        system('tar -zxvf cache/wn_similarity.tar.gz -C cache');
    end
    fprintf('done.\n');
end
fprintf('\n');

% download kpmf code
kpmf_dir = '3rd_party/kpmf/';
if ~exist(kpmf_dir,'dir')
    fprintf('downloading kpmf code ... \n');
    system('wget http://www.eecs.berkeley.edu/~tinghuiz/code/kpmf.zip -P 3rd_party');
    system('unzip 3rd_party/kpmf.zip -d 3rd_party');
    fprintf('done.\n\n');
end

% add paths
addPaths;

fprintf('setup finished.\n');