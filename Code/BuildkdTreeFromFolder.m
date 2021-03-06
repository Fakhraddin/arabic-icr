function [KdTree,Size,WPmap] = BuildkdTreeFromFolder( WaveletFolder , TargetkdTreeFolder, FeatureType, ResampleSize)
%BUILDKDTREEFROMFOLDER Summary of this function goes here
%   Detailed explanation goes here
%   Feature types:
%   1 - Angular
%   2 - Shape COntext

if(~exist(TargetkdTreeFolder,'dir'))
    mkdir(TargetkdTreeFolder);
end

if (FeatureType==1)
    ActualWaveletFolder = [WaveletFolder,'\','Angular'];
    TargetkdTreeFilePath = [TargetkdTreeFolder,'\','Angular.mat'];
end
if (FeatureType==2)
    ActualWaveletFolder = [WaveletFolder,'\','ShapeContext'];
    TargetkdTreeFilePath = [TargetkdTreeFolder,'\','ShapeContext.mat'];
end

WaveletMatrix=[];
WPmap={};
sampledirlist = dir(ActualWaveletFolder);

for i = 3:length(sampledirlist)
    current_object = sampledirlist(i);
    FolderName = current_object.name;
    WaveletSampleFolder = [ActualWaveletFolder,'\',FolderName];
    %concatenate the matrices
    [tempWaveletMatrix,tempWPmap] = ReadWaveletsFromFolder(WaveletSampleFolder);
    WaveletMatrix = [WaveletMatrix;tempWaveletMatrix];
    WPmap = [WPmap;tempWPmap];
end

Labeling = CreateLabelingOfCellArray(WPmap);
[ProjectionWaveletMatrix, COEFF, NumOfPCs] = DimensionalityReduction(WaveletMatrix,Labeling);

%[ CentersMatrix , CentroidLabels ] = CalculateCentroid( ProjectionWaveletMatrix , WPmap );
[ CentersMatrix , CentroidLabels ] = CalculateMostCentrallyObject( ProjectionWaveletMatrix , WPmap );
Size = size(WaveletMatrix,2);
%KdTree = kd_buildtree(ProjectionWaveletMatrix,0);
%save(TargetkdTreeFilePath, 'KdTree','Size','WPmap', 'ResampleSize','ProjectionWaveletMatrix', 'COEFF', 'NumOfPCs');
KdTree = kd_buildtree(CentersMatrix,0);
save(TargetkdTreeFilePath, 'KdTree','Size','WPmap', 'ResampleSize','ProjectionWaveletMatrix', 'COEFF', 'NumOfPCs','CentroidLabels','CentersMatrix');
end
