%% FW OPHTHALMOLOGY

%% Get the project
st = scitran('stanfordlabs');
project = st.lookup('scitran/VBR-CF');

%% Find one of the acquisitions

subjects        = project.subjects();
thisSubject     = stSelect(subjects,'label','patient_02','nocell',true);
thisSession     = thisSubject.sessions.findFirst();
thisAcquisition = thisSession.acquisitions.findOne('label=OCT');

%%
basedir = fullfile(ophRootDir,'local','data');
basedir = '/Users/wandell/Documents/MATLAB/ophthalmology';
chdir(basedir);

load('OCT2','d5');
ni = niftiCreate;
ni.data = d5(:,:,(50:70));

ni.data = imageFlip(imageTranspose(ni.data),'upDown');

ni.ndim = 3;
ni.dim = size(ni.data);

ni.pixdim = [3.125 3.125 7];   % The data are not isovoxel.  We need the metadata.

ni.descrip = sprintf('OCT2-VBR.nii');
ni.xyz_units = 'um';
ni.time_units = '';
niftiWrite(ni,ni.descrip);

%{
niftiView(ni)
niftiView(ni,'slice',50);
%}

%%
thisAcquisition.uploadFile(ni.descrip);

%% 

img = imread('CF2.jpg');
ni = niftiCreate;
ni.data = img;
ni.ndim = 2;
ni.dim = [];

pdim = 7;
ni.pixdim = [3.125 3.125 7];   % The data are not isovoxel.  We need the metadata.

ni.descrip = sprintf('OCT2-%d-VBR',pdim);
ni.xyz_units = 'um';
ni.time_units = '';
fname = sprintf('OCT2-%d-test.nii',pdim);
niftiWrite(ni,fname);

thisAcquisition = thisSession.acquisitions.findOne('label=Fundus');

thisAcquisition.uploadFile(fname);
