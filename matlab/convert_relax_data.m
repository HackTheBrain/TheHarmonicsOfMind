file= 'VPae_09_08_11/relaxVPae';
[cnt, mrk]= file_readBV(file);
cnt2= cnt.x(:,ci);
wav_fs= 44100;
y= resample(cnt2, wav_fs, cnt.fs);
max_y= max(abs(y(:)));
y= y/max_y;
audiowrite('/tmp/relax_eeg.wav', y, wav_fs);
