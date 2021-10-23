
%% Make the figure
chdir(fullfile(ophRootPath,'local','bridge2ai'));

%%
load('slopes.mat','slopes');
figure
h = histogram(slopes);
h.FaceColor = [0.5 0.5 0.7]
grid on;
ylabel('Count'); xlabel('slope (dI/dy)')
h.BinLimits = [12 22];
xlabel('slope (\Delta I/row)'); ylabel('Count')

%%
figure
load('variance_extraretinal.mat','variance_extraretinal');
h = histogram(variance_extraretinal);
h.FaceColor = [0.7 0.5 0.5];
grid on;
xlabel('Variance'); ylabel('Count')

%%
figure
load('dynamicrange.mat','dynamicrange');
h = histogram(dynamicrange);
h.FaceColor = [0.5 0.7 0.5];
grid on;
xlabel('Dynamic range'); ylabel('Count')
%%