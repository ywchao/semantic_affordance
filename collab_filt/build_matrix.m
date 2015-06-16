function [ GTMAT, VNAME, VID ] = build_matrix( gt_dir, NNAME, VID )
% input
%   VID:
%
% output
%   VNAME:  will be sorted by VID if no input VID 
%   VID:    will be sorted by VID if no input VID


if exist('VID','var')
    use_ip_vid = true;
else
    use_ip_vid = false;
end

num_noun = numel(NNAME);

GTMAT = [];

for n = 1:num_noun
    nname    = NNAME{n};
    gt_file  = [gt_dir nname '_gtdata.mat'];
    gt_data  = load(gt_file);
    verb_syn = [gt_data.data.verb_syn];
    
    if use_ip_vid
        % align to input VID
        VID_sub = {verb_syn.id};
        ind_sub = zeros(numel(VID_sub),1);
        for i = 1:numel(VID_sub)
            ii = cell_find_string(VID,VID_sub{i});
            assert(numel(ii) == 1);
            ind_sub(i) = ii;
        end
        
        GTMAT_b = zeros(1,numel(VID));
        GTMAT_b(ind_sub) = [gt_data.data.label];
        GTMAT = [GTMAT; GTMAT_b]; %#ok
        VNAME = [];
        VID   = [];
    else
        % use VID from gt_data
        [vid,ii] = sort({verb_syn.id});  % sort the gt_data by verb wids
        vname    = {verb_syn.name};
        vname    = vname(ii);
        
        GTMAT = [GTMAT; gt_data.data(ii).label]; %#ok
        
        if n == 1;
            VNAME = vname;
            VID   = vid;
        else
            assert(strcmp(cell2mat(VNAME),cell2mat(vname)) == 1);
            assert(strcmp(cell2mat(VID),cell2mat(vid)) == 1);
        end
    end
end

end

