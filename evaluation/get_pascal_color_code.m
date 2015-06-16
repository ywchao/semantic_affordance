function [ c ] = get_pascal_color_code(  )

% c  = distinguishable_colors(20);
c  = distinguishable_colors(21);
c([2 16],:) = c([16 2],:);
c(19,:) = [];

end

