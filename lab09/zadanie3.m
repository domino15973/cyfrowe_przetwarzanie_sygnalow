clear all; close all; clc;

% parametry sygnału
fpilot = 19000; % częstotliwość 19 kHz
fs = 44100;     % częstotliwość próbkowania
t  = 0:1/fs:1;  % wektor czasu od 0 do 1 sekundy z częstotliwością próbkowania fs

phase_offset = pi/4; % przesunięcie fazowe o pi/4 radianów

df = 10;    % zmiana częstotliwości ±10 Hz
fm = 0.1;   % częstotliwość zmiany częstotliwości (10 sekund)

p = sin(2*pi*fpilot*t + phase_offset);
p = awgn(p, 0, 'measured'); 

% delta_f = df * sin(2*pi*fm*t);
% p = sin(2*pi*(fpilot + delta_f).*t + phase_offset);

% Petla PLL z filtrem typu IIR do odtworzenia częstotliwości i fazy pilota [7]
% i na tej podstawie sygnałów nośnych: symboli c1, stereo c38 i danych RDS c57
freq  = 2*pi*fpilot/fs;
theta = zeros(1,length(p)+1);
alpha = 1e-2;
beta  = alpha^2/4;
for n = 1 : length(p)
    perr = -p(n)*sin(theta(n));
    theta(n+1) = theta(n) + freq + alpha*perr;
    freq = freq + beta*perr;
end
    
% obliczenie składowych sygnału
c1  = cos((1/19)*theta(1:end-1));
c19 = cos(theta(1:end-1));
c38 = cos(2*theta(1:end-1));
c57 = cos(3*theta(1:end-1));

% sumowanie sygnałów
signal_sum = c1 + c19 + c38 + c57;
fft_signal = fft(signal_sum);

% wykres w dziedzinie częstotliwości
Fs = fs;                    % częstotliwość próbkowania
N  = length(signal_sum);    % długość sygnału
f  = linspace(0, Fs, N);    % wektor częstotliwości
f_khz = f / 1000;           % konwersja częstotliwości na kHz

figure;
plot(f_khz, abs(fft_signal));
title('FFT Sumy Częstotliwości');
xlabel('Częstotliwość (kHz)');
ylabel('Amplituda');