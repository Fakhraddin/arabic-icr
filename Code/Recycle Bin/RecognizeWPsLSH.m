function ClosestWPsCellArray = RecognizeWPsLSH( WPTContours, LSHFilePath, FeatureType, closest )
%RECOGNIZEWPSLSH Summary of this function goes here
%   Detailed explanation goes here


S = load(LSHFilePath);
LSHstruct = S.LSHstruct;
WPmap = S.WPmap;
Size= S.Size;
ResampleSize = S.ResampleSize;
WaveletMatrix = S.ProjectionWaveletMatrix;
COEFF=S.COEFF;
NumOfPCs = S.NumOfPCs;

WaveletMatrix = WaveletMatrix';

for j=1:length(WPTContours)
    WPTContour =  WPTContours{j};
    
    WPWavelet = CreateWaveletFromContour( WPTContour, ResampleSize , FeatureType);

    WPWavelet_Projection = COEFF * WPWavelet;
    
    [iNN,cand] = lshlookup(WPWavelet_Projection,WaveletMatrix,LSHstruct,'k',closest);
    
    ClosestWPs= [];
    for i=1:size(iNN,2)
        ClosestWPs = [ClosestWPs ; WPmap(iNN(i))];
    end
    
    ClosestWPsCellArray(j) = {ClosestWPs};
    
end
end

