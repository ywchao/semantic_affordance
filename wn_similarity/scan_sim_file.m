function [ sim_path, sim_lch, sim_wup ] = scan_sim_file( sim_file, num_word )

fid = fopen(sim_file,'r');
C = textscan(fid,'%s',-1,'delimiter',{'\n',' '});
C = C{1};
fclose(fid);

assert(mod(numel(C),3) == 0);
C = C(4:end);  % get rid of the first line
C = reshape(C,[3,numel(C)/3])';
C = cellfun(@(x)str2double(x), C);

sim_path = reshape(C(:,1),[num_word,num_word]);
sim_lch  = reshape(C(:,2),[num_word,num_word]);
sim_wup  = reshape(C(:,3),[num_word,num_word]);


end

