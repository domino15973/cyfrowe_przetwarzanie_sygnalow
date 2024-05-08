clear all; close all; clc;

%% wczytanie sygnału wejściowego
[dref,fs] = audioread('mowa8000.wav');

%% sygnał z szumem białym zamiast mowy
X = zeros(length(dref),1);
drefAWGN = awgn(X,30);

%% tworzenie filtru
hr = zeros(1,255);
hr(30)  = 0.1;
hr(120) = -0.5;
hr(255) = 0.8;

%% przejście próbek przez obiekt
d = conv(dref,hr)';      % sygnał mowa
x = dref';

d2 = conv(drefAWGN,hr)'; % sygnał awgn
x2 = drefAWGN';

%% filtr adaptacyjny ANC - sygnał mowa
M  = 256;   % długość filtru
mi = 0.04;  % współczynnik szybkości adaptacji

y  = []; e = [];    % sygnały wyjściowe z filtra
bx = zeros(M,1);    % bufor na próbki wejściowe x
h  = zeros(M,1);    % początkowe (puste) wagi filtru

for n = 1 : length(x)
    bx   = [ x(n); bx(1:M-1) ];          % pobierz nową próbkę x[n] do bufora
    y(n) = h' * bx;                      % oblicz y[n] = sum( x .* bx) – filtr FIR
    e(n) = d(n) - y(n);                  % oblicz e[n]
    h    = h + mi * e(n) * bx;           % LMS
    % h  = h + mi * e(n) * bx /(bx'*bx); % NLMS
end

%% filtr adaptacyjny ANC - sygnał awgn
M2  = 256;  % długość filtru
mi2 = 0.04; % współczynnik szybkości adaptacji

y2  = []; e2 = [];  % sygnały wyjściowe z filtra
bx2 = zeros(M2,1);  % bufor na próbki wejściowe x
h2  = zeros(M2,1);  % początkowe (puste) wagi filtru

for m = 1 : length(x2)
    bx2   = [ x2(m); bx2(1:M2-1) ];              % pobierz nową próbkę x[n] do bufora
    y2(m) = h2' * bx2;                           % oblicz y[n] = sum( x .* bx) – filtr FIR
    e2(m) = d2(m) - y2(m);                       % oblicz e[n]
    h2    = h2 + mi2 * e2(m) * bx2;              % LMS
    % h2  = h2 + mi2 * e2(m) * bx2 /(bx2'*bx2);  % NLMS
end

%% wykresy
figure(1);
subplot(1,2,1);
hold all;
plot(abs(h),'b');
plot(abs(hr),'r');
title('Porównanie odpowiedzi - sygnał mowa');
legend('Estymacja odpowiedzi','Odpowiedź impulsowa');

subplot(1,2,2);
hold all;
plot(abs(h2),'b');
plot(abs(hr),'r');
title('Porównanie odpowiedzi - sygnał AWGN');
legend('Estymacja odpowiedzi','Odpowiedź impulsowa');