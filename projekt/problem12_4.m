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

%% Inicjalizacja wag filtra adaptacyjnego
delta = 0.01; % mała stała do inicjalizacji macierzy P
P = (1/delta) * eye(M); % macierz odwrotności kowariancji
w = zeros(M, 1); % inicjalizacja wag filtra

%% Adaptacyjny algorytm RLS
for lambda = lambda_vals
    for n = M:Nx
        x_vec = x(n:-1:n-M+1)'; % wektor próbek sygnału wejściowego
        k = (P * x_vec) / (lambda + x_vec' * P * x_vec); % wektor zysków filtra RLS
        alpha = d(n) - w' * x_vec; % błąd predykcji
        w = w + k * alpha; % aktualizacja wag filtra
        P = (P - k * x_vec' * P) / lambda; % aktualizacja macierzy odwrotności kowariancji
        
        % Zapis wag do obserwacji
        W(:, n) = w;
    end
    
    % Rysowanie wyników
    figure;
    subplot(2, 1, 1);
    plot(d, 'r'); hold on; plot(filter(w, 1, x), 'b');
    title(['Porównanie sygnałów dla \lambda = ', num2str(lambda)]);
    legend('Sygnał oryginalny', 'Sygnał filtrowany');
    xlabel('Próbki');
    ylabel('Amplituda');
    grid on;
    
    subplot(2, 1, 2);
    plot(W');
    title(['Wartości wag filtra dla \lambda = ', num2str(lambda)]);
    xlabel('Próbki');
    ylabel('Wartości wag');
    grid on;
end