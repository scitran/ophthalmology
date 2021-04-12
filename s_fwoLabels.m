%% s_fwoLabels
%
% Write a json file to set the labels
% Then upload the JSON file (if a modern OHIF) or set the Custom Information (if
% the legacy).
%

%{
% Have not yet tested on stanfordlabs
% Open up the connection to the site
st      = scitran('stanfordlabs');
thisProject = st.lookup('scitran/VBR-CF');
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

%% If a legacy viewer, we can read and display the current project labels

pLabels = thisProject.info.labels;

for ii=1:numel(pLabels.commonLabels)
  disp(pLabels.commonLabels(ii).label)
  disp(pLabels.commonLabels(ii).value)
end

%% If a modern viewer, we should be able to download the ohif_config.json

destination = fullfile(ophRootPath,'local','ohif_config.json');
thisProject.downloadFile('ohif_config.json',destination)
edit(destination);

%% If a modern viewer, upload an attachment named ohif_config.json
fname = ophCreateLabels('fundus');
configFile = fullfile(ophRootPath,'local','ohif_config.json');
copyfile(fname,configFile);
thisProject.uploadFile(configFile);

%% Now switch over to the OCT
fname = ophCreateLabels('OCT');
configFile = fullfile(ophRootPath,'local','ohif_config.json');
copyfile(fname,configFile);
thisProject.uploadFile(configFile);

%% If a legacy viewer, update the info struct on the site
thisProject.update('info',info);
%% If a legacy viewer, update the info struct on the site
thisProject.update('info',info);
%%