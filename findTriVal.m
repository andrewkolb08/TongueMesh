%findTriVal
function [triVal,triVec] = findTriVal(p1,p2,p3,p1Vec,p2Vec,p3Vec,toCalc)

points = [p1;p2;p3];

if(nargin<7)
    centroid = [mean(points(:,1)),mean(points(:,3))];
else
    centroid = [toCalc(1),toCalc(3)];
end
% plot(points(:,1),points(:,3), '*');

% plot(centroid(1),centroid(2),'.')

distWeights = [1./(norm([points(1,1),points(1,3)]-centroid)),1./(norm([points(2,1),points(2,3)]-centroid)),1./(norm([points(3,1),points(3,3)]-centroid))];
totalDist = sum(distWeights);

%Write the equation in point-slope form and calculate the equation.
%Then, plug in for x and y of centroid to get the z value.  Weight each of
%the z values and then sum together to get the final z value.

p1Plane = @(xy) p1(1,2)+(p1Vec(1).*(xy(1)-p1(1,1))+p1Vec(3).*(xy(2)-p1(1,3)))./(-p1Vec(2));

p2Plane = @(xy) p2(1,2)+(p2Vec(1).*(xy(1)-p2(1,1))+p2Vec(3).*(xy(2)-p2(1,3)))./(-p2Vec(2));

p3Plane = @(xy) p3(1,2)+(p3Vec(1).*(xy(1)-p3(1,1))+p3Vec(3).*(xy(2)-p3(1,3)))./(-p3Vec(2));

triYVal = (distWeights(1)*p1Plane(centroid)+ distWeights(2)*p2Plane(centroid)+ distWeights(3)*p3Plane(centroid))./totalDist;
triVal = [centroid(1),triYVal,centroid(2)];
triVec = mean([distWeights(1).*p1Vec;distWeights(2).*p2Vec;distWeights(3).*p3Vec]./totalDist);
triVec = triVec./norm(triVec);

end