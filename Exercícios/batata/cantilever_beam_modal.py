import time
import subprocess
import os

# Propriedades da viga
E = 200e9
A = 0.0025
I = 5.21e-7
p = 7800

# Número total de elementos
n_el = int(input("Digite a quantidade de elementos: "))

if n_el < 1:
    raise AttributeError

print("\nStarting file assembly")
start_time = time.time()

# Criando arquvio de entrada
filename = f"balanco_modal_{n_el}.txt"
with open(filename, 'w') as f:
    f.write("#HEADER\n")
    f.write(f"Analise modal de viga em balanco com {n_el} elemento(s)\n")

    f.write("\n#MODAL\n")
    f.write("1\n")

    f.write("\n#NODES\n")
    for x in range(0, n_el+1):
        f.write(f"{x/n_el} 0\n")
    
    f.write("\n#ELEMENTS\n")
    for x in range(1, n_el+1):
        f.write(f"b {x} {x+1} {A} {E} {I} {p}\n")

    f.write("\n#CONSTRAINTS\n")
    f.write("@1\n")
    f.write("0 0 0\n\n")

middle_time = time.time()
print(f"Took {middle_time - start_time} seconds\n")
print("Starting matlab job")

# Rodando matlab
subprocess.run(["matlab", "-batch", f"mefController('{filename}')"])
print(f"\nTook {time.time() - middle_time} seconds")

# Deletando arquivo gerado
os.remove(filename)

input()