BTB.Tp.Dir= 'VPhack_17_06_10';
file= 'harmonicsCalibration11';

addpath('/home/blanker/git/TheHarmonicsOfMind/matlab');

%[cnt,mrk]= file_readBV(fullfile(BTB.Tp.Dir, file));
hdr= file_readBVheader(fullfile(BTB.Tp.Dir, file));
Wps= [40 49]/hdr.fs*2;
[n, Ws]= cheb2ord(Wps(1), Wps(2), 3, 50);
filt1= [];
[filt1.b, filt1.a]= cheby2(n, 50, Ws);
filt2= [];
[filt2.b, filt2.a]= cheby2(5, 20, 2.5/hdr.fs*2, 'high');
%filt= [];
%[filt.a, filt.b]= procutil_catFilters(filt1, filt2);
%combining those filters sucks

BC= [];
BC.fcn= @bbci_calibrate_hack;
BC.file= file;
BC.folder= fullfile(BTB.RawDir, BTB.Tp.Dir);
BC.read_param= {'filt',filt1};
BC.marker_fcn= @mrk_defineClasses;
%BC.marker_param= {{[1 2], [3 4], [5 6]; 'texture #1', 'texture #2', 'texture #3'}};
BC.marker_param= {{[1 3 5], [2 4 6]; 'fast', 'slow'}};
BC.settings.classes= 'auto';
BC.settings.ival= [1000 8000];
BC.settings.band= 'auto';
BC.settings.reject_channels = 1;
BC.settings.reject_artifacts = 1;
BC.settings.visu_ival= [-500 9500];
BC.settings.visu_laplace= 0;
BC.settings.do_laplace= 0;
BC.settings.filt= filt2;
%BC.settings.selband_opt= {'areas', {}};
%grd= sprintf('1,2,3,4,5,6,7,8\n9,10,11,12,13,14,15,16\n17,18,19,20,21,22,23,24\n25,26,27,28,29,30,31,32\n_,scale,_,33,34,35,legend,_');
grd= sprintf('AF7,AF3,Fz,AF4,AF8\nC5,C3,Cz,C4,C6\nP7,P3,Pz,P4,P8\nscale,O1,Oz,O2,legend');
BC.settings.grd= grd;
bbci.calibrate= BC;
[bbci, calib]= bbci_calibrate(bbci);
