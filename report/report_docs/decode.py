import time
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import numpy as np
import csv

from scisdk.scisdk import SciSDK
from scisdk.scisdk_defines import *
from struct import *
from tqdm import tqdm

sdk = SciSDK()
res = sdk.AddNewDevice("usb:53673", "dt1260", "projects/lab9exam/library/RegisterFile.json", "board0")

if not res == 0:
    print("Program exit due connection error")
    exit()

sdk.SetRegister("board0:/Registers/THRESHOLD", 45) # 25
sdk.SetRegister("board0:/Registers/M_LENGTH", 8) # 8 
sdk.SetRegister("board0:/Registers/BL_HOLD", 700) # 700
sdk.SetRegister("board0:/Registers/INT_Q", 300) # 300 
sdk.SetRegister("board0:/Registers/GAIN", 500) # 500
sdk.SetRegister("board0:/Registers/INT_SAMPLES", 20) # 40
sdk.SetRegister("board0:/Registers/PRE_TRIGGER", 15)
sdk.SetRegister("board0:/Registers/DELAY", 20) # 5

res = sdk.SetParameterString("board0:/MMCComponents/List_0.thread", "false")
res = sdk.SetParameterInteger("board0:/MMCComponents/List_0.timeout", 500)
res = sdk.SetParameterString("board0:/MMCComponents/List_0.acq_mode", "blocking")

# allocate buffer raw, size 1024
res, buf = sdk.AllocateBuffer("board0:/MMCComponents/List_0", 1024)
res = sdk.ExecuteCommand("board0:/MMCComponents/List_0.stop", "")
res = sdk.ExecuteCommand("board0:/MMCComponents/List_0.start", "")

E_THRESHOLD = 5   # soglia sotto cui l'evento e' considerato rumore

energies = []      # Qenergy -> asse X
psd = []           # peak/Qshort -> asse Y

for i in tqdm(range(2000)):
    res, buf = sdk.ReadData("board0:/MMCComponents/List_0", buf)

    if res == 0:
        for j in range(0, int(buf.info.valid_samples / 8)):
            data = unpack('<hhhh', buf.data[j*8:(j+1)*8])
            Qshort  = data[0]
            Qenergy = data[1]
            peak    = data[2]

            if Qshort <= 0 or Qenergy <= 0 or peak <= E_THRESHOLD:
                continue

            energies.append(Qenergy)
            psd.append(peak / Qshort)

res = sdk.ExecuteCommand("board0:/MMCComponents/List_0.stop", "")

energies = np.array(energies)
psd = np.array(psd)

# --- Salvataggio in CSV ---
output_file = "acquisizione_dati.csv"
with open(output_file, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["energy", "psd"])
    for e, p in zip(energies, psd):
        writer.writerow([e, p])
