% run first part of scalpmap_animation.m

fig_set(1, 'GridSize',[2 3]);
clf;
%hax= axes('Position',[0 0 1 1]);
set(gcf, 'Color',[0 0 0]);

vidObj = VideoWriter('/tmp/scalpmap_animation.avi');
open(vidObj);
for k= 75 + [1:200],
  [hsc, state]= plot_scalp(mnt, fv.x(:,k), opt, 'CLim',perc);
  currFrame= getframe;
  writeVideo(vidObj, currFrame);
end
close(vidObj);

