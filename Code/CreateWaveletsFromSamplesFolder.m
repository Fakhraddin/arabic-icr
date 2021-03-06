function Num = CreateWaveletsFromSamplesFolder(SamplesFolder, WaveletTargetFolder, ContourResampleSize, FeatureType)
%CREATEWAVELETSFROMSAMPLESFOLDER Summary of this function goes here
%   Detailed explanation goes here

%Make sure the target folders exist or create them
res = exist(WaveletTargetFolder,'dir');
if (res==0)
    mkdir(WaveletTargetFolder);
end

if (FeatureType==1)
    TargetFolder=[WaveletTargetFolder,'\','Angular'];
end

if (FeatureType==2)
    TargetFolder=[WaveletTargetFolder,'\','ShapeContext'];
end

res = exist(TargetFolder,'dir');
if (res==0)
    mkdir(TargetFolder);
end

Num=0;
dirlist = dir(SamplesFolder);
DirListLength = length(dirlist);
for i = 1:DirListLength
    current_object = dirlist(i);
    Name = current_object.name;
    if (current_object.isdir && ~strcmp(Name,'.')  &&  ~strcmp(Name,'..'))
        temp = CreateWaveletFromFolder([SamplesFolder,'\',Name], [TargetFolder,'\',Name], ContourResampleSize, FeatureType);
        Num = Num + temp;
    end
end

