function [ NNAME ] = load_nname( n_set )
% input
%   n_set: 'mscoco' or 'pascal'

config;

load(mcoco_file);

NNAME = {mcoco_list.name}';
NNAME = cellfun(@(x)strrep(x,' ','_'),NNAME,'UniformOutput',false);

switch n_set
    case 'mscoco'
        % do nothing
    case 'pascal'
        NNAME = NNAME([mcoco_list.is_pascal] == 1);
end

end

