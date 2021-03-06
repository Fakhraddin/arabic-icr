function waveletVector= CreateWaveletFromContour( WPTContour, ContourResampleSize , FeatureType)
%CREATEWAVELETFROMCONTOUR Summary of this function goes here
%   Detailed explanation goes here

C0 = 0;
tper = 0;
s = 0.5;      % Max nnz/numel in histogram (sparsity of histograms)

%TODO: Use normalization and simplification
ResampledContour = ResampleContour(WPTContour,ContourResampleSize);
WPFeatureVector = CreateFeatureVectorFromContour(ResampledContour,FeatureType);
WPTWaveletSparse = wemdn(WPFeatureVector', [false false], s, C0, tper,  'coef1');
waveletVector= full(WPTWaveletSparse(:,1));

end

