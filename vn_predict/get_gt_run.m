% generate the ground-truth binary labels from the affordance scores

config;

% load mcoco_list
load(mcoco_file);

% get ids & nnames
ID    = [mcoco_list.id]';
NNAME = {mcoco_list.name}';
NNAME = cellfun(@(x)strrep(x,' ','_'),NNAME,'UniformOutput',false);

fprintf('generating ground-truth binary labels ... \n');

gt_dir = [gt_base sprintf('vn_gt_%4.2f_%d_%d/',gt_thres.score,gt_thres.pos_n,gt_thres.neg_n)];
makedir(gt_dir);

fprintf('  gt_thres.score: %4.2f\n',gt_thres.score);
fprintf('  gt_thres.pos_n: %d\n',gt_thres.pos_n);
fprintf('  gt_thres.neg_n: %d\n',gt_thres.neg_n);
fprintf('  gt_dir:         %s\n',gt_dir);

for n = 1:numel(ID)
    fprintf('    %02d %-15s  ',ID(n),NNAME{n});
    
    gt_mat = [gt_dir NNAME{n} '_gtdata.mat'];
    if ~exist(gt_mat,'file')
        % load affordance data
        data_file = fullfile(data_dir,sprintf('%02d_%s.mat',ID(n),NNAME{n}));
        load(data_file,'data');
        
        % determine pos/neg
        ISPASS = false(numel(data),1);
        for i = 1:numel(data)
            ISPASS(i) = check_one_verb(data(i).score,data(i).raw_anno,gt_thres);
        end
        
        % get pos/neg input
        data_pos = data(ISPASS);
        data_neg = data(~ISPASS);
        
        [~,ii] = sort([data_pos.score],'descend');
        data_pos = data_pos(ii);
        [~,ii] = sort([data_neg.score],'descend');
        data_neg = data_neg(ii);
        
        % save the input mat file
        [data_pos.label] = deal(1);
        [data_neg.label] = deal(-1);
        data = [data_pos; data_neg];
        save(gt_mat,'data');
    else
        load(gt_mat);
    end
    
    fprintf('pos: %d  ',sum([data.label] == 1));
    fprintf('neg: %d  ',sum([data.label] == -1));
    fprintf('\n');
end
    
fprintf('done.\n');

