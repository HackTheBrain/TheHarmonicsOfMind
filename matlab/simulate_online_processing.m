BTB.Tp.Dir= 'VPhack_17_06_10';
file= 'harmonicsCalibration11';
[cnt,mrk]= file_readBV(fullfile(BTB.Tp.Dir, file));

bbci.source.acquire_fcn= @bbci_acquire_offline;
bbci.source.acquire_param= {cnt, mrk};

bbci.log.output= 'screen&file';
bbci.log.folder= BTB.TmpDir;
bbci.log.classifier= 1;

data= bbci_apply(bbci);
