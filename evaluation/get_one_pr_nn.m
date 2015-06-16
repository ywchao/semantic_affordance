function [ PREC, REC, AP, SCORE, label, npos ] = get_one_pr_nn( gt_data, vid, score, num_exp, is_reset_seed )

if is_reset_seed
    rseed;
end

draw = false;

label = [gt_data.label];
npos  = sum(label == 1);

% vid and gt_data should be aligned
verb_syn = [gt_data.verb_syn];
assert(all(cellfun(@(x,y)strcmp(x,y)==1,{verb_syn.id},vid)));

% score should be either +1 or -1 
assert(all(score == 1 | score == -1));

ind_pos_nn = find(score == 1);
ind_neg_nn = find(score == -1);

npos_nn = numel(ind_pos_nn);
nneg_nn = numel(ind_neg_nn);

PREC  = zeros(num_exp,numel(score));
REC   = zeros(num_exp,numel(score));
AP    = zeros(num_exp,1);
SCORE = zeros(num_exp,numel(score));

for i = 1:num_exp
    perm_pos_nn = randperm(npos_nn);
    perm_neg_nn = randperm(nneg_nn);
    
    score_i = zeros(1,numel(score));
    score_i([ind_pos_nn(perm_pos_nn) ind_neg_nn(perm_neg_nn)]) = numel(score):-1:1;
    
    [rec,prec,ap] = eval_pr_score_label(score_i,label,npos,draw);
    PREC(i,:)  = prec';
    REC(i,:)   = rec';
    AP(i)      = ap;
    SCORE(i,:) = score_i;
end

end
