import numpy as np
from scipy.signal import ellip, zpk2tf, freqs
import matplotlib.pyplot as plt

points = 4096
N = 4  # maksymalny rząd filtra
mid_freq_unscaled = 96
mid_freq = 2 * np.pi * 1e6 * mid_freq_unscaled  # przeliczenie na radiany/s
tollerance_unscaled = 100
tollerance = 2 * np.pi * 1e3 * tollerance_unscaled  # przeliczenie na radiany/s

# zakres częstotliwości
w = np.linspace(mid_freq - 2 * tollerance, mid_freq + 2 * tollerance, points)

# projektowanie filtra
ze, pe, ke = ellip(N, 3, 40, [mid_freq - tollerance, mid_freq + tollerance], btype='bandpass', analog=True, output='zpk')

# konwersja zpk na transfer function (tf)
be, ae = zpk2tf(ze, pe, ke)

# obliczenie odpowiedzi częstotliwościowej
he = freqs(be, ae, w)

# "he" to wynik funkcji freqs,
# "w" to wektor częstotliwości używany w tej funkcji

# he[1] oznacza, że bierzemy drugi element zwrócony przez freqs, który jest odpowiedzią częstotliwościową
plt.plot(w / (2 * np.pi * 1e6), 20 * np.log10(np.abs(he[1])))
plt.axis([mid_freq_unscaled - 2 * tollerance_unscaled / 1e3, mid_freq_unscaled + 2 * tollerance_unscaled / 1e3, -45, 5])
plt.grid(True)
plt.title("Odpowiedź częstotliwościowa")
plt.xlabel("Częstotliwość (MHz)")
plt.ylabel("Odpowiedź (dB)")
plt.show()
