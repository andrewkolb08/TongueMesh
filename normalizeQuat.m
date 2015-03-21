function [outQuat] = normalizeQuat(inQuat)
%normalizeQuat Normalizes the quaternion data passed in.
%   Assumes that the quaternion data is in the format [qx,qy,qz,q0] in a
%   nx4 matrix.

in_quat_cell = arrayfun(@(idx) inQuat(idx,:)./norm(inQuat(idx,:)), 1:size(inQuat,1), 'UniformOutput',0);
outQuat = reshape(cell2mat(in_quat_cell)',size(inQuat,2),size(inQuat,1))';

end

