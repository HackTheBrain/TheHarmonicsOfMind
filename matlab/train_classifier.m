BTB.Tp.Dir= 'VPhack_17_06_10';
file= 'harmonicsCalibration11';
DRY_CAP= true;

addpath('/home/blanker/git/TheHarmonicsOfMind/matlab');

%[cnt,mrk]= file_readBV(fullfile(BTB.Tp.Dir, file));

hdr= file_readBVheader(fullfile(BTB.Tp.Dir, file));
Wps= [40 49]/hdr.fs*2;
[n, Ws]= cheb2ord(Wps(1), Wps(2), 3, 50);
filtLP= [];
[filtLP.b, filtLP.a]= cheby2(n, 50, Ws);
filtHP= [];
[filtHP.b, filtHP.a]= cheby2(5, 20, 2.5/hdr.fs*2, 'high');

BC= [];
BC.fcn= @bbci_calibrate_hack;
BC.file= file;
BC.folder= fullfile(BTB.RawDir, BTB.Tp.Dir);
BC.read_param= {'filt',filtHP};
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
BC.settings.filt= filtLP;
%BC.settings.clab= {'not','Acc*'};
%BC.settings.selband_opt= {'areas', {}};
if DRY_CAP,
  grd= sprintf('AF7,AF3,Fz,AF4,AF8\nC5,C3,Cz,C4,C6\nTP7,P3,Pz,P4,TP8\nP7,O1,Oz,O2,TP8\nscale,Acc1,Acc2,Acc3,legend');
else
  grd= sprintf('AF7,AF3,Fz,AF4,AF8\nC5,C3,Cz,C4,C6\nP7,P3,Pz,P4,P8\nscale,O1,Oz,O2,legend');
end
BC.settings.grd= grd;
bbci.calibrate= BC;
[bbci, calib]= bbci_calibrate(bbci);

keyboard
clear calib

bbci.calibrate.marker_param= {{[1 2], [3 4], [5 6]; 'texture #1', 'texture #2', 'texture #3'}};
bbci.calibrate.settings.classes= 'auto';
[bbci2, calib2]= bbci_calibrate(bbci);

bbci1= bbci;
bbci.signal(2)= bbci2.signal;
bbci.feature(2)= bbci2.feature;
bbci.feature(2).signal= 2;
bbci.feature(1).signal= 1;
bbci.classifier(2)= bbci2.classifier;
bbci.classifier(2).feature= 2;
bbci.classifier(1).feature= 1;
bbci.control.classifier= [1 2];
bbci.control.source_list= [1 2];

if DRY_CAP,
  bbci.source.acquire_fcn= @bbci_acquire_lsl;
  [sos, g]= tf2sos(filtHP.b, filtHP.a);
  filtHd_HP= dfilt.df2sos(sos, g);
  bbci.source.acquire_param= {'FiltHd',filtHd_HP};
else
  do sth here
end

bbci_typeChecking('off');
