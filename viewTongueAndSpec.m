function toReturn = viewTongueAndSpec(soundfilename,sensfilename,startTime,endTime, kinfs)

%Shows the tongue and spectrogram associated with a certain interval of
%data.  
%INPUTS:
%   soundfilename: .wav file with the audio data
%   sensfilename: .tsv file with the kinematic data
%   startTime: the start of time interval that is desired for visualization
%   endTime: the end of time interval that is desired for visualization
%   kinfs: 400 Hz, for the EMA-MAE database, but can be changed for other
%   datasets.
%
%OUTPUTS:
%   toReturn: gives the audio to be played.

[sound, soundfs] = audioread(soundfilename);
[data, ~] = loadtsv(sensfilename);

%Get the tongue sensor data
%Sensor data is in the format q0,qx,qy,qz
%Quaternion data is of the form qx,qy,qz,q0, so exchange it rearrange it.
TD = data(:,15:17);
TD_quat = [data(:,19:21), data(:,18)];
TL=data(:,24:26);
TL_quat = [data(:,28:30), data(:,27)];
TB=data(:,33:35);
TB_quat = [data(:,37:39), data(:,36)];

%Now use the quaternion data to adjust for initial sensor orientation.  We
%only care about deviations from a flat-tongue baseline.
%Start by determining the adjustment quaternions
[TD_quat,TL_quat,TB_quat] = newAdjustTongueQuats(TD,TL,TB,TD_quat,TL_quat,TB_quat,sensfilename);

%%%%%%%%%%%%%%%%%%%%%%%    END PREPROCESSING    %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%  BEGIN TONGUE MESH CREATION %%%%%%%%%%%%%%%%%%%%%%%
%Calculate the height of
%the mesh point, based on the point-slope calculation from each point, and
%a weighted average that is weighted based on the distance from each point
%to the centroid.  The result is 14 points per tongue mesh.

%Need to plot the tongue at all time points, so calculate the tongue at all
%time points.
startInd = round(startTime*kinfs);
endInd = round(endTime*kinfs);
numOfInds = endInd-startInd;
tonguePoints = zeros(14*numOfInds,3); %Exactly 14 tongue values per time point
tri = zeros(20*numOfInds,3);  % about 20 tri values per timePoint
triStart = 1;
triLengths = zeros(1,numOfInds);


for i=1:(endInd-startInd+1)
    timePoint = i+startInd;
    tpStart = 14*(i-1)+1;
    tpFinish = 14*(i-1)+14;
    tonguePoints(tpStart:tpFinish,:) = getTonguePoints(TD(timePoint,:),TL(timePoint,:),TB(timePoint,:),TD_quat(timePoint,:),TL_quat(timePoint,:),TB_quat(timePoint,:));
    tempTri = delaunay(tonguePoints(tpStart:tpFinish,1),tonguePoints(tpStart:tpFinish,3));
    triFinish = triStart + length(tempTri)-1;
    triLengths(i) = triFinish-triStart+1;
    tri(triStart:triFinish,:) = tempTri;
    triStart = triFinish+1;
end
%Plot a spectrogram of the time segment of data that we have
%signal,hammingWindowSize,overlap,fftLength,samplef,frequencylocation
soundStartInd = round(startTime*soundfs);
soundEndInd = round(endTime*soundfs);
soundToPlay = audioplayer(sound(soundStartInd-(0.5*soundfs):soundEndInd+(0.5*soundfs)),soundfs);
toReturn = sound(soundStartInd-(0.5*soundfs):soundEndInd+(0.5*soundfs));

hSpec = figure(1);
set(hSpec,'Position',[100 200 500 400]);
spectrogram(sound(soundStartInd:soundEndInd),512,256,1024,soundfs,'yaxis')
title('Spectrogram of Sound Signal')
axis([0 endTime-startTime 0 6000])
hLine = line('Xdata',[0 0],'YData',[0,6000],'Color','k');

meshHandle = figure(2);
set(meshHandle,'Position',[800 200 500 400]);
hMeshPlot = trimesh(tri(1:20,:),tonguePoints(1:14,1),tonguePoints(1:14,3),tonguePoints(1:14,2));
h = uicontrol('Style','Slider','Min',1,'Max',numOfInds,'Value',(numOfInds/2),'SliderStep',[1,50]./(numOfInds-1),'Position',[5 5 300 20]);
addlistener(h,'ContinuousValueChange',@(hObject, event) makeMesh(hObject, event,tri,triLengths,tonguePoints,hMeshPlot,hSpec,hLine,meshHandle,kinfs));
pbh1 = uicontrol(meshHandle,'Style','pushbutton','Position',[415 5 80 20],'String','Next plot','Callback',@(hObject,event) eval('close all'));
pbh2 = uicontrol(meshHandle,'Style','pushbutton','Position',[330 5 80 20],'String','Play Sound','Callback',@(hObject,event) play(soundToPlay));
axis([-55,0,-30,30,-25,25])
xlabel('x');
ylabel('z');
zlabel('y');
%Default to showing the midpoint, looking from the XZ plane
makeMesh(h,'ContinuousValueChange',tri,triLengths,tonguePoints,hMeshPlot,hSpec,hLine,meshHandle,kinfs);
set(0,'CurrentFigure',2);
view(2,2)

play(soundToPlay);
%%%%%%%%%%%%%%%%%%%%  END TONGUE MESH CREATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%