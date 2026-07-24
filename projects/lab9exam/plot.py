import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import os
from matplotlib.colors import LogNorm

plots_dir = "projects/lab9exam/plots"
os.makedirs(plots_dir, exist_ok=True)

df = pd.read_csv("projects/lab9exam/data/acquisizione_dati.csv")

energies = df['energy']
psd = df['psd']

# --- Istogramma energia ---
title1 = "istogramma_energia.png"
plt.figure(figsize=(8,5))
plt.hist(energies, bins=380, color='steelblue', edgecolor='none')
plt.xlabel("Energy")
plt.ylabel("Counts")
plt.title("Energy spectrum")
plt.grid(alpha=0.3)
plt.tight_layout()
plt.savefig(os.path.join(plots_dir, title1), dpi=150)
plt.close()
print(f"Salvato plot {plots_dir}/{title1}")

# --- Istogramma energia ---
title1_log = "istogramma_energia_log.png"
plt.figure(figsize=(8,5))
plt.hist(energies, bins=380, color='steelblue', edgecolor='none')
plt.xlabel("Energy")
plt.ylabel("Counts")
plt.title("Energy spectrum - Log")
plt.yscale('log')
plt.grid(alpha=0.3)
plt.tight_layout()
plt.savefig(os.path.join(plots_dir, title1_log), dpi=150)
plt.close()
print(f"Salvato plot {plots_dir}/{title1_log}")

# --- Scatter plot: energia vs PSD ---
title2 = "psd_vs_energia.png"
plt.figure(figsize=(8,6))
h = plt.hist2d(energies, psd, bins=[300, 300], range=[[energies.min(), energies.max()], [6, 12.5]],
               cmap='viridis', norm=LogNorm())
plt.colorbar(h[3], label="Conteggi (log)")
plt.xlabel("Energy")
plt.ylabel("PSD")
plt.title("Discrimination PSD vs Energy")
plt.grid(alpha=0.3)
plt.ylim(6, 12.5)
plt.tight_layout()
plt.savefig(os.path.join(plots_dir, title2), dpi=150)
plt.close()
print(f"Salvato plot {plots_dir}/{title2}")