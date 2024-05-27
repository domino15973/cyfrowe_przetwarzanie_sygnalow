clear all; close all; clc;

%% Wczytanie próbki dźwiękowej
[x, Fs] = audioread( 'DontWorryBeHappy.wav', 'native' );
x = double( x );

%% KODER
a = 0.9545; % parametr a kodera
d = x - a*[[0,0]; x(1:end-1,:)]; % KODER

%% KWANTYZACJA
% rozdzielczość sygnału w bitach - ilość stanów 2^n wartości
ile_bitow = 7;      % 6/7 bitów zaczynają się zakłócenia
dq = lab11_kwant(d, ile_bitow); % kwantyzator

n = 1:length(x); % oś x do wykresow

% wykres porównujący sygnał przed i po kwantyzacji
figure;

subplot(2,2,1);
hold on;
plot( n, d(:,1), 'b');
%plot( n, dq(:,1), 'r');
title('Oryginalny kanał lewy');

subplot(2,2,2);
hold on;
plot( n, d(:,2), 'r');
%plot( n, dq(:,2), 'r');
title('Oryginalny kanał prawy'); 

subplot(2,2,3);
hold on;
plot( n, dq(:,1), 'b');
title('Kwantyzacja kanał lewy'); 

subplot(2,2,4);
hold on;
plot( n, dq(:,2), 'r');
title('Kwantyzacja kanał prawy'); 

%% DEKODER - faktyczne zadanie
% dekodowanie sygnału nieskwantyzowanego

y1(1) = d(1,1); % kanał lewy
for k = 2:length(dq)
    y1(k) = d(k,1) + a*y1(k-1);
end

y2(1) = d(1,2); % kanał prawy
for k = 2:length(dq)
    y2(k) = d(k,2) + a*y2(k-1);
end

% dekodowanie sygnału z kwantyzacją
ydl(1) = dq(1,1); % kanał lewy
for k = 2:length(dq)
    ydl(k) = dq(k,1) + a*ydl(k-1);
end

ydp(1) = dq(1,2); % kanał prawy
for k = 2:length(dq)
    ydp(k) = dq(k,2) + a*ydp(k-1);
end

%% Wykresy (po dekodowaniu)
figure;

subplot(1,2,1);
hold on;
plot( n, x(:,1), 'k');
plot( n, y1, 'b.');
title('Zdekodowany kanał lewy'); 
legend('Oryginalny','Zdekodowany');

subplot(1,2,2);
hold on;
plot( n, y2, 'k');
plot( n, x(:,2), 'r.');
title('Zdekodowany kanał prawy'); 
legend('Oryginalny','Zdekodowany');

figure;

subplot(1,2,1);
hold on;
plot( n, x(:,1), 'k');
plot( n, ydl, 'b.');
title('Zdekodowany kanał lewy (z kwantyzacją)');
legend('Oryginalny','Zdekodowany');

subplot(1,2,2);
hold on;
plot( n, x(:,2), 'k');
plot( n, ydp, 'r.');
title('Zdekodowany kanał prawy (z kwantyzacją)'); 
legend('Oryginalny','Zdekodowany');

%% Obliczanie błędu
disp('Różnica między oryginałem a odtworzonym:');
max_error_left = abs(max(x(:,1) - y1'))
max_error_right = abs(max(x(:,2) - y2'))

disp('Różnica między oryginałem skwantowanym a odtworzonym:');
max_error_left_quantized = abs(max(x(:,1) - ydl'))
max_error_right_quantized = abs(max(x(:,2) - ydp'))

% łączymy zdekodowany sygnał prawy z lewym
% y_decode = vertcat(y1,y2); 
% soundsc(y_decode,Fs); % odtwarzamy stereo

% łączymy zdekodowany sygnał prawy z lewym
y_kwant = vertcat(ydl,ydp); 
soundsc(y_kwant,Fs); % odtwarzamy stereo

function y = lab11_kwant(x,b) % (sygnał, liczba bitów)
      xlewy = x(:,1);   % rozdzielamy na kanał lewy i prawy
      xprawy = x(:,2);
      xMinLewy = min(xlewy);    % znajdujemy min i max w każdym
      xMaxLewy = max(xlewy);
      xMinPrawy = min(xprawy);
      xMaxPrawy = max(xprawy);
      
      % minimum, maksimum, zakres (odległość punktów od siebie)
      x_zakresLewy = xMaxLewy - xMinLewy; 
      x_zakresPrawy = xMaxPrawy - xMinPrawy;
      
      % liczba bitów, liczba przedziałów kwantowania
      Nb=b; Nq=2^Nb; 
      % szerokość przedziału kwantowania
      dx = x_zakresLewy/Nq; % dzielimy na równe progi
      xqlewy = dx*round(xlewy/dx); % zaokrąglamy do najbliższego progu
      
      dx = x_zakresPrawy/Nq;
      xqprawy = dx*round(xprawy/dx);
      
      % funkcja zwraca sygnał stereo - złożenie horyzontalne
      y = horzcat(xqlewy,xqprawy);  % składa sygnał z dwóch kanałów
end
