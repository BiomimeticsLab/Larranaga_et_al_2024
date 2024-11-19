%% 
%.xls import: 
% cells area: Column vectors named area_1
% cells positions: Numeric Matrix named xy0
area=area(~isnan(area));
x=xy0(:,1); x = x(~isnan(x)); 
y=xy0(:,2); y = y(~isnan(y));

%%
t1=0:2:566.43; t2=0:2:353.48; % Grid Size (image um size)
[XI,YI]=meshgrid(t1,t2);
Zd = griddata (x,y,area,XI,YI,'linear'); %linear interpolation

%% Just in case of area analysis
ncols = size(Zd,1);
nrows = size(Zd,2);

minThreshold = 31.2793;
maxThreshold = 2078.50;

for i=1:ncols
for j=1:nrows
if Zd(i,j) < minThreshold
Zd(i,j) = minThreshold;
elseif Zd(i,j) > maxThreshold
Zd(i,j) = maxThreshold;
else
Zd(i,j) = Zd(i,j);
end
end
end

%% Just in case of area analysis
Zd_log=log(Zd);

figure; 
[~,h]=contourf(XI,-YI,-Zd_log); 
set(h,'LineColor','none'); %contourf with no isolines

c = colorbar;
c.Direction='reverse';
c.Location='southoutside';

c.Ticks=[-7.5, - 6.9078, -4.6052];
%c.Ticks.Labels= {'100' '1000', '2000'};

c.Label.String= 'Log(Area) (\mum^{2})';

set(gca,'XTick',[], 'YTick', [])


%%
proliferative = imread('C1-349_263.tif');
proliferative = proliferative/255;

non_proliferative = imread('C1-349_263_inverted.tif');
non_proliferative = non_proliferative/255;

%%
proliferative = double(proliferative);
proliferative_areas = proliferative .* Zd;
non_proliferative = double(non_proliferative);
non_proliferative_areas = non_proliferative .* Zd;

%%
proliferative_areas(proliferative_areas==0) = NaN;
proliferative_areas = proliferative_areas(~isnan(proliferative_areas));
media_proliferative=mean(proliferative_areas); desv_proliferative=std(proliferative_areas);
h_proliferative = chi2gof(proliferative_areas);

non_proliferative_areas(non_proliferative_areas==0) = NaN;
non_proliferative_areas = non_proliferative_areas(~isnan(non_proliferative_areas));
media_non_proliferative=mean(non_proliferative_areas); desv_non_proliferative=std(non_proliferative_areas);
h_non_proliferative = chi2gof(non_proliferative_areas);

[h,p,ci,stats] = ttest2(proliferative_areas,non_proliferative_areas);

%%
binranges=0:200:2000;
figure
nelements = hist(proliferative_areas,binranges);
bar(binranges,nelements/(length(proliferative_areas)),'BarWidth', 1, 'FaceColor','c');
%xlabel('Nearest Neighbor (\mum)'); ylabel('Frequency'); %axis([0 30 0 1]);

hold on
nelements = hist(non_proliferative_areas,binranges);
s=bar(binranges,nelements/(length(non_proliferative_areas)),'BarWidth', 1,'FaceColor', 'm');
hold off
alpha(s,.5)
xlabel('Area (\mum^2)'); ylabel('Relative Frequency'); 
axis([0 2200 0 1]);
