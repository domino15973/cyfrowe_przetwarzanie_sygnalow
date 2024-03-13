clear all; close all; clc;

sin_frequencies = [5, 105, 205];
% sin_frequencies = [95, 195, 295];
% sin_frequencies = [95, 105];

sin_amplitude = 230;
sampling_frequency = 100;
duration = 1;

time_domain = 0:1/sampling_frequency:duration;

signals = {};
for i = 1:length(sin_frequencies)
    sin_wave = sin_amplitude * sin(2 * pi * sin_frequencies(i) * time_domain);
    signals{i} = {time_domain, sin_wave};
end

figure;
hold on;
plot(signals{1}{1}, signals{1}{2}, 'b-o', 'DisplayName', sprintf('Częstotliwość sinusa: %d Hz', sin_frequencies(1)));
plot(signals{2}{1}, signals{2}{2}, 'r-x', 'DisplayName', sprintf('Częstotliwość sinusa: %d Hz', sin_frequencies(2)));
plot(signals{3}{1}, signals{3}{2}, 'g--', 'DisplayName', sprintf('Częstotliwość sinusa: %d Hz', sin_frequencies(3)));

title(sprintf('Sinusy o częstotliwościach %s próbkowane z częstotliwością %d Hz', mat2str(sin_frequencies), sampling_frequency));
xlabel('Czas [s]');
ylabel('Amplituda [V]');
legend('show');
grid on;
hold off;
