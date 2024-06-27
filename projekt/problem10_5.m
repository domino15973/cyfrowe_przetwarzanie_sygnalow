%% Łączne nad/pod-próbkowanie sygnałów
clear all; close all; clc;

%% Parametry
K = 2; % Rząd nad-próbkowania (interpolacja)
L = 3; % Rząd pod-próbkowania (decymacja)

Nx = 1000; % Liczba próbek
x = sin(2*pi*(0:Nx-1)/100); % Generacja sygnału wejściowego
[x, fs] = audioread('ukulele.wav'); x = x(:,1)'; Nx = length(x); 

% Korekta długości dla filtracji polifazowej
R = rem(Nx, K); x = x(1:end-R); Nx = Nx - R;

%% Projektowanie filtrów
h_interp = K * fir1(2*72, 1/K, kaiser(2*72 + 1, 12)); % Filtr interpolujący
g_decim = fir1(2*50, 1/L - 0.1*(1/L), kaiser(2*50 + 1, 12)); % Filtr decymatora

% Wybór filtra o węższym paśmie
if 1/K < 1/L - 0.1*(1/L)
    chosen_filter = h_interp;
    filter_type = 'interpolujący';
else
    chosen_filter = g_decim * K;
    filter_type = 'decymatora';
end

%% Nad-próbkowanie (interpolacja)
xz = zeros(1, K*Nx); % Wstawienie zer pomiędzy próbki sygnału
xz(1:K:end) = x; % Próbki sygnału
yi = filter(chosen_filter, 1, xz); % Filtracja wygładzająca

%% Pod-probkowanie (decymacja)
% Korekta długości dla filtracji polifazowej
R = rem(length(yi), L); yi = yi(1:end-R); Nyi = length(yi) - R;

y = yi(1:L:end); % L-krotny reduktor

%% Porównanie sygnałów po przepróbkowaniu z użyciem jednego oraz dwóch filtrów
figure;
subplot(3,1,1); plot(x, 'r'); title('Oryginalny sygnał');
subplot(3,1,2); plot(y, 'b'); title(['Sygnał po przepróbkowaniu z filtrem ', filter_type]);

% Użycie dwóch filtrów
% Nad-próbkowanie (interpolacja) z własnym filtrem
yi_two_filters = filter(h_interp, 1, xz);
yi_two_filters = yi_two_filters(1:end-rem(length(yi_two_filters), L));

% Pod-probkowanie (decymacja) z własnym filtrem
y_two_filters = filter(g_decim, 1, yi_two_filters);
y_two_filters = y_two_filters(1:L:end);

subplot(3,1,3); plot(y_two_filters, 'g'); title('Sygnał po przepróbkowaniu z dwoma filtrami');

%% Odsłuchanie sygnału oryginalnego i przepróbkowanego
%sound(x, 48000);
%pause(length(x)/48000 + 2);
%sound(y, 32000);

%% Użycie funkcji Matlaba resample i porównanie wyników
y_resample = resample(x, K, L);
figure;
subplot(2,1,1); plot(y, 'b'); title('Sygnał przepróbkowany ręcznie (jeden filtr)');
subplot(2,1,2); plot(y_resample, 'g'); title('Sygnał przepróbkowany funkcją resample');