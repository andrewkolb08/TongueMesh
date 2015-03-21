function [tonguePoints, expS1, expS2, expS3] = getTonguePoints(TD, TL, TB, TD_quat, TL_quat, TB_quat)
%getTonguePoints Gets the tongue points based on the input data.
%   Calls the findTriVal function to determine the tongue heights (Y) at a
%   variety of X,Z positions.  Current implementation results in a tongue
%   mesh of 14 points, but should be reworked in the future to determine
%   algorithmically the tongue heights for any specified number of tongue
%   mesh triangles.  For now, keep it simple and make this work :)

%TD is the dorsal tongue sensor data for a given time
%TL is the lateral tongue sensor at the same time
%TB is the tongue blade sensor for the same time

tonguePoints = [TD;TL;TB];
base = [0 0 1];
p1Vec = qvqc(TD_quat,base);
p2Vec = qvqc(TL_quat,base);
p3Vec = qvqc(TB_quat,base);


%Fourth vec, fifth vec and 6th vec aren't used quite yet, but will need to
%be once the algorithm is updated.
[thirdVal,thirdVec] = findTriVal(TD,TL,TB,p1Vec,p2Vec,p3Vec);
tonguePoints = [tonguePoints;thirdVal];

[fourthVal,fourthVec] = findTriVal(thirdVal,TL,TB,thirdVec,p2Vec,p3Vec);
tonguePoints = [tonguePoints;fourthVal];

[fifthVal,fifthVec] = findTriVal(TD,TL,thirdVal,p1Vec,p2Vec,thirdVec);
tonguePoints = [tonguePoints;fifthVal];

[sixthVal,sixthVec] = findTriVal(TD,thirdVal,TB,p1Vec,thirdVec,p3Vec);
tonguePoints = [tonguePoints;sixthVal];

%Reflect the mesh across the z-axis
tonguePoints = [tonguePoints; tonguePoints(:,1:2), -tonguePoints(:,3)];
if(any(isnan(tonguePoints)))
    disp('you suck')
end

end

