function [  ] = eval_nn( param )

config;

% ensure reproducibility
rseed;  

% set parameters
num_exp     = 10000;  % number of random permutations
n_set       = param.n_set;
kernel_type = param.kernel_type;
gt_thres    = param.gt_thres;
postfix1    = sprintf('_%s',kernel_type);
postfix2    = sprintf('_vn_gt_%4.2f_%d_%d',gt_thres.score,gt_thres.pos_n,gt_thres.neg_n);

% make directories
makedir(eval_base);

% gt path
gt_dir = [gt_base sprintf('vn_gt_%4.2f_%d_%d/',gt_thres.score,gt_thres.pos_n,gt_thres.neg_n)];

% load result
res_file = [cf_base sprintf('res_nn%s%s.mat',postfix1,postfix2)];
res      = load(res_file);

% get color code
switch n_set
    case 'pascal'
        ccode = get_pascal_color_code();
end

% evaluate cf_nn
fprintf('evaluating cf_nn ... \n');

RAND  = zeros(numel(res.NNAME),1);
PREC  = cell(numel(res.NNAME),1);
REC   = cell(numel(res.NNAME),1);
AP    = zeros(numel(res.NNAME),1);
LEG   = cell(numel(res.NNAME),1);

for n = 1:numel(res.NNAME)
    nname = res.NNAME{n};
    fprintf('  %02d %-15s  ',n,nname);
    
    % load gt
    %   sort the verbs by wids; this will make a difference when some 
    %   scores are the same
    gt_file = [gt_dir nname '_gtdata.mat'];
    gt_data = load(gt_file);
    verb_syn = [gt_data.data.verb_syn];
    [~,ii] = sort({verb_syn.id});
    gt_data.data = gt_data.data(ii);
    
    % get rand ap
    npos    = sum([gt_data.data.label] == 1);
    RAND(n) = npos/numel(gt_data.data);
    
    % load pred
    vid  = res.VID;
    score = res.PRED_RAW(n,:);
    [vid,ii] = sort(vid);
    score    = score(ii);

    % get ap
    [prec, rec, ap] = get_one_pr_nn( ...
        gt_data.data, ...
        vid, ...
        score, ...
        num_exp, ...
        false ...
        );
    PREC{n} = mean(prec,1);
    REC{n}  = mean(rec,1);
    AP(n)   = mean(ap);
    LEG{n}  = strrep(nname,'_',' ');
    
    fprintf('ap: %4.1f%% / rand ap: %4.1f%%\n',100*AP(n),100*RAND(n));
end
fprintf('  %s\n',repmat('-',[1 46]));
fprintf('  mean:               ap: %4.1f%% / rand ap: %4.1f%%\n',100*mean(AP),100*mean(RAND));

% save result
eval_file = [eval_base sprintf('eval_nn%s%s.mat',postfix1,postfix2)];
if ~exist(eval_file,'file')
    save(eval_file,'RAND','PREC','REC','AP','LEG');
else
    load(eval_file);
end

% plot pr curves
fig_name = [eval_base sprintf('pr_nn%s%s.pdf',postfix1,postfix2)];
if exist(fig_name,'file') == 0
    figure(1); clf;
    plot_one_pr(PREC,REC,AP,RAND,LEG,ccode);
    print(gcf,fig_name,'-dpdf');
    close;
end

fprintf('done.\n');

end

