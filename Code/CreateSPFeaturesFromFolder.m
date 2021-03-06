function [ FeaturesMatrix,Grouping ] = CreateSPFeaturesFromFolder( FolderPath )
%CREATESEGMENTATIONPOINTSFEATURES Summary of this function goes here
%   [ FeaturesMatrix,Grouping ] = CreateSPFeaturesFromFolder( 'C:\OCRData\GeneratedWordsMed\sample2' )

dirlist = dir(FolderPath);
DirListLength = length(dirlist);
FeaturesMatrix = [];
Grouping = [];
for i = 1:DirListLength
    current_object = dirlist(i);
    IsFile=~[current_object.isdir];
    FileName = current_object.name;
    FileNameSize = size(FileName);
    LastCharacter = FileNameSize(2);
    if (IsFile==0 &&  ~strcmp(FileName,'.') && ~strcmp(FileName,'..'))
        [ tempFeaturesMatrix,tempGrouping ] = CreateSPFeaturesFromFolder([FolderPath,'\',FileName]);
        FeaturesMatrix = [FeaturesMatrix;tempFeaturesMatrix];
        Grouping = [Grouping;tempGrouping];
    end
    if (IsFile==1 && FileName(LastCharacter)=='m' && ~strcmp(FileName,'_.m'))
        CharacterSequence = dlmread([FolderPath,'\',FileName]);
        [ CharacterFeatures , CharacterGrouping ] = CreateSPFeaturesFromCharacter(CharacterSequence, 3,10);
        FeaturesMatrix = [FeaturesMatrix;CharacterFeatures];
        Grouping = [Grouping;CharacterGrouping];
    end
end
end

