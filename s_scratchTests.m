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
basedir = fullfile(ophRootPath,'local','data');
chdir(basedir);

load('OCT2','d5');
ni = niftiCreate;
ni.data = d5(:,:,(45:75));

ni.data = imageTranspose(ni.data);

ni.ndim = 3;
ni.dim = size(ni.data);

% The data are not isovoxel.  These are the dimensions in microns.
ni.pixdim = [3.125 3.125 7];   

%%
ni.descrip = sprintf('OCT2 data');
ni.xyz_units = 'um';
ni.time_units = '';
fname = 'OCT2-VBR.nii';
niftiWrite(ni,fname);

%%
thisAcquisition.uploadFile(ni.descrip);

%%