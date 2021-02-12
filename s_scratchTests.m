%% FW OPHTHALMOLOGY

st = scitran('stanfordlabs');

project = st.lookup('scitran/VBR-CF');


%% Read the project labels
pLabels = project.info.labels;
for ii=1:numel(pLabels.commonLabels)
  disp(pLabels.commonLabels(ii).label)
  disp(pLabels.commonLabels(ii).value)
end

%%  Set the labels

allLabels = {'Internal LM', ...   % 1
    'Posterior vitreous' ...
    'Preretinal space',...        % 3
    'Nerve fiber layer',...       % 4
    'Ganglion cell layer', ...
    'Inner plexiform layer', ...  % 6
    'Inner nuclear layer', ...
    'Outer plexiform layer', ...
    'Henle fiber layer',...       % 9
    'Outer nuclear layer', ...
    'Outer segments', ...
    'External LM', ...            % 12
    'Myoid zone', ...
    'Ellipsoid Zone', ...
    'RPE', ...                    % 15
    'Choriocapillaris', ...
    'Choroid sclera junction', ...
    'Intergitation zone',...
    'Fovea'};                     % 19

allValues = {'ILM', ...
    'PCV' ...
    'PRS',...
    'NFL',...
    'GCL', ...
    'IPL', ...
    'INL', ...
    'OPL', ...
    'HFL',...
    'ONL', ...
    'OS', ...
    'ELM', ...
    'MZ', ...
    'EZ', ...
    'RPE', ...
    'CC', ...
    'CSH', ...
    'IZ', ...
    'FOV'};

assert(numel(allValues) == numel(allLabels))

lst = [1, 4, 5, 6, 7, 8, 9 10, 11, 12, 15, 19];
commonLabels = cell(numel(lst),1);
commonValues = cell(numel(lst),1);

for ii=1:numel(lst)
    commonLabels{ii} = allLabels{lst(ii)};
    commonValues{ii} = allValues{lst(ii)};
end

project.info
for ii=1:numel(commonLabels)
    info.labels.commonLabels(ii).label = commonLabels{ii};
    info.labels.commonLabels(ii).value = commonValues{ii};
end

for ii=1:numel(allLabels)
    info.labels.labels(ii).label = allLabels{ii};
    info.labels.labels(ii).value = allValues{ii};
end

% Push the change to the site
project.update('info',info);

%%
subjects = project.subjects();
tmp = stSelect(subjects,'label','patient_02');
thisSubject = tmp{1};

thisSession     = thisSubject.sessions.findFirst();
thisAcquisition = thisSession.acquisitions.findOne('label=OCT');

%%
basedir = '/Users/wandell/Documents/MATLAB/fwophthalmology';
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
