function rootPath=ophRootPath()
%
%        rootPath = ophRootPath;
%
% Determine path to root of the ophthalmology directory
%
% This function MUST reside in the directory at the base of the
% ophthalmology directory structure 
%
% Wandell

rootPath=which('ophRootPath');

rootPath=fileparts(rootPath);

end