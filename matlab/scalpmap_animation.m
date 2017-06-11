%BTB.Tp.Dir= 'VPhack_17_06_10';
%file= 'harmonicsCalibration11';
BTB.Tp.Dir= 'VPhack_17_06_11';
file= 'harmonicsCalibration12';
[cnt,mrk]= file_readBV(fullfile(BTB.Tp.Dir, file));

bbci.source.acquire_fcn= @bbci_acquire_offline;
bbci.source.acquire_param= {cnt, mrk};

bbci.log.output= 'screen&file';
bbci.log.folder= BTB.TmpDir;
bbci.log.classifier= 1;

bbci.signal(3).clab= bbci.signal(1).clab;
bbci.signal(3).proc= bbci.signal(1).proc(2:end);
bbci.feature(3).signal= 3;
bbci.feature(3).proc= {@proc_dB};
bbci.feature(3).ival= [-1000 0];

close all
fig_set(1);
clab_all= bbci.signal(3).clab;
clab0= intersect(clab_all, util_scalpChannels);
idx= find(ismember(bbci.signal(3).clab, clab0));
clab= bbci.signal(3).clab(idx);
clab_idx= find(ismember(bbci.signal(3).clab, clab));

mnt= mnt_setElectrodePositions(clab);
ct= proc_selectChannels(cnt, clab);
ct= proc_filt(ct, bbci.signal(3).proc{1}{2:3});
ct= proc_filt(ct, bbci.signal(3).proc{2}{2:3});
mrk.time= 1:50:size(ct.x,1)/cnt.fs*1000-1000;
mrk.y= ones(1,length(mrk.time));
fv= proc_segmentation(ct, mrk, [0 500]);
fv= proc_variance(fv);
fv= proc_dB(fv);
fv= proc_flaten(fv);
perc= stat_percentiles(fv.x(:), [10 90]);
opt= struct('LineProperties', {{'LineWidth',16, 'Color',[1 0 0]}});

clf;
%hax= axes('Position',[0 0 1 1]);
set(gcf, 'Color',[0 0 0]);
k= 0;
while 1,
  k= mod(k, size(fv.x,2)) + 1;
  [hsc, state]= plot_scalp(mnt, fv.x(:,k), opt, 'CLim',perc);
  drawnow;
end



