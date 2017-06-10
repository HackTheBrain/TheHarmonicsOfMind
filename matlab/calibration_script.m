cue_dir= '/home/blanker/git/TheHarmonicsOfMind/cues';
duration_trial= 10;
nTrialsPerCondition= 15;
dur= duration_trial*nTrialsPerCondition;
fprintf('pure recodring time is %d.%d min.\n', floor(dur/60), 60*(dur/60-floor(dur/60)));

dd= dir(fullfile(cue_dir, 'texture*'));
textures= {dd.name};
nTextures= length(textures);
img= cell(nTexture, 1);
for k= 1:nTextures,
  img{k}= imread(fullfile(cue_dir, textures{k}));
end

instructions= {'move fast', 'move slow'};
nInstructions= length(instructions);

nTrials= nConditions*nTrialsPerCondition;
nConditions= nTextures * nInstructions;
trial_list= repmat(1:nConditions, nTrialsPerCondition, 1);
pp= randperm(nTrials);
trial_list= trial_list(pp);

bbci.trigger.fcn = @bbci_trigger_lsl;
bbci.trigger.param = {};
bbci_trigger(bbci, 'init');
bbci.trigger.param = BTB.Acq.TriggerParam;
CUE_OFFSET= 0;

fig_set(1);
hax1= [];
for k= 1:nTextures,
  hax1(k)= axes('Position', [0 0 .5 1]);
  him(k)= imagesc(img{k});
  axis square
end
set(hax1, 'Visible','off');
set(him, 'Visible','off');
hax2= axes('Position',[0.5 0 .5 1]);
for k= 1:nInstructions,
  ht(k)= text(.5, .5, instructions{k});
end
set(ht, 'Visible','off');
set(ht, 'HorizontalAli','center', 'VerticalAli','middle');
set(ht, 'FontUnits','normalized', 'FontWeight','bold');
set(ht, 'FontSize',.1);
set(hax2, 'Visible','off');

bbci_trigger(bbci, 251);
pause(1);
for k= 1:nTrials,bbci_trigger(bbci, 251);
  trtype= trial_list(k);
  it= ceil(trtype/nInstructions);
  ii= 1 + mod(trtype-1, nInstructions);
  fprintf('trial #%d: texture: #%d, instr: #%d\n', k, it, ii);
  bbci_trigger(bbci, CUE_OFFSET + trtype);
  set(him(it), 'Visible','on');
  set(ht(ii), 'Visible','on');
  pause(duration_trial);
  bbci_trigger(bbci, 100);
  set(him(it), 'Visible','off');
  set(ht(ii), 'Visible','off');
  pause(duration_pause);
end
pause(1);
bbci_trigger(bbci, 255);
pause(1);
bbci_trigger(bbci, 'close');
