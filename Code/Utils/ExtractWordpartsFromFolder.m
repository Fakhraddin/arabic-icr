function ExtractWordpartsFromFolder( setFolder, outputFolderPath )
%EXTRACTWORDPARTSFROMFOLDER Summary of this function goes here
%   ExtractWordpartsFromFolder( 'C:\Users\kour\OCRData Old\Archieve\adab_database_v1.0\Data\set_1' , 'C:\OCRData\WPs' )

inkmlFolder = [setFolder,'\inkml'];
inkmlFolderList = dir(inkmlFolder);
for i = 401:500 %length(inkmlFolderList)
    current_object = inkmlFolderList(i);
    IsFile=~[current_object.isdir];
    FileName = current_object.name(1:end-6);
    if (IsFile==1)
        ExtractWordPartsFromFile( setFolder, FileName, outputFolderPath)
    end 
end

