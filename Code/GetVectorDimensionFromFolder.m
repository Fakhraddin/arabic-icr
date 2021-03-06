function [M,N] = GetVectorDimensionFromFolder( FolderPath )
%GETVECTORDIMENSIONFROMFOLDER returns the diminsions of the some
%representative vector from the given directory.
%   Detailed explanation goes here

dirlist = dir(FolderPath);

DirListLength = length(dirlist);

for i = 1:DirListLength
    current_object = dirlist(i);
    IsFile=~[current_object.isdir];
    FileName = current_object.name;
    FileNameSize = size(FileName);
    LastCharacter = FileNameSize(2);
    if (IsFile==1 & FileName(LastCharacter)=='m')
        Vector = dlmread([FolderPath,'\',FileName]);
        [M,N]=size(Vector);
        return;
    end
    
end

