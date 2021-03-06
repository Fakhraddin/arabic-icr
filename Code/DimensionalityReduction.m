function [ReducedFeaturesMatrix, COEFF, NumOfPCs] = DimensionalityReduction( FeaturesMatrix, Labeling, varargin)
%DIMENSIONALITYREDUCTION Reduces the dimensionality of N-by-P FeaturesMatrix matrix dimensionality.
%   Rows of FeaturesMatrix correspond to observations, columns to variables.
%   varargin{1} is the PCADataPreservingRate, the default is 0.98.
%   varargin{2} is the target number of dimentions, the default is the
%   output dimentsions of the oca given the PCADataPreservingRate minus 1.

PCADataPreservingRate = 0;
NumOfPCs = 0;

switch size(varargin,2)
    case 1
        PCADataPreservingRate=varargin{1};
    case 2
        PCADataPreservingRate=varargin{1};
        NumOfPCs = varargin{2};
end

% DimensionalityReduction Using PCA
[PCACOEFF,SCORE,LATENT] = princomp(FeaturesMatrix);

% build a vector with the data preservation rate.
data_preserving_vector = cumsum(LATENT)./sum(LATENT);

% determine PCADataPreservingRate 
%-------------------
if PCADataPreservingRate==0
    PCADataPreservingRate=0.95; % The default 
end


%find the first element that it's value > DataPreservingRate
PCA_NumOfPCs = find(data_preserving_vector>PCADataPreservingRate,1);

PCACOEFF = PCACOEFF(:,1:PCA_NumOfPCs);
tempReducedFeaturesMatrix = (PCACOEFF' * FeaturesMatrix')';


% determine NumOfPCs 
%-------------------

if NumOfPCs==0 || NumOfPCs>=PCA_NumOfPCs  %if the user did not specify target number of dimension or he has specified #dimensions>=#PCA_output_dimensions 
    NumOfPCs = PCA_NumOfPCs; 
end

%LDA Phase
%----------
[ReducedFeaturesMatrix,mapping] = LDA(tempReducedFeaturesMatrix,Labeling,NumOfPCs - 1);
NumOfPCs = size (ReducedFeaturesMatrix,2);

% build the COEFF matrix (M)
M = mapping.M;
COEFF = M'*PCACOEFF';
ReducedFeaturesMatrix = (M' * tempReducedFeaturesMatrix')';


end

