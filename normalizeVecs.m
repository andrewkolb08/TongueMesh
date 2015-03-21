function [outVecs] = normalizeVecs(inVecs)
%normalizeVecs Takes in vector of form [x,y,z] and normalizes it
%   Also built to accept matrices of vectors where the inVec is an nx3
%   matrix

inVecsCell = arrayfun(@(ind) inVecs(ind,:)./norm(inVecs(ind,:)),1:size(inVecs,1),'UniformOutput',0);
outVecs = reshape(cell2mat(inVecsCell)',3,size(inVecs,1))';

end

