import numpy as np

np.set_printoptions(suppress=True, floatmode='fixed')


def generate_bad_dct(N):
    w_bad = np.zeros((N, N))
    for k in range(N):
        for n in range(N):
            if k == 0:
                w_bad[k, n] = np.sqrt(1/N) * np.cos(np.pi * k / N * (n + 0.5))
            else:
                w_bad[k, n] = np.sqrt(2/N) * np.cos(np.pi * (k + 0.25) / N * (n + 0.5))
    return w_bad


size = 20
A_bad = generate_bad_dct(size)

# macierz ortogonalna to macierz nieosobliwa, mająca własność, że macierz do niej odwrotna jest równa transponowanej


def check_orthogonality(matrix):
    return np.allclose(np.dot(matrix, matrix.T), np.eye(matrix.shape[0]))


if check_orthogonality(A_bad):
    print("Macierz A_bad jest ortogonalna.")
else:
    print("Macierz A_bad nie jest ortogonalna.")

row_norms = np.linalg.norm(A_bad, axis=1)
if np.allclose(row_norms, 1):
    print("Wiersze macierzy A_bad są ortonormalne.")
else:
    print("Wiersze macierzy A_bad nie są ortonormalne.")

input()

# wyznaczenie macierzy odwrotnej S_bad=inv(A_bad)
S_bad = np.linalg.inv(A_bad)
print("S_bad: ", S_bad)

# sprawdzenie, czy iloczyn AS_bad jest macierzą identycznościową
I = np.dot(A_bad, S_bad)
print("I: ", I)
if np.allclose(I, np.eye(size)):
    print("Iloczyn AS_bad jest macierzą identycznościową.")
else:
    print("Iloczyn AS_bad nie jest macierzą identycznościową.")

input()

x_rand = np.random.randn(size)      # generowanie losowego sygnału x_rand
print("x_rand: ", x_rand)

y_rand = np.dot(A_bad, x_rand)     # analiza sygnału x_rand
print("y_rand: ", y_rand)

x_rec = np.dot(S_bad, y_rand)      # rekonstrukcja sygnału x_rand
print("x_rec: ", x_rec)

if np.allclose(x_rec, x_rand):
    print("Transformacja posiada właściwość perfekcyjnej rekonstrukcji.")
else:
    print("Transformacja nie posiada właściwości perfekcyjnej rekonstrukcji.")
