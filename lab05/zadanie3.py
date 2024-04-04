import numpy as np
from scipy.signal import butter, cheby1, cheby2, ellip, freqs, zpk2tf
import matplotlib.pyplot as plt

sampling_freq = 256e3  # częstotliwość próbkowania przetwornika A/C
cutoff = sampling_freq / 2  # maksymalne tłumienie
points = 4096
w = np.linspace(0, sampling_freq, points) * 2 * np.pi

# wymagania filtrów
freq_64 = 64e3
freq_112 = 112e3
freq_128 = 128e3

# z-zera; p-bieguny; k-stała wzmocnienia
# N-poziom filtra; rp-zmiany tłumienia dla częstotliwości nietłumionych; rs-tłumienie w paśmie tłumienia

# projekt filtra Butterwortha
z_butter, p_butter, k_butter = butter(N=7, Wn=2 * np.pi * freq_64, analog=True, output='zpk')
# konwersja na współczynniki licznika i mianownika transmitancji
b_butter, a_butter = zpk2tf(z_butter, p_butter, k_butter)
# odpowiedź częstotliwościowa
frequency_response_butter = freqs(b_butter, a_butter, w)

# projekt filtra Czebyszewa 1
z_cheby1, p_cheby1, k_cheby1 = cheby1(N=5, rp=3, Wn=2 * np.pi * freq_64, analog=True, output='zpk')
# konwersja na współczynniki licznika i mianownika transmitancji
b_cheby1, a_cheby1 = zpk2tf(z_cheby1, p_cheby1, k_cheby1)
# odpowiedź częstotliwościowa
frequency_response_cheby1 = freqs(b_cheby1, a_cheby1, w)

# projekt filtra Czebyszewa 2
z_cheby2, p_cheby2, k_cheby2 = cheby2(N=5, rs=40, Wn=2 * np.pi * freq_112, analog=True, output='zpk')
# konwersja na współczynniki licznika i mianownika transmitancji
b_cheby2, a_cheby2 = zpk2tf(z_cheby2, p_cheby2, k_cheby2)
# odpowiedź częstotliwościowa
frequency_response_cheby2 = freqs(b_cheby2, a_cheby2, w)

# projekt filtra eliptycznego
z_ellip, p_ellip, k_ellip = ellip(N=3, rp=3, rs=40, Wn=2 * np.pi * freq_64, analog=True, output='zpk')
# konwersja na współczynniki licznika i mianownika transmitancji
b_ellip, a_ellip = zpk2tf(z_ellip, p_ellip, k_ellip)
# odpowiedź częstotliwościowa
frequency_response_ellip = freqs(b_ellip, a_ellip, w)

# wykresy odpowiedzi częstotliwościowych
plt.figure()
for response, label in zip(
        [frequency_response_butter, frequency_response_cheby1, frequency_response_cheby2, frequency_response_ellip],
        ["Butterworth", "Czebyszew 1", "Czebyszew 2", "Eliptyczny"]):
    plt.plot(w / (2 * np.pi * 1e3), 20 * np.log10(np.abs(response[1]) + 1e-12), label=label)
plt.axis()
plt.grid(True)
plt.title("Odpowiedź częstotliwościowa modelów")
plt.xlabel("Częstotliwość (kHz)")
plt.ylabel("Odpowiedź (dB)")
plt.legend()

# wykresy pozycji biegunów
plt.figure(figsize=(6, 6))
for poles, label in zip([p_butter, p_cheby1, p_cheby2, p_ellip], ["Butterworth", "Czebyszew 1", "Czebyszew 2", "Eliptyczny"]):
    plt.plot(np.real(poles), np.imag(poles), 'o', label=label)
plt.title("Rozkład biegunów filtrów")
plt.xlabel("Re")
plt.ylabel("Im")
plt.legend()
plt.grid(True)
plt.axis('equal')

plt.show()
