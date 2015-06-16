function [  ] = plot_one_pr( PREC, REC, AP, RAND, LEG, color )

[~,ii] = sort(AP,'descend');
LEG = LEG(ii);
for b = 1:numel(ii)
    plot(REC{ii(b)},PREC{ii(b)},'-','color',color(ii(b),:),'LineWidth',1.5); hold on;
end

grid on;
axis([0 1 0 1]);
[hleg,hlab] = legend(LEG,'Location','southeast');
xlab = xlabel('recall');
ylab = ylabel('precision');
% set(hleg,'FontSize',7);
set(hleg,'FontSize',10);
set(hlab,'linewidth',2);
set(xlab,'FontSize',14);
set(ylab,'FontSize',14);

for b = 1:numel(ii)
    plot([0 1],[RAND(ii(b)) RAND(ii(b))],'--','color',color(ii(b),:),'LineWidth',1)
end

end

