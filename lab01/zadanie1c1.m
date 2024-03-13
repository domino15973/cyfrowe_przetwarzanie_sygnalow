clear all; close all; clc;

amplitude = 230;
bckg_frequency = 10000;
sampling_frequency = 100;
duration = 1;

bckg_time_domain = 0:1/bckg_frequency:duration;
time_domain = 0:1/sampling_frequency:duration;

figure;

for sin_frequency = 0:5:300
    bckg_signal = amplitude * sin(2 * pi * sin_frequency * bckg_time_domain);
    sample_values = amplitude * sin(2 * pi * sin_frequency * time_domain);

    clf;

    plot(bckg_time_domain, bckg_signal, '-', 'Color', [0.73, 0.73, 0.73], 'LineWidth', 1, 'DisplayName', 'Poglądowy wykres');
    hold on;
    plot(time_domain, sample_values, 'r-', 'DisplayName', 'Sygnał spróbkowany');
    scatter(time_domain, sample_values, 50, 'red', 'filled');

    title(sprintf('PRZEBIEG %d: Sygnał o częstotliwości %d Hz, próbkowany z częstotliwością %d Hz', sin_frequency/5 + 1, sin_frequency, sampling_frequency));
    xlabel('Czas [s]');
    ylabel('Amplituda [V]');
    legend('show');
    grid on;

    drawnow;
    pause;
end

hold off;
 