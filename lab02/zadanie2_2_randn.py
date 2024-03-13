import numpy as np

np.set_printoptions(suppress=True, floatmode='fixed')

size = 20

# generowanie macierzy kwadratowej A_rand za pomocą funkcji randn() dla N=20
A_rand = np.random.randn(size, size)
print("A_rand: ", A_rand)

# sprawdzenie, czy norma wierszy = 1
row_norms = np.linalg.norm(A_rand, axis=1)
if np.allclose(row_norms, 1):
    print("Wiersze macierzy A_rand są ortonormalne.")
else:
    print("Wiersze macierzy A_rand nie są ortonormalne.")

input()

# wyznaczenie macierzy odwrotnej S_rand=inv(A_rand)
S_rand = np.linalg.inv(A_rand)
print("S_rand: ", S_rand)

# sprawdzenie, czy iloczyn AS_rand jest macierzą identycznościową
I = np.dot(A_rand, S_rand)
print("I: ", I)
if np.allclose(I, np.eye(size)):
    print("Iloczyn AS_rand jest macierzą identycznościową.")
else:
    print("Iloczyn AS_rand nie jest macierzą identycznościową.")

input()

x_rand = np.random.randn(size)      # generowanie losowego sygnału x_rand
print("x_rand: ", x_rand)

y_rand = np.dot(A_rand, x_rand)     # analiza sygnału x_rand
print("y_rand: ", y_rand)

x_rec = np.dot(S_rand, y_rand)      # rekonstrukcja sygnału x_rand
print("x_rec: ", x_rec)

if np.allclose(x_rec, x_rand):
    print("Transformacja posiada właściwość perfekcyjnej rekonstrukcji.")
else:
    print("Transformacja nie posiada właściwości perfekcyjnej rekonstrukcji.")
