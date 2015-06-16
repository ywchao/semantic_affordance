function [ pass ] = check_one_verb( score, hist, thres )


cond1 = score >= thres.score;
cond2 = sum(hist == 1 | hist == 2) >= thres.pos_n;
cond3 = sum(hist == 4 | hist == 5 | hist == 6) <= thres.neg_n;

pass = cond1 ...
    && cond2 ...
    && cond3;

end

