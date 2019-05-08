# Scientific computing
import numpy as np

# Plotting
import matplotlib.pyplot as plt

xor = np.loadtxt('data/xor.txt')

deltatime = xor[:, 0] * 10 ** 12
voltage = xor[:, 1]

fig, ax = plt.subplots()

fig.suptitle('XOR as phase detector')

ax.scatter(deltatime, voltage)

ax.set_xlabel('Time [ps]')
ax.set_ylabel('XOR DC Voltage [V]')

ax.grid(True, 'both', 'both')

plt.show()
