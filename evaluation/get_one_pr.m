function [ prec, rec, ap, score, label, npos ] = get_one_pr( gt_data, vid, score )

draw = false;

label = [gt_data.label];
npos  = sum(label == 1);

% vid and gt_data should be aligned
verb_syn = [gt_data.verb_syn];
assert(all(cellfun(@(x,y)strcmp(x,y)==1,{verb_syn.id},vid)));

if isempty(score)
    prec = 0;
    rec  = 0;
    ap   = 0;
else
    [rec,prec,ap] = eval_pr_score_label(score,label,npos,draw);
end

end
