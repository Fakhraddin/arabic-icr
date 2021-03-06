function [ CentersMatrix , CentroidLabels ] = CalculateCentroid( FeaturesMatrix , Labeling )
%CALCULATRCENTROID Computes the Centroid of each Class.
%   Detailed explanation goes here

uniqueLabels = unique (Labeling);
numOfClasses = size(uniqueLabels,1)
CentersMatrix = zeros(numOfClasses, size(FeaturesMatrix,2));
for i=1:numOfClasses
    %class = find(Labeling==uniqueLabels(i));
    class = find(ismember(Labeling, uniqueLabels(i))==1);
    numOfElementsInClass = size(class,1);
    med = zeros(1, size(FeaturesMatrix,2));
    for j=1:numOfElementsInClass
        med = med + FeaturesMatrix(class(j),:);        
    end
    CentersMatrix(i,:) = med/numOfElementsInClass;
end

CentroidLabels = uniqueLabels;