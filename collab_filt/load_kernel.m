function [ kernel ] = load_kernel( sim_file, ID, IDNAME, kernel_type, vis_base, n_set )

sim = load(sim_file);

ii = zeros(numel(ID),1);
for b = 1:numel(ID)
    eval(sprintf('ii(b) = cell_find_string(sim.%s,ID{b});',IDNAME));
end

path = sim.sim_path;  path = path(ii,ii);
lch  = sim.sim_lch;   lch  = lch(ii,ii);
wup  = sim.sim_wup;   wup  = wup(ii,ii);

switch kernel_type
    case 'path'
        kernel = path;
    case 'lch'
        kernel = lch;
    case 'wup'
        kernel = wup;
end


% visualize kernel
if exist('vis_base','var') ~= 0
    if ~exist(vis_base,'dir')
        mkdir(vis_base);
    end
    
    vis_file = [vis_base n_set '_' kernel_type '.pdf'];
    if exist(vis_file,'file') == 0
        figure(1); clf;
        imagesc(120-kernel*100, [0 120]); colormap('gray');
        
        switch n_set
            case 'pascal'
                font_size = 8;
            case 'mcoco'
                font_size = 2;
        end
        
        for i=1:size(kernel, 1)
            for j=1:size(kernel, 2)
                dispStr=num2str(kernel(i, j),'%.2f');
                text(j, i, dispStr, 'HorizontalAlignment','center','color','w', 'FontSize', font_size, 'FontWeight', 'bold')
            end
        end
        
        IDV = cellfun(@(x)strrep(x,'_',' '),ID,'UniformOutput',false);
        set(gca,'XTick',1:1:numel(ID));
        set(gca,'XTickLabel',IDV);
        rotateXLabels(gca(),45);
        set(gca,'YTick',1:1:numel(ID));
        set(gca,'YTickLabel',IDV);
        set(gca,'Ticklength', [0 0])
        
        if strcmp(n_set,'mcoco') == 1
            set(gca,'FontSize',3)
        end
        
        print(gcf,vis_file,'-dpdf');
        
        close;
    end
end

end

