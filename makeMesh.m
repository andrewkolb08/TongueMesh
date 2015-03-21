function makeMesh(hObject,event,tri,triLengths,tonguePoints,hMeshPlot,hSpec,hLine,meshHandle,fs)
   %Get the slider value (0 to 1)
    n = round(get(hObject,'Value'));
    %Assign the values of the tonguePoints
    tpStart = 14*(n-1)+1;
    tpFinish = 14*(n-1)+14;
    
    
    triStart = sum(triLengths(1:n));
    triFinish = triStart + triLengths(n)-1;
    set(hMeshPlot,'xdata',tonguePoints(tpStart:tpFinish,1));
    set(hMeshPlot,'ydata',tonguePoints(tpStart:tpFinish,3));
    set(hMeshPlot,'zdata',tonguePoints(tpStart:tpFinish,2));
    set(hMeshPlot,'Faces',tri(triStart:triFinish,:));
    set(0,'CurrentFigure',meshHandle);
    %Uncomment if you want the title to update as you go.. otherwise just
    %use the spectrogram.
    title([' Tongue Mesh at ',num2str(n/fs),' seconds']);
    set(hLine, 'XData', [], 'YData', [],'ZData',[])
    set(hLine,'Xdata',[n/fs n/fs],'YData',[0,6000],'Color','k');
    set(0,'CurrentFigure',hSpec)
    zl = zlim;
    axis([xlim ylim zl(1) max(0, zl(2))])
	view(0,90)
    drawnow;
end