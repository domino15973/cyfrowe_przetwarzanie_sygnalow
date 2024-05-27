clear all; close all; clc;

%% Dane
[x, fpr] = audioread('DontWorryBeHappy.wav');
x = double(x);
x = x(:, 1); % Przetwarzamy lewy kanał
% x = x(1:1024);

%% Okno analizy i syntezy
% N = 32; % Długość okna w próbkach
N = 128;
n = 0:N-1;
h = sin(pi*(n+0.5)/N); % Okno analizy i syntezy

figure;
plot(n, h);
hold all;
grid;
title("Okno analizy i syntezy");
xlabel("Próbki");
ylabel("Amplituda");

%% Macierz analizy Modified DCT
A = zeros(N/2, N); 
for k = 1:N/2 
    A(k, :) = sqrt(4/N) * cos(2*pi/N * (k-1+0.5) * (n+0.5+N/4));
end

%% Macierz syntezy (transponowanie macierzy analizy)
S = A';

%% Przetwarzanie sygnału
% Pozbywamy się częstotliwości mniej znaczących
Q = 70; % Współczynnik skalujący, około 70 jest optymalny

% Inicjalizacja zmiennych
y = zeros(1, length(x));
dref = y;

for i = 1:N/2:length(x)-N
    % Pobranie próbki o długości okna
    probka = x(i:i+N-1);
    
    % Okienkowanie; mnożenie przez okno
    okienkowany = probka' .* h;
    
    % Analiza; mnożenie przez macierz analizy
    analizowany = A * okienkowany';
    
    % Kwantyzacja
    kwantyzowany = round(analizowany * Q);
    
    % Synteza; mnożenie przez macierz syntezy
    syntezowany = S * kwantyzowany;
    
    % Ponowne okienkowanie
    odokienkowany = h .* syntezowany';
    
    % Zapisywanie do sygnału
    y(i:i+N-1) = y(i:i+N-1) + odokienkowany;
    
    % Referencja bez kwantyzacji
    syntezowany = S * analizowany;
    odokienkowany = h .* syntezowany';
    dref(i:i+N-1) = dref(i:i+N-1) + odokienkowany;
end

% Zmniejszanie amplitudy. Pomaga ukryć szumy
y = y / Q;

%% Błąd
max_error = max(abs(x - y'))
mean_error = mean(abs(x - y'))

%% Wykresy
n = 1:length(x);

figure;
hold all;
plot(n, x);
plot(n, y);
title('Sygnał oryginalny vs po odkodowaniu z MDCT');
legend('Referencyjny', 'Zrekonstruowany');

%% Słuchanie
soundsc(y, fpr);