%% s_ophNIFTI
%
% Illustrates pulling down a MAT file, converting it to NIfTI, and
% uploading it back to the acquisition.
%
% VISTA-TEACH, ophthalmology
%
% Wandell, 2021

%% Get the project information

st      = scitran('stanfordlabs');
project = st.lookup('scitran/VBR-CF');

%% Find one of the acquisitions for a subject

subjects        = project.subjects();
thisSubject     = stSelect(subjects,'label','patient_02','nocell',true);
thisSession     = thisSubject.sessions.findFirst();
thisAcquisition = thisSession.acquisitions.findOne('label=OCT');

thisAcquisition.label

%%  Download the data from Flywheel

basedir = fullfile(ophRootPath,'local','data');
chdir(basedir);

thisFile = stSelect(thisAcquisition.files,'name','OCT2.mat','nocell',true);
thisFile.download('OCT2.mat');

%% Load the data and create a NIFTI file

load('OCT2','d5');
ni = niftiCreate;

% A subset of the data for speed
ni.data = d5(:,:,(45:75));
ni.ndim = ndims(ni.data);
ni.dim  = size(ni.data);

% These are the dimensions in microns.
ni.pixdim = [3.125 3.125 7];   

% Write the file
ni.descrip = sprintf('OCT2 data');
ni.xyz_units = 'um';
ni.time_units = '';

fname = 'OCT2-VBR.nii';
niftiWrite(ni,fname);

%% Upload the NIfTI to the acquisition

thisAcquisition.uploadFile(fname);

%% END
