%% Stanford example:
%
% Load the segmented layers from Teresa's gear.
%
% Data and script in opthalmology/stanford
%
% BW

%% Load in the lines output by the segmentation gear.

% What are these values?  They are a matrix defining the 97 lines
% (there are 97 slices).
% My guess is nslices and x-axis.  Seems to work out below.
load('rlayer_segments_ilm_layers.mat','ilm_layers');
load('rlayer_segments_rpe_layers.mat','rpe_layers');

%%  Read the edge data in the aligned numpy file

% Open python within Matlab
pyenv;

% Load the aligned data
oct = py.numpy.load('ODD-246 OD_aligned.npy');
octData = double(oct);

%%  Plot them in an overlay
nSlices = size(ilm_layers,1);
mrvNewGraphWin;
for ii=1:nSlices
    imagesc(squeeze(octData(ii,:,:))); title(sprintf('%d',ii));
    gray(256);
    hold on;
    plot(1:nCols,ilm_layers(ii,:),'r.');
    plot(1:nCols,rpe_layers(ii,:),'g.');
    pause(0.2);
    hold off;
end

% Conclusion: The edges are not good enough.

%% Make a cube for the retinal volume.
%
%  The size of the cube will be (nSlices, nRows, nCols)
%
%  This way, the surface we visualize has an X,Y dimension of which
%  slice and which row, and a height that will be which column.
%

% The ilm_layers seems to have the dimension of nSlices x nCols
[nSlices,nCols] = size(ilm_layers);

% The values in ilm_layers seems to be which row.  So we take a number
% a little bigger than the largest entry.
nRows = round(max(ilm_layers(:))) + 20;

% Now we make the volume
mask = zeros(nSlices, nRows, nCols);

% This is what the slices in ilm_layers look like

 mrvNewGraphWin;
 hold on;
for ii=1:nSlices
   plot3(ii*ones(size(1:nCols)),1:nCols,ilm_layers(ii,:),'.');
end
grid on;



%% Here we check the 


max(ilm_layers,1)
sz = size(mask);
[X,Y,Z] = meshgrid(1:sz(2),1:sz(1),1:sz(3));
