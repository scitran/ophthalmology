%% s_fwoLabels
%
% Works for the modern viewer.  Deleting previous code for legacy
% viewer.
%
% Write a json file to establish labels.
%
% Then upload the JSON file to the project.
%
% Thinking about uploading multiple types and then changing only the
% one used (ohif_config.json).
%
%

%{
% Open up the connection to the site
   st      = scitran('stanfordlabs');
   thisProject = st.lookup('adni/ADNI: T1');
   
%}
%{
thisProject = st.lookup('wandell/Ophthalmology dev');
%}
%{
thisProject = st.lookup('liaolab/OCT Segmentation ODD');
%}
%{
% The group is different here and on demo3.  It runs with
% flywheel/Ophthalmology. 
st = scitran('ga');
full = true;
thisProject = st.lookup('ophthalmology/Ophthalmology',full);
stPrint(thisProject.files,'name')
%}
%{
st = scitran('demo');
thisProject = st.lookup('flywheel/Ophthalmology');
%}
%{
st = scitran('ga');
full = true;
thisProject = st.lookup('ophthalmology/OCT Vendor Test Data',full);
stPrint(thisProject.files,'name')
%}
%% If a legacy viewer, we can read and display the current project labels

%{
pLabels = thisProject.info.labels;

for ii=1:numel(pLabels.commonLabels)
  disp(pLabels.commonLabels(ii).label)
  disp(pLabels.commonLabels(ii).value)
end
%}

%% Create the different labels
fname = ophCreateLabels('cortex');
thisProject.uploadFile(fname);
copyfile(fname,'ohif_config.json');
thisProject.uploadFile('ohif_config.json');


%% If a modern viewer, we should be able to download the ohif_config.json

destination = fullfile(ophRootPath,'local','ohif_config.json');
thisProject.downloadFile('ohif_config.json',destination)
edit(destination);

%% If a modern viewer, upload an attachment named ohif_config.json

% This is the fundus case
fname = ophCreateLabels('fundus');
thisProject.uploadFile(fname);

configFile = fullfile(ophRootPath,'local','ohif_config.json');
copyfile(fname,configFile);
thisProject.uploadFile(configFile);

%% Now switch over to the OCT
fname = ophCreateLabels('OCT');

configFile = fullfile(ophRootPath,'local','ohif_config.json');
thisProject.uploadFile(configFile);

copyfile(fname,configFile);
thisProject.uploadFile(configFile);

%% If a legacy viewer, update the info struct on the site
thisProject.update('info',info);
%% If a legacy viewer, update the info struct on the site
thisProject.update('info',info);
%%