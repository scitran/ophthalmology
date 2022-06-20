%% Example of reading FreeHand roi from a Flywheel file
%
% This works for NIfTI but not for DICOM.  We don't know where they
% put the metadata (yet) for the DICOM files.
%
% MY/BW
%
% See also
%   scitran stuff
%

%%
st = scitran('stanfordlabs');
thisProject = st.lookup('scitran/VBR-CF');
sessions = thisProject.sessions();

for ii=1:numel(sessions)
    if sessions{ii}.subject.label == 'patient_02'
        thisSession = sessions{ii}; 
    end
end

acqs = thisSession.acquisitions();
thisAcq = stSelect(acqs,'label','OCT','nocell',true);
theFiles = thisAcq.files;
thisFile = theFiles{1};

%% Once you have the file, get the info

info = st.infoGet(theFiles{1});
thisSlice = info.ohifViewer.measurements.OpenFreehandRoi(1).sliceNumber;
h = info.ohifViewer.measurements.OpenFreehandRoi.handles;

% We don't know why we can't call
% p = info.ohifViewer.measurements.OpenFreehandRoi.handles.points;

p = h.points;

% Allocate space
x = zeros(numel(p),1);
y = size(x);
for ii=1:numel(p)
    x(ii) = p(ii).x; y(ii) = p(ii).y;
end

%% Plot the points, with (1,1) in the upper left hand corner.
nx = info.fslhd.nx;
ny = info.fslhd.ny;

mrvNewGraphWin; plot(x,y,'ro-');
set(gca,'ylim',[1 ny],'xlim',[1 nx]);
axis ij
grid on;
title(sprintf('Slice %d',thisSlice));

%% Edit the ROI
info.ohifViewer.measurements.OpenFreehandRoi(1).sliceNumber = 17;
st.infoSet(thisFile,info);
