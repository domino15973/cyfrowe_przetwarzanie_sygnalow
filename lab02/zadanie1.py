import numpy as np

np.set_printoptions(suppress=True, floatmode='fixed')

# elementarne macierze transformacji – macierze opisujące zależność pomiędzy współrzędnymi wskazanego punktu przed i po
# transformacji; przez transformację rozumiemy w tym przypadku translację, skalowanie oraz rotację

# dyskretna transformacja kosinusowa (ang. Discrete Cosine Transform, DCT) – rodzaj blokowej transformacji wykonywanej
# na wartościach dyskretnych; jest szczególnie popularna w dziedzinie stratnej kompresji danych


def generate_dct(N):
    w = np.zeros((N, N))
    for k in range(N):
        for n in range(N):
            if k == 0:
                w[k, n] = np.sqrt(1/N) * np.cos(np.pi * k / N * (n + 0.5))
            else:
                w[k, n] = np.sqrt(2/N) * np.cos(np.pi * k / N * (n + 0.5))
    return w


size = 20
A = generate_dct(size)


# ortonormalność – ortogonalność wraz z dodanym warunkiem unormowania


def check_orthonormality(matrix):
    num_of_rows = matrix.shape[0]
    for i in range(num_of_rows):
        for j in range(i+1, num_of_rows):
            dot_product = np.dot(matrix[i], matrix[j])      # iloczyn skalarny dwóch wierszy/wektorów
            if not np.isclose(dot_product, 0):           # oczekujemy wartości 0 dla i != j
                return False
    return True


print(A)

if check_orthonormality(A):
    print("Wszystkie wektory są do siebie ortonormalne.")
else:
    print("Wszystkie wektory nie są do siebie ortonormalne.")
