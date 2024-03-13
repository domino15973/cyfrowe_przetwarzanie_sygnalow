import numpy as np

from zadanie1 import generate_dct

np.set_printoptions(suppress=True, floatmode='fixed')

size = 20
A = generate_dct(size)
print("A: ", A)

# macierz odwrotna to taka macierz, która gdy jest pomnożona przez macierz pierwotną, daje macierz jednostkową
# (czyli macierz diagonalną, gdzie na głównej przekątnej znajdują się jedynki, a pozostałe elementy są zerami).

# generowanie macierzy odwrotnej IDCT, poprzez transpozycję macierzy A
S = A.T
print("S: ", S)

# macierz identycznościowa, czasem zwana macierzą jednostkową, to kwadratowa macierz, która ma jedynki na głównej
# przekątnej, a wszystkie pozostałe elementy są zerami.

# sprawdzenie, czy iloczyn S * A == I (macierz identyczności)
I = np.dot(S, A)
print("I: ", I)
if np.allclose(I, np.eye(size)):        # allclose, aby uniknąć potencjalnych błędów na operacjach zmiennoprzecinkowych
    print("Iloczyn S * A jest macierzą identycznościową.")
else:
    print("Iloczyn S * A nie jest macierzą identycznościową.")

input()

x = np.random.randn(size)   # generowanie losowego sygnału x
print("x: ", x)

y = np.dot(A, x)            # analiza sygnału x
print("y: ", y)

x_rec = np.dot(S, y)        # rekonstrukcja sygnału
print("x_rec: ", x_rec)

if np.allclose(x_rec, x):
    print("Transformacja posiada właściwość perfekcyjnej rekonstrukcji.")
else:
    print("Transformacja nie posiada właściwości perfekcyjnej rekonstrukcji.")
