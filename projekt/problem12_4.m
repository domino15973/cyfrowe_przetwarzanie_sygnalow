%% Adaptacyjny "obserwator" RLS
clear all; close all; clc;

%% Parametry
Nx = 1000; % liczba próbek
M = 2; % rząd filtra (liczba wag)
lambda_vals = [0.999, 0.99, 0.95, 0.9]; % różne wartości parametru lambda (parametr "zapominania")

%% Generacja sygnału wejściowego
x = randn(1, Nx); % szum gaussowski

%% Wagi filtra
h1 = [1, -0.5]; % wagi filtra dla pierwszej połowy sygnału
h2 = [-1, 0.5]; % wagi filtra dla drugiej połowy sygnału

%% Filtracja sygnału
d = zeros(1, Nx); % inicjalizacja sygnału wyjściowego
d(1:Nx/2) = filter(h1, 1, x(1:Nx/2)); % filtracja pierwszej połowy sygnału
d(Nx/2+1:end) = filter(h2, 1, x(Nx/2+1:end)); % filtracja drugiej połowy sygnału

%% Parametry algorytmu adaptacyjnego
mi = 0.01; % współczynnik adaptacji dla LMS i NLMS
gamma = 1e-6; % minimalna energia sygnału dla NLMS
delta = 0.01; % mała stała do inicjalizacji macierzy P

%% Adaptacyjny algorytm RLS dla różnych lambda
for lambda = lambda_vals
    [y, e, h] = adaptTZ(d, x, M, mi, gamma, lambda, delta, 3); % 3 oznacza RLS
    
    % Rysowanie wyników
    figure;
    subplot(2, 1, 1);
    plot(d, 'r'); hold on; plot(y, 'b');
    title(['Porównanie sygnałów dla \lambda = ', num2str(lambda)]);
    legend('Sygnał oryginalny', 'Sygnał filtrowany');
    xlabel('Próbki');
    ylabel('Amplituda');
    grid on;
    
    subplot(2, 1, 2);
    plot(h');
    title(['Wartości wag filtra dla \lambda = ', num2str(lambda)]);
    xlabel('Próbki');
    ylabel('Wartości wag');
    grid on;
end

function [y, e, h] = adaptTZ(d, x, M, mi, gamma, lambda, delta, ialg)
% M-dlugosc filtra, LMS: mi, NLMS: mi, gamma, RLS: lambda, delta

% Inicjalizacja
h  = zeros(M,1);       % wagi filtra
bx = zeros(M,1);       % bufor wejsciowy na probki x(n)
Rinv = delta*eye(M,M); % odwrotnosc macierzy autokorelacji Rxx^{-1} sygnalu x(n)
h_hist = zeros(M, length(x)); % historia wag filtra

% Głowna petla adaptacyjna z trzema metodami: LMS, NLMS i RLS
for n = 1 : length(x)           % glowna petla filtracji adaptacynej
    bx = [ x(n); bx(1:M-1) ];   % pobranie nowej probki sygnalu x(n) do bufora
    y(n) = h' * bx;             % filtracja sygnalu x(n): y(n) = sum( h .* bx)
    e(n) = d(n) - y(n);         % obliczenie bledu niedopasowania e(n)
    if(ialg==1)      % 1) filtr LMS
        h = h + mi * e(n) * bx;                 % korekta wag filtra
    elseif(ialg==2)  % 2) filtr NLMS
        energy = bx' * bx;                      % energia sygnalu x(n) w buforze
        h = h + mi/(gamma+energy) * e(n) * bx;  % korekta wag filtra
    else             % 3) filtr RLS
        Rinv = (Rinv - Rinv*bx*bx'*Rinv/(lambda+bx'*Rinv*bx))/lambda; % korekta Rinv
        h = h + Rinv * bx * e(n);                                     % korekta h
    end
    h_hist(:, n) = h; % zapisanie wartości wag
end
h = h_hist; % zwrócenie historii wag
end