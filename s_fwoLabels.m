%% s_fwoLabels
%
% Next:  Move the labels to a json file
% Write code to read the json file and set the labels on the FW site
%
% Brian

%{
%% FW OPHTHALMOLOGY
% Have not yet tested on stanfordlabs

% Open up the connection to the site
st      = scitran('stanfordlabs');

% Lookup the project
thisProject = st.lookup('scitran/VBR-CF');
%}

%{

% This code does not run on ga, only on demo, sigh.
fwga = scitran('ga');

thisProject = fwga.lookup('flywheel/Ophthalmology');
sessions = thisProject.sessions();
stPrint(s,'subject','label');

%}
fwdemo = scitran('demo');

thisProject = fwdemo.lookup('flywheel/Ophthalmology');
sessions = thisProject.sessions();
stPrint(s,'subject','label');

%% Read and display the current project labels

pLabels = thisProject.info.labels;

for ii=1:numel(pLabels.commonLabels)
  disp(pLabels.commonLabels(ii).label)
  disp(pLabels.commonLabels(ii).value)
end

%%  Create or update the labels

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

% Check that I didn't screw up
assert(numel(allValues) == numel(allLabels))

% Select a subset of the labels to be the common labels
lst = [1, 4, 5, 6, 7, 8, 9 10, 11, 12, 15, 19];
commonLabels = cell(numel(lst),1);
commonValues = cell(numel(lst),1);
for ii=1:numel(lst)
    commonLabels{ii} = allLabels{lst(ii)};
    commonValues{ii} = allValues{lst(ii)};
end

%% Create the info struct for the project
for ii=1:numel(commonLabels)
    info.labels.commonLabels(ii).label = commonLabels{ii};
    info.labels.commonLabels(ii).value = commonValues{ii};
end

for ii=1:numel(allLabels)
    info.labels.labels(ii).label = allLabels{ii};
    info.labels.labels(ii).value = allValues{ii};
end

%% Update the info struct on the site
project.update('info',info);

%%