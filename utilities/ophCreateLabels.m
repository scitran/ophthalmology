function fname = ophCreateLabels(dtype,varargin)
% Create a JSON file of labels
%
% Synopsis
%    fname = ophCreateLabels(dtype,varargin)
%
% Input
%   dtype - Which ophthalmology data type ('OCT','Fundus')
%
% Optional key/val parameters
%   N/A
%
% Output
%   fname - output JSON file.  Stored by default in the local directory.
%
% Description
%   For now, the labels are stored in the top part of this function.  At
%   some point in time we will put the labels elsewhere.
%
%   This function writes out the labels into ohif_config_XXX.json files.
%   We will upload them, with the proper name, to the ga.ce project.
%
% See also
%   s_fwoLabels
%

% Examples:
%{
  fname = ophCreateLabels('OCT','viewer','modern');
%}
%{
  fname = ophCreateLabels('OCT','viewer','legacy');
%}

%% Parse
varargin = ieParamFormat(varargin);

p = inputParser;
p.addRequired('dtype',@ischar);
p.addParameter('viewer','modern',@(x)(ismember(x,{'legacy','modern'})));
p.parse(dtype,varargin{:});

viewer = p.Results.viewer;

%% OCT Labels
octLabels = {'Internal LM', ...   % 1
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
    'Interdigitation zone',...
    'Fovea'};                     % 19

octValues = {'ILM', ...
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

commonOCT = [ 1 4 6 12 15 19];

assert(numel(octValues) == numel(octLabels))

%% Fundus labels

fundusLabels = {'Fundus1', ...   
    'Fundus2' ...
    'Fundus3',...          
    'Optic Nerve',...       
    'Fovea'};               

fundusValues = {'FU1', ...
    'FU2' ...
    'FU3',...
    'ON',...
    'FOV'}; 

commonFundus = [1 4 5];

assert(numel(fundusValues) == numel(fundusLabels))

%% Set up the parameters

switch ieParamFormat(dtype)
    case 'oct'
        fname = 'ohif_config_oct.json';      
        allLabels = octLabels;
        allValues = octValues;
        lst = commonOCT;
    case 'fundus'
        fname = 'ohif_config_fundus.json';
        allLabels = fundusLabels;
        allValues = fundusValues;
        lst = commonFundus;
    otherwise
        error('Unknown data type %s\n',dtype);
end


%% Build the struct

% Select a subset of common labels.  Based on the common* variable.

switch viewer
    case 'legacy'
        fname = ['legacy_',fname];
        
        % Build the common labels
        commonLabels = cell(numel(lst),1);
        commonValues = cell(numel(lst),1);
        for ii=1:numel(lst)
            commonLabels{ii} = allLabels{lst(ii)};
            commonValues{ii} = allValues{lst(ii)};
        end
        
        % Create the info struct for the project
        %   info.labels.commonLabels. ...
        %   info.labels.labels. ...
        
        % This is uploaded as an info field to the project
        for ii=1:numel(commonLabels)
            info.labels.commonLabels(ii).label = commonLabels{ii};
            info.labels.commonLabels(ii).value = commonValues{ii};
        end
        
        for ii=1:numel(allLabels)
            info.labels.labels(ii).label = allLabels{ii};
            info.labels.labels(ii).value = allValues{ii};
        end
        
        fname = fullfile(ophRootPath,'local',fname);
        jsonwrite(fname,info);
    case 'modern'
        % labels.label
        % labels.value
        for ii=1:numel(allLabels)
            info.labels(ii).label = allLabels{ii};
            info.labels(ii).value = allValues{ii};
        end
        
        % Write
        fname = fullfile(ophRootPath,'local',fname);
        jsonwrite(fname,info);
        
    otherwise
        error('Unknown viewer type %s\',viewer);
end


end

