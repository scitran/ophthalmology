%% s_fwoROI
%
% Read the ROIs from a labeled file
%
% 

%% Open up the connection to the site
st      = scitran('stanfordlabs');

% Lookup the project
project = st.lookup('scitran/VBR-CF');

%% Find one of the acquisitions and a file with an ROI for a subject
%
% The ROI was drawn in the viewer on the site.
%

subjects        = project.subjects();
thisSubject     = stSelect(subjects,'label','patient_02','nocell',true);
thisSession     = thisSubject.sessions.findFirst();
thisAcquisition = thisSession.acquisitions.findOne('label=OCT');

fname = 'OCT2-VBR.nii';
thisFile = stSelect(thisAcquisition.files, ...
    'name',fname, ...
    'nocell',true);
info = st.infoGet(thisFile);

fprintf('We found %d ROIs for this file.\n',numel(info.roi));

info.roi

%% END
