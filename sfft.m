function [f,Amp,time,fft_signal,NFFT]=sfft(y,Fs,L)
T = 1/Fs;                     % Sample time
% L = 500;                     % Length of signal
t = (0:L-1)*T;                % Time vector
time=Fs*t;
% subplot(211)
% plot(time,y)
% title('Signal Corrupted with Zero-Mean Random Noise')
% xlabel('time (milliseconds)')
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
fft_signal = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);
% subplot(212)
% Plot single-sided amplitude spectrum.
Amp=2*abs(fft_signal(1:NFFT/2+1));
% plot(f,Amp) 
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
