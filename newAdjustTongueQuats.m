function [TD_quat,TL_quat,TB_quat] = newAdjustTongueQuats(TD,TL,TB,TD_quat,TL_quat,TB_quat,sensfilename)
%newAdjustTongueQuats  
%Let's try averaging the quaternions for resting position in the first 3
%seconds of the words data records.


TD_avg = -avg_quaternion_markley(TD_quat(:,1:4));
TL_avg = -avg_quaternion_markley(TL_quat(:,1:4));
TB_avg = -avg_quaternion_markley(TB_quat(:,1:4));
%Start by determining the adjustment quaternions
% if(exist(quatfile,'file')==2)
%     quatVals = load(quatfile);
%     TD_quat_adj = quatVals(1,:);
%     TL_quat_adj = quatVals(2,:);
%     TB_quat_adj = quatVals(3,:);
% else
true_quat = [-sqrt(2)/2, 0, 0, sqrt(2)/2];

    TD_quat_adj = qmult(qconj(TD_avg),true_quat);
    TL_quat_adj = qmult(qconj(TL_avg),true_quat);
    TB_quat_adj = qmult(qconj(TB_avg),true_quat);
    
%     disp(num2str(minVal));
%     disp(TD_quat_adj);
%     disp(TL_quat_adj);
%     disp(TB_quat_adj);
%     disp('We advise you create a file "subname_quatCorrect.mat" to hold the quaternions corresponding minimum angle across all records for a given subject');
%end

TD_quat = qmult(TD_quat,TD_quat_adj);
TL_quat = qmult(TL_quat,TL_quat_adj);
TB_quat = qmult(TB_quat,TB_quat_adj);

%Normalize to get rid of round-off error
TD_quat = normalizeQuat(TD_quat);
TL_quat = normalizeQuat(TL_quat);
TB_quat = normalizeQuat(TB_quat);

end
