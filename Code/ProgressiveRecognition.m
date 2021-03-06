function [Stat,LastIndexes,Candidates] = ProgressiveRecognition( Alg, Stat, S, LastIndexes,Candidates ,RParams , IsMouseUp )
%PROGRESSIVERECOGNITION given the current state, the sequence, till now and
%an array of the LastIndexes indexes in each phase. In the first phase we
%will not create a tree, however we will ty to recognize each letter
%saperately.
%   Detailed explanation goes here

[len,m]=size(S);
if (IsMouseUp==false)    
    if (Stat == 1)
        sub_S = S;
        [C,SumDist,C_Dist]=Calculate_Closest_letters (sub_S,Alg,'Ini');
    else %State>1
        StartIndex = LastIndexes(Stat-1);
        EndIndex = len;
        sub_S = S(StartIndex:EndIndex,:);
        [C,SumDist,C_Dist]=Calculate_Closest_letters (sub_S,Alg,'MedFin');
    end
    C_Dist
    thetasumdist = RParams.theta*SumDist
    if (C_Dist<(RParams.theta*SumDist))    %Move to the next
        Candidates{Stat}=C;
        LastIndexes(Stat)=len;
        Stat=Stat+1;
    end
% Handle the LastIndexes Stat. There are 2 options:
% 1. is that transition to the LastIndexes Stat was exactly at the LastIndexes point in the stroke,
% 2. There is a remainder, meaning that the LastIndexes points in the dtroke do not form a            new Stat (Letter)
% need to decide wether the remainder is a separate leter or a tail of the previous letter.
% There is an hazard of combining to letters!
else
    if (Stat>1) % validate that there are prevoius states.    
        sub_S = S(LastIndexes(Stat-1):len,:);
        simplified = dpsimplify(sub_S,RParams.ST);
        if (length(simplified)>2)%(S is a separate Stat%)
            %New state
            sub_S = S(LastIndexes(Stat-1):len,:);
            [C,SumDist,C_Dist]=Calculate_Closest_letters (sub_S,Alg,'MedFin');
            Candidates{Stat}=C;
            LastIndexes(Stat)=len;
            Stat=Stat+1;
        else
            %Refine the last state
            if (Stat < 3 )
                sub_S = S;
                [C,SumDist,C_Dist]=Calculate_Closest_letters (sub_S,Alg,'Ini');
            else
                sub_S = S(LastIndexes(Stat-2):len,:);
                [C,SumDist,C_Dist]=Calculate_Closest_letters (sub_S,Alg,'MedFin');
            end
            
            Candidates{Stat-1}=C;
            LastIndexes(Stat-1)=len;
            % Stat=Stat;
        end
    else
        [C,SumDist,C_Dist]=Calculate_Closest_letters (S,Alg,'Ini');
        Candidates{Stat}=C;
        LastIndexes(Stat)=len;
        Stat=Stat+1;
    end
    
end
end


function [C,SumDist,C_Dist]=Calculate_Closest_letters (S,Alg,Letters)
FeatureType = 0;
if (strcmp(Alg(1),'EMD'))
    %EMD
else
    %DTW
end

if (strcmp(Alg(2),'MSC'))
    FeatureType = 1;
    FeatureName = 'Angular';
else
    FeatureType = 2;
    FeatureName = 'ShapeContext';
end
if (strcmp(Alg(3),'kdTree'))
    kdTreeFilePath = ['C:\OCRData\kdTree',Letters,'\',FeatureName];
    SumDist=CalculateSumDistanceFromCenters_kdTree( S, kdTreeFilePath, FeatureType );
    C = RecognizeWPkdTree( S, kdTreeFilePath, FeatureType, 3 );
    C_Dist =  CalculateSumDistanceCandidatesFromCenters_kdTree( S, kdTreeFilePath, FeatureType ,C);
else
    LSHFilePath = ['C:\OCRData\LSH',Letters,'\',FeatureName];
    SumDist=CalculateSumDistanceFromCenters_LSH( S, LSHFilePath, FeatureType );
    C = RecognizeWPLSH( S, kdTreeFilePath, FeatureType, 3 );
    C_Dist =  CalculateSumDistanceCandidatesFromCenters_LSH( S, LSHFilePath, FeatureType ,C);
end
end

