%% Demodulacja AM oraz FM sygnału z użyciem filtra Hilberta
clear all; close all; clc;

%% Parametry sygnału
fpr = 2000; % Częstotliwość próbkowania (Hz)
dt = 1/fpr; % Okres próbkowania
Nx = fpr; % Liczba próbek
t = dt * (0:Nx-1); % Oś czasu

%% Generacja sygnału z modulacją AM i FM
A = 10; % Amplituda
kA = 0.5; % Współczynnik modulacji amplitudy
fA = 2; % Częstotliwość modulacji amplitudy
xA = A * (1 + kA * sin(2 * pi * fA * t)); % Sygnał AM

kF = 250; % Współczynnik modulacji częstotliwości
fF = 1; % Częstotliwość modulacji częstotliwości
xF = kF * sin(2 * pi * fF * t); % Sygnał FM

fc = 500; % Częstotliwość nośna
x = xA .* sin(2 * pi * (fc * t + cumsum(xF) * dt)); % Sygnał zmodulowany AM i FM

%% Obliczenie sygnału analitycznego
xa = hilbert(x); % Transformata Hilberta

%% Odtworzenie amplitudy sygnału
xA_est = abs(xa); % Amplituda sygnału

%% Odtworzenie kąta fazowego sygnału
ang = unwrap(angle(xa)); % Kąt fazowy sygnału

%% Odtworzenie częstotliwości sygnału
xF_est = (1/(2*pi)) * (diff(ang) / dt); % Chwilowa częstotliwość
xF_est = [xF_est, xF_est(end)]; % Dopasowanie rozmiarów wektorów

%% Rysowanie wyników
figure;
subplot(3,1,1);
plot(t, x);
title('Zmodulowany sygnał x(t)');
xlabel('Czas (s)');
ylabel('Amplituda');
grid on;

subplot(3,1,2);
plot(t, xA, 'r', t, xA_est, 'b--');
title('Demodulacja AM');
xlabel('Czas (s)');
ylabel('Amplituda');
legend('Oryginał', 'Oszacowany');
grid on;

subplot(3,1,3);
plot(t, xF, 'r', t, xF_est - fc, 'b--');
title('Demodulacja FM');
xlabel('Czas (s)');
ylabel('Częstotliwość (Hz)');
legend('Oryginał', 'Oszacowany');
grid on;

%% Obliczanie błędów demodulacji
error_AM = xA - xA_est;
error_FM = xF - (xF_est - fc);

% Rysowanie błędów demodulacji
figure;
subplot(2,1,1);
plot(t, error_AM);
title('Błąd demodulacji AM');
xlabel('Czas (s)');
ylabel('Amplituda');
grid on;

subplot(2,1,2);
plot(t, error_FM);
title('Błąd demodulacji FM');
xlabel('Czas (s)');
ylabel('Częstotliwość (Hz)');
grid on;

%% Implementacja filtra Hilberta w postaci cyfrowej FIR
M = 40; % Połowa długości filtra
n = -M:M; % Oś próbkowania
hH = (1 - cos(pi * n)) ./ (pi * n); % Odpowiedź impulsowa
hH(M+1) = 0; % Ustawienie wartości w zerze na 0
% window = chebwin(2*M+1, 100); % Okno Chebysheva
window = blackman(2*M+1); % Okno Blackmana
hH = hH .* window'; % Filtr z oknem

% Zastosowanie filtra Hilberta
y = conv(x, hH, 'same');

% Rysowanie odpowiedzi impulsowej filtra Hilberta
figure;
stem(n, hH);
title('Odpowiedź impulsowa filtra Hilberta');
xlabel('n');
ylabel('hH(n)');
grid on;

% Odpowiedź częstotliwościowa filtra Hilberta
[H, f] = freqz(hH, 1, 1024, fpr);
figure;
subplot(2,1,1);
plot(f, abs(H));
title('Charakterystyka amplitudowa filtra Hilberta');
xlabel('Częstotliwość (Hz)');
ylabel('|H(f)|');
grid on;

subplot(2,1,2);
plot(f, angle(H));
title('Charakterystyka fazowa filtra Hilberta');
xlabel('Częstotliwość (Hz)');
ylabel('Faza (radiany)');
grid on;

%% Demodulacja za pomocą filtra FIR Hilberta
xa_fir = x + 1i * y; % Sygnał analityczny z filtra FIR Hilberta

% Odtworzenie amplitudy i fazy
xA_est_fir = abs(xa_fir);
ang_fir = unwrap(angle(xa_fir));
xF_est_fir = (1/(2*pi)) * (diff(ang_fir) / dt);
xF_est_fir = [xF_est_fir, xF_est_fir(end)];

% Rysowanie wyników demodulacji za pomocą filtra FIR Hilberta
figure;
subplot(3,1,1);
plot(t, x);
title('Zmodulowany sygnał x(t) z użyciem filtra FIR Hilberta');
xlabel('Czas (s)');
ylabel('Amplituda');
grid on;

subplot(3,1,2);
plot(t, xA, 'r', t, xA_est_fir, 'b--');
title('Demodulacja AM z użyciem filtra FIR Hilberta');
xlabel('Czas (s)');
ylabel('Amplituda');
legend('Oryginał', 'Oszacowany');
grid on;

subplot(3,1,3);
plot(t, xF, 'r', t, xF_est_fir - fc, 'b--');
title('Demodulacja FM z użyciem filtra FIR Hilberta');
xlabel('Czas (s)');
ylabel('Częstotliwość (Hz)');
legend('Oryginał', 'Oszacowany');
grid on;

%% Obliczanie błędów demodulacji dla filtra FIR Hilberta
error_AM_fir = xA - xA_est_fir;
error_FM_fir = xF - (xF_est_fir - fc);

% Rysowanie błędów demodulacji dla filtra FIR Hilberta
figure;
subplot(2,1,1);
plot(t, error_AM_fir);
title('Błąd demodulacji AM z użyciem filtra FIR Hilberta');
xlabel('Czas (s)');
ylabel('Amplituda');
grid on;

subplot(2,1,2);
plot(t, error_FM_fir);
title('Błąd demodulacji FM z użyciem filtra FIR Hilberta');
xlabel('Czas (s)');
ylabel('Częstotliwość (Hz)');
grid on;