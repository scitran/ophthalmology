%% Load up the segmented layers into mask
%
% I think that we processed some OCT data using OCTExplorer to produce
% these outputs.
%
% In this script we are creating a mesh to display one or two different
% layers.
%
% T/B
%
% See also
%

%% These files are already on the GA site
%
load('P73304206_Macular Cube 512x128_8-19-2020_13-28-54_OS_sn211046_cube_raw_Surfaces_Retina-JEI-Final','mask');
mask = double(mask);

% Sample it a little smaller in the big dimension
mask = mask(:,:,1:2:end);

% Make the XYZ values for the OCT cube
sz = size(mask);
[X,Y,Z] = meshgrid(1:sz(2),1:sz(1),1:sz(3));

%{
mrvNewGraphWin;
for ii=1:3:sz(2)
    imagesc(squeeze(mask(:,ii,:))); drawnow; pause(0.1);
end
%}

%% These are the 3D points in the layer. Trimesh version.

mrvNewGraphWin;
% The points in XYZ space
P = [X(:),Y(:),Z(:)];

% Find the XYZ values assigned to a layer
thisLayer = 1;
P = P(mask == thisLayer,:);

% Subsample
P = P(1:8:end,:);

% Make a mesh showing the XYZ values assigned to that layer
T = delaunay(P(:,1),P(:,2));
M = trimesh(T,P(:,1),P(:,2),P(:,3));
M.FaceColor = 'white'; M.EdgeColor = 'black';

%% Can we make an OBJ file from the P and T??
%
% Apparently yes.
% We can visualize the obj output file using MeshLab.
%
mn = mean(M.Vertices);
FV.vertices = M.Vertices - mn;
FV.faces    = M.Faces;
N = [];  % We don't know about the normals

OBJ = objFVN(FV,N);
fname = fullfile(vistaRootPath,'local',sprintf('OCT-%d.obj',thisLayer));
OBJ = rmfield(OBJ,'material');
objWrite(OBJ,fname);

%%

%% Suppose we compare to the 3rd layer?

thisLayer = 2;
Q = [X(:),Y(:),Z(:)];
Q = Q(mask == thisLayer,:);

% Subsample
Q = Q(1:8:end,:);

% Interpolate the Q values onto the X,Y grid for P
newQ = griddata(Q(:,1),Q(:,2),Q(:,3),P(:,1),P(:,2));
mrvNewGraphWin; plot3(P(:,1),P(:,2),newQ(:),'.');
hold on; plot3(P(:,1),P(:,2),P(:,3),'k.');

% Make a mesh showing the XYZ values assigned to that layer
T = delaunay(P(:,1),P(:,2));
M = trimesh(T,P(:,1),P(:,2),P(:,3));
M.FaceColor = 'white'; M.EdgeColor = 'black';
hold on;
M = trimesh(T,P(:,1),P(:,2),newQ(:));

%% Can we make an OBJ file from the P and T??
FV.vertices = M.Vertices;
FV.faces    = M.Faces;
N = [];
OBJ = objFVN(FV,N);

%% Thickness
mrvNewGraphWin;
thickness = P(:,3) - newQ(:);
MThick = trimesh(T,P(:,1),P(:,2),thickness);
title('Distance between layers')
%% Surf version.  Also looks good.
mrvNewGraphWin;

S = trisurf(T,P(:,1),P(:,2),P(:,3));

S.FaceColor = 'yellow'; S.EdgeColor = 'none';
view(3); % axis tight; % daspect([1 1 1]); 
camlight; lighting gouraud
title(sprintf('Layer %d',thisLayer));

%% Select out a layer
mrvNewGraphWin;
thisLayer = 1;
layerMask = zeros(size(mask));
layerMask(mask == thisLayer) = 1;
p = patch(isosurface(layerMask,0.999));
% N = isonormals(layerMask,p);

p.FaceColor = 'yellow'; p.EdgeColor = 'none';
view(3);  camlight; lighting gouraud
% axis tight;daspect([1 1 1]); 
title(sprintf('Layer %d',thisLayer));

%% Patch version
% {
mrvNewGraphWin;

% Sets the values equal to 5 as 1, others as 0.
thisLayer = 2;
ll = double((mask == thisLayer));

p = patch(isosurface(X,Y,Z,ll,0.98));
N = isonormals(X,Y,Z,ll,p);

p.FaceColor = 'yellow'; p.EdgeColor = 'none';
daspect([1 1 1]); view(3); axis tight; camlight; lighting gouraud
title(sprintf('Layer %d',thisLayer));
%}

%% Write out an OBJ file.
%  meshlab can read this file
%  We need to 'cull' to get rid of the double surface, though.
%  It never looks great

% {
FV.vertices = p.Vertices;
FV.faces    = p.Faces;
OBJ = objFVN(FV,N);
disp(FV)
disp(OBJ)
fname = fullfile(vistaRootPath,'local','OCT.obj');
objWrite(OBJ,fname);
%}
