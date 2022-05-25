%% Caserel
% Test of caserel code
%

%% Load the data and create a NIFTI file

load('OCT2','d5');

img = d5(:,:,65);
mrvNewGraphWin;
imagesc(img); colormap(gray);
axis image;

%%
% ni = niftiCreate;

lst = [ 20 50 65 85];
mrvNewGraphWin;
jj = 1;
for ii = lst
    subplot(1,numel(lst),jj)
    [retinalLayers, params] = getRetinalLayers(d5(:,:,ii));
    jj = jj + 1;
end

%%
mrvNewGraphWin;

for ii = 1:size(d5,3)
    [retinalLayers, params] = getRetinalLayers(d5(:,:,ii));
    pause(0.1);
end
