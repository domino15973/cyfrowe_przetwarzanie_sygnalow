clear all; close all; clc;

sin_frequency = 50;
sin_amplitude = 230;
sampling_frequencies = [10000, 500, 200];
duration = 0.1;

signals = {};
for i = 1:length(sampling_frequencies)
    time_domain = 0:1/sampling_frequencies(i):duration;
    sin_wave = sin_amplitude * sin(2 * pi * sin_frequency * time_domain);
    signals{i} = {time_domain, sin_wave};
end

figure;
hold on;
plot(signals{1}{1}, signals{1}{2}, 'b-', 'DisplayName', sprintf('Częstotliwość próbkowania: %d Hz', sampling_frequencies(1)));
plot(signals{2}{1}, signals{2}{2}, 'r-o', 'DisplayName', sprintf('Częstotliwość próbkowania: %d Hz', sampling_frequencies(2)));
plot(signals{3}{1}, signals{3}{2}, 'k-x', 'DisplayName', sprintf('Częstotliwość próbkowania: %d Hz', sampling_frequencies(3)));

title('Sygnał analogowy z różnymi częstotliwościami próbkowania');
xlabel('Czas [s]');
ylabel('Amplituda [V]');
legend('show');
grid on;
hold off;