
config;

% load mcoco_list
load(mcoco_file);

% make directories
makedir(wnsim_base);

% get wordnet similarities for mscoco objects
fprintf('extracting wordnet similarities for mscoco objects ... \n');
fprintf('  wnsim_base: %s\n',wnsim_base);
if ~exist(n_sim_mat,'file')
    % get NNAME & NID
    NNAME = {mcoco_list.name}';
    NNAME = cellfun(@(x)strrep(x,' ','_'),NNAME,'UniformOutput',false);
    NID   = cell(numel(NNAME),1);
    for i = 1:numel(NNAME)
        if ~isempty(mcoco_list(i).wn_data)
            sense_id = mcoco_list(i).use_sense_id;
            NID{i}   = mcoco_list(i).wn_data(sense_id).wid;
        end
    end
    empty_ind = cellfun(@(x)isempty(x),NID);
    
    % generate input file to python
    NID_wn = NID(~empty_ind);
    if ~exist(n_list_file,'file')
        fid = fopen(n_list_file,'w');
        for j = 1:numel(NID_wn)
            fprintf(fid,'%s',NID_wn{j});
            if j ~= numel(NID_wn)
                fprintf(fid,'\n');
            end
        end
        fclose(fid);
    end
    
    % generate similarity file from python
    if ~exist(n_sim_file,'file')
        cmd = sprintf('python %s/wn_similarity/get_wn_sim.py %s %s %s %d', ...
            base_dir, ...
            base_dir, ...
            n_list_file, ...
            pos, ...
            is_sim_root);
        [status,cmdout] = system(cmd);
        if status ~= 0
          error('failed to extract similarities.\n');
        end
    end
    
    % read similarity file
    %   sim_path, sim_lch, sim_wup will have NaN if no matched synsets
    [sim_path_tmp,sim_lch_tmp,sim_wup_tmp] = scan_sim_file(n_sim_file,sum(empty_ind == 0));
    sim_path = NaN(size(NNAME,1),size(NNAME,1)); sim_path(~empty_ind,~empty_ind) = sim_path_tmp;
    sim_lch  = NaN(size(NNAME,1),size(NNAME,1)); sim_lch(~empty_ind,~empty_ind)  = sim_lch_tmp;
    sim_wup  = NaN(size(NNAME,1),size(NNAME,1)); sim_wup(~empty_ind,~empty_ind)  = sim_wup_tmp;
    
    save(n_sim_mat,'sim_path','sim_lch','sim_wup','NNAME','NID');
end
fprintf('done.\n');

% subplot(1,3,1); imagesc(sim_path);
% subplot(1,3,2); imagesc(sim_lch);
% subplot(1,3,3); imagesc(sim_wup);

