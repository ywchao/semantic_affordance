% visualize objects in the 2D affordance space

config;

% load mcoco_list
load(mcoco_file);

% set parameters
num_verb = 957;
N        = 30;  % number of significant verbs to visualize

% make directories
makedir(vis_base);

%% visualize the affordance space of 20 pascal object categories 
%  (figure 4 in the paper)
fprintf('visualizing 20 pascal object categories ... \n');
fprintf('  output to %s\n',vis_base);

% get ids & nnames
ID    = [mcoco_list.id]';
NNAME = {mcoco_list.name}';
NNAME = cellfun(@(x)strrep(x,' ','_'),NNAME,'UniformOutput',false);

% keep only the pascal objects
ID    = ID([mcoco_list.is_pascal] == 1);
NNAME = NNAME([mcoco_list.is_pascal] == 1);
num_noun = numel(NNAME);

% sort by nname
[NNAME,ii] = sort(NNAME);
ID = ID(ii);

% load scores
X = zeros(num_verb, num_noun);
for n = 1:num_noun
    nname = NNAME{n};
    data_file = fullfile(data_dir,sprintf('%02d_%s.mat',ID(n),NNAME{n}));
    load(data_file,'data');
    
    x = [data.score] - 3;
    X(:,n) = x';
end

% run pca
[signals,PC,V] = pca_shlens_1(X);

% visualize objects on 2D
pt_2d = signals(1:2,:);

figure(1); clf;
for n = 1:num_noun
    plot(pt_2d(1,n),pt_2d(2,n),'ro','MarkerFaceColor','r'); hold on
    text(pt_2d(1,n)+0.5,pt_2d(2,n)+0, ...
        strrep(NNAME{n},'_',' '), ...
        'FontSize',12);
end
grid on

fig_name = [vis_base,'pca_pascal.pdf']; 
if ~exist(fig_name,'file')
    print(gcf,'-dpdf',fig_name);
end
close;

% visualize responses of the significant verbs
p = max(abs([PC(:,1) PC(:,2)]),[],2);
[~,ii] = sort(abs(p),'descend');

ii_N = ii(1:N);
verb_syn = [data.verb_syn];
SIG_VERB = {verb_syn(ii_N).name}';
SIG_VERB = cellfun(@(x)strrep(x,'_',' '),SIG_VERB,'UniformOutput',false);

sv_dir = [vis_base sprintf('sig_verb_%03d_pascal',N) '/'];
makedir(sv_dir);
figure(1);
for n = 1:num_noun
    clf; 
    barh(X(ii_N,n)'+3);
    set(gca,'YDir','Reverse')
    axis([0 5 0.5 N+0.5]);
    set(gca,'YTick',1:1:N)
    set(gca,'XTick',0:1:5)
    set(gca,'YTickLabel',SIG_VERB);
    set(gca, 'Ticklength', [0 0])
    grid on;
    ht = title(sprintf('%s',strrep(NNAME{n},'_',' ')));
    
    set(gcf,'PaperPositionMode','manual');
    set(ht,'FontSize',20);
    set(gca,'FontSize',12);
    set(gcf,'PaperPosition',[0.25 0.25 3.1 6]);
    
    fig_name = [sv_dir,sprintf('%s.pdf',NNAME{n})];
    if ~exist(fig_name,'file')
        print(gcf,'-dpdf',fig_name);
    end
end
close;
fprintf('done.\n');

%% visualize the affordance space of 91 mscoco object categories
fprintf('visualizing 91 mscoco object categories ... \n');
fprintf('  output to %s\n',vis_base);

% get ids & nnames
ID    = [mcoco_list.id]';
NNAME = {mcoco_list.name}';
NNAME = cellfun(@(x)strrep(x,' ','_'),NNAME,'UniformOutput',false);
num_noun = numel(NNAME);

% sort by nname
[NNAME,ii] = sort(NNAME);
ID = ID(ii);

% load scores
X = zeros(num_verb, num_noun);
for n = 1:num_noun
    nname = NNAME{n};
    data_file = fullfile(data_dir,sprintf('%02d_%s.mat',ID(n),NNAME{n}));
    load(data_file,'data');
    
    x = [data.score] - 3;
    X(:,n) = x';
end

% run pca
[signals,PC,V] = pca_shlens_1(X);

% load mscoco cat info
[cat_name, cat_ind, cat_color] = get_mscoco_cat_info();
cat_ind = cat_ind(ii);

% visualize objects on 2D
pt_2d = signals(1:2,:);

figure(1); clf;
hp = zeros(num_noun,1);
for n = 1:num_noun
    hp(n) = plot( ...
        pt_2d(1,n),pt_2d(2,n),'o', ...
        'Color',cat_color(cat_ind(n),:), ...
        'MarkerSize',3, ...
        'MarkerFaceColor',cat_color(cat_ind(n),:) ...
        ); 
    hold on
    text(pt_2d(1,n)+0.5,pt_2d(2,n)+0, ...
        strrep(NNAME{n},'_',' '), ...
        'FontSize',4);
end
grid on
legend( ...
    hp([3 7 1 9 5 15 2 8 12 23 14]),cat_name, ...
    'Location','southeast' ...
    );

fig_name = [vis_base,'pca_mscoco.pdf']; 
if ~exist(fig_name,'file')
    print(gcf,'-dpdf',fig_name);
end
close;

% visualize responses of the significant verbs
p = max(abs([PC(:,1) PC(:,2)]),[],2);
[~,ii] = sort(abs(p),'descend');

ii_N = ii(1:N);
verb_syn = [data.verb_syn];
SIG_VERB = {verb_syn(ii_N).name}';
SIG_VERB = cellfun(@(x)strrep(x,'_',' '),SIG_VERB,'UniformOutput',false);

sv_dir = [vis_base sprintf('sig_verb_%03d_mscoco',N) '/'];
makedir(sv_dir);
figure(1);
for n = 1:num_noun
    clf; barh(X(ii_N,n)'+3);
    set(gca,'YDir','Reverse')
    axis([0 5 0.5 N+0.5]);
    set(gca,'YTick',1:1:N)
    set(gca,'XTick',0:1:5)
    set(gca,'YTickLabel',SIG_VERB);
    set(gca, 'Ticklength', [0 0])
    grid on;
    ht = title(sprintf('%s',strrep(NNAME{n},'_',' ')));
    
    set(gcf,'PaperPositionMode','manual');
    set(ht,'FontSize',20);
    set(gca,'FontSize',12);
    set(gcf,'PaperPosition',[0.25 0.25 3.1 6]);
    
    fig_name = [sv_dir,sprintf('%s.pdf',NNAME{n})];
    if ~exist(fig_name,'file')
        print(gcf,'-dpdf',fig_name);
    end
end
close;
fprintf('done.\n');

