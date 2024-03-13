clear all; close all; clc;

% Wczytanie danych
data = load('adsl_x.mat');
signal = data.x;

prefix_length = 32;
frame_length = 512;
package_length = prefix_length + frame_length;

max_correlation = 0;
start_prefix_positions = zeros(3, 1); % wiemy, że są 3 prefiksy

for i = 1:floor(length(signal) / 3)
    if (i + 3 * package_length) > length(signal)
        break;
    end
    
    max_corr_group = 0;
    tmp_start_prefix_positions = zeros(3, 1);
    
    % Dla każdego prefiksu obliczamy jego korelację z kopią kolejnego bloku danych 
    % Sumujemy te korelacje dla każdego prefiksu

    for j = 1:3
        prefix = signal(i + (j - 1) * package_length : i + (j - 1) * package_length + prefix_length);
        tmp_start_prefix_positions(j, 1) = i + (j - 1) * package_length;
        
        % Zmienna do przechowywania kolejnego bloku danych
        copy_probe_block = signal(i + (j - 1) * package_length + frame_length : ...
                                  i + (j - 1) * package_length + frame_length + prefix_length);
        
        % Obliczenie korelacji
        corr = xcorr(prefix, copy_probe_block);
        % corr = corr_fun(prefix, copy_probe_block);

        max_corr_group = max_corr_group + mean(corr);
    end
    
    if max_corr_group > max_correlation
        max_correlation = max_corr_group;
        start_prefix_positions = tmp_start_prefix_positions;
    end
end

figure;
plot(signal, 'b-');
hold on;
for i = 1:3
    plot(start_prefix_positions(i, 1), 0, 'r*')
end
hold off;
title('Znalezienie początku prefiksu');
xlabel('Indeks próbki');
ylabel('Amplituda');
legend('Sygnał', 'Początek prefiksu');
grid on;
