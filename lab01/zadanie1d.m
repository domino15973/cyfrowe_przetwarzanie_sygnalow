clear all; close all; clc;

duration = 1;
base_sampling_frequency = 10000;
sampling_frequency = 25;

carrier_frequency = 50;

% modulation_frequency = 1;
% modulation_depth = 5;

modulation_frequency = 10;
modulation_depth = 20;

time_domain = 0:1/base_sampling_frequency:duration;
dt = time_domain(2) - time_domain(1);

modulating_signal = sin(2 * pi * modulation_frequency * time_domain);

modulated_signal = sin(2 * pi * (carrier_frequency * time_domain + modulation_depth * cumsum(modulating_signal*dt)));

figure;

subplot(2, 1, 1);
plot(time_domain, modulated_signal, 'b', 'LineWidth', 1.5);
hold on;
plot(time_domain, modulating_signal, 'r--', 'LineWidth', 1.5);
title('Sygnał zmodulowany FM wraz z sygnałem modulującym');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
legend('Sygnał zmodulowany', 'Sygnał modulujący');
grid on;

time_domain_sampling = 0:1/sampling_frequency:duration;
% próbkowanie sygnału poprzez interpolacje z czasami próbek
samples = interp1(time_domain, modulated_signal, time_domain_sampling);

subplot(2, 1, 2);
plot(time_domain, modulated_signal, 'b', 'LineWidth', 1.5);
hold on;
stem(time_domain_sampling, samples, 'r', 'LineWidth', 1.5);
title('Porównanie zmodulowanego i spróbkowanego sygnału FM');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
legend('Sygnał zmodulowany', 'Sygnał spróbkowany');
grid on;

% Error using spectrum
% SPECTRUM has been deprecated. Use PSPECTRUM or PERIODOGRAM instead.

figure;

subplot(1, 2, 1);
pspectrum(modulated_signal, base_sampling_frequency);
title('Gęstość widmowa mocy przed próbkowaniem');
xlabel('Częstotliwość [Hz]');
grid on;

subplot(1, 2, 2);
pspectrum(samples, sampling_frequency);
title('Gęstość widmowa mocy po próbkowaniu');
xlabel('Częstotliwość [Hz]');
grid on;
