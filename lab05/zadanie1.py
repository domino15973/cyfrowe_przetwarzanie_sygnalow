import numpy as np
import matplotlib.pyplot as plt

# bieguny i zera transmitancji
p12 = -0.5 + 9.5j
p34 = -1 + 10j
p56 = -0.5 + 10.5j
z12 = 5j
z34 = 15j

# duplikowanie biegunów i zer z przeciwnym znakiem przy części zespolonej
p = [p12, p34, p56, np.conj(p12), np.conj(p34), np.conj(p56)]
z = [z12, z34, np.conj(z12), np.conj(z34)]

# współczynnik wzmocnienia (z wykładu)
wzm = 0.42

plt.figure(figsize=(8, 6))
plt.plot(np.real(p), np.imag(p), "*", label="Bieguny")
plt.plot(np.real(z), np.imag(z), "o", label="Zera")
plt.grid(True)
plt.axis('equal')
plt.xlabel("Re(z)")
plt.ylabel("Im(z)")
plt.title("Bieguny i zera transmitancji")
plt.legend()

# wielomian biegunów
a = np.poly(p)
# wielomian zer
b = np.poly(z) * wzm

# odpowiedź częstotliwościowa
# zakres częstotliwości
w = np.arange(4, 16.1, 0.1)
# zamiana transformaty La Place'a na transformatę Fouriera
s = w * 1j

Hlinear = np.abs(np.polyval(b, s) / np.polyval(a, s))
plt.figure()
plt.plot(w, Hlinear)
plt.xlabel("Częstotliwość [rad/s]")
plt.ylabel("Charakterystyka częstotliwościowa |H(jw)|")
plt.title("Liniowa odpowiedź częstotliwościowa")

Hlog = 20 * np.log10(Hlinear)
plt.figure()
plt.semilogx(w, Hlog, 'r')
plt.xlabel("Częstotliwość [rad/s]")
plt.ylabel("Charakterystyka częstotliwościowa (|H(jw)|) dB")
plt.title("Decybelowa odpowiedź częstotliwościowa")

H_phase = np.angle(np.polyval(b, s) / np.polyval(a, s))
plt.figure()
plt.plot(w, H_phase, 'g')
plt.xlabel('Częstotliwość [rad/s]')
plt.ylabel('Kąt [rad]')
plt.title('Charakterystyka fazowo-częstotliwościowa')
plt.grid(True)

plt.show()

# Czy filtr ten jest pasmowo-przepustowy?
# Na podstawie charakterystyki częstotliwościowej, filtr ten działa jako filtr pasmowo-przepustowy, ponieważ posiada
# pasmo, w którym amplituda jest wysoka (pasmo przepustowe), oraz pasmo, w którym amplituda jest niska (pasmo zaporowe).

# Jakie jest maksymalne i minimalne tłumienie w paśmie zaporowym?
# max = -342 dB
# min = -10 dB

# W pasmie przepustowym charakterystyka fazowa powinna być liniowa. To oznacza, że faza sygnału wyjściowego nie
# powinna ulegać znaczącym zmianom wewnątrz tego zakresu częstotliwości.
