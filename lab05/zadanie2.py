import numpy as np
from scipy.signal import freqs, impulse, TransferFunction, step
import matplotlib.pyplot as plt

N_values = [2, 4, 6, 8]
omega_3dB = 2 * np.pi * 100

# wektor częstotliwościowy
w = np.linspace(0, 2000, num=20001) * 2 * np.pi  # częstotliwość kątowa in rad/s

ang = np.zeros((4, len(w)))
Hdec = np.zeros((4, len(w)))
Hlin = np.zeros((4, len(w)))

for i, N in enumerate(N_values):
    # położenie biegunów na płaszczyźnie zespolonej
    angles = np.pi / 2 + (1 / 2) * np.pi / N + (np.arange(1, N + 1) - 1) * np.pi / N
    poles = omega_3dB * np.exp(1j * angles)
    # współczynnik wzmocnienia filtru
    wzm = np.prod(-poles)
    # współczynniki wielomianów dla transmitancji
    a = np.poly(poles)
    b = [wzm]
    # odpowiedź częstotliwościowa filtru
    # w-wektor częstości kątowych
    # h-wektor wartości transmitancji
    w, h = freqs(b, a, worN=w)

    # faza
    ang[i, :] = np.angle(h)
    # odpowiedź impulsowa decybelowa
    Hdec[i, :] = 20 * np.log10(np.abs(h))
    # odpowiedź impulsowa liniowa
    Hlin[i, :] = np.abs(h)


plt.figure()
for row in range(4):
    plt.semilogx(w / (2 * np.pi), Hdec[row, :], label=f"{N_values[row]}")
plt.grid(True)
plt.legend()
plt.title("Charakterystyka A-cz skala logarytmiczna")


plt.figure()
for row in range(4):
    plt.plot(w / (2 * np.pi), Hlin[row, :], label=f"{N_values[row]}")
plt.legend()
plt.title("Charakterystyka A-cz skala liniowa")


plt.figure()
for row in range(4):
    plt.plot(w / (2 * np.pi), ang[row, :], label=f"{N_values[row]}")
plt.legend()
plt.title("Charakterystyka cz-f")

# odpowiedź impulsowa i skokowa dla N = 4
N = 4
omega_3dB = 2 * np.pi * 100  # przykładowa częstotliwość odcięcia
# położenie biegunów dla N = 4
poles4 = omega_3dB * np.exp(1j * (np.pi / 2 + 1 / 2 * np.pi / N + (np.arange(1, N + 1) - 1) * np.pi / N))

# wielomian ze współczynnikami
a = np.poly(poles4)
b = [np.prod(-poles4)]
# wyznaczenie transmitancji
H = TransferFunction(b, a)

# odpowiedź impulsowa; oś wyskalowana w czasie
tOut, y = impulse(H)
plt.figure()
plt.plot(tOut, y)
plt.title("Odpowiedź impulsowa")

# odpowiedź na skok jednostkowy; oś wyskalowana w czasie
tOut, y = step(H)
plt.figure()
plt.plot(tOut, y)
plt.title("Odpowiedź na skok jednostkowy")

plt.show()
