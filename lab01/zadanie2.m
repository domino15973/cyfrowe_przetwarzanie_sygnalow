clear all; close all; clc;

sin_frequency = 2;
% sin_frequency = 10;
sampling_frequency = 50;
% sampling_frequency = 200;

T1 = 1 / sampling_frequency; % okres pierwotnego sygnału

rec_signal_frequency = sampling_frequency * 50;
T2 = 1 / rec_signal_frequency; % okres rekonstruowanego sygnału

duration = 1;
sampling_time_domain = 0:(1/sampling_frequency):duration;
samples = sin(2 * pi * sin_frequency * sampling_time_domain);

figure;
subplot(2, 1, 1);
plot(sampling_time_domain, samples, 'o-');
title(sprintf('Sygnał próbkowany z częstotliwością %d Hz', sampling_frequency));
xlabel('Czas [s]');
ylabel('Amplituda [V]');
grid on;

rec_time_domain = 0:(1/rec_signal_frequency):duration;
rec_signal = zeros(1, length(rec_time_domain));

for x2 = 1:length(rec_time_domain)
    rec_sample_value = 0;
    for x1 = 1:length(sampling_time_domain)
        t = x2 * T2;
        nT = x1 * T1;
        rec_point_value = pi / T1 * (t - nT);
        sampling_value = 1;
        
        if rec_point_value ~= 0
            sampling_value = sin(rec_point_value) / rec_point_value;
        end
        
        rec_sample_value = rec_sample_value + samples(x1) * sampling_value;
    end
    rec_signal(x2) = rec_sample_value;
end

subplot(2, 1, 2);
plot(rec_time_domain, rec_signal, 'rx-');
title('Sygnał odtworzony');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
grid on;

perfect_signal = sin(2 * pi * sin_frequency * 0:(1/rec_signal_frequency):duration);
error_values = abs(perfect_signal - rec_signal);

figure;
subplot(1, 2, 1);
plot(sampling_time_domain, samples, 'bo-', rec_time_domain, rec_signal, 'r--');
title('Sygnał pierwotny i odtworzony nałożone na siebie');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
legend('Pierwotny Sygnał', 'Odtworzony Sygnał');
grid on;

subplot(1, 2, 2);
plot(rec_time_domain, error_values, 'r-');
title('Błędy rekonstrukcji w dziedzinie czasu');
xlabel('Czas [s]');
ylabel('Różnica w amplitudzie [V]');
grid on;
