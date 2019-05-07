# Scientific computing
import numpy as np

# Plotting
import matplotlib.pyplot as plt

signal_period = 125e-12

signal_begin = [0, 1, 1, 1, 1]
signal_end = [1, 0, 0, 0, 0]

signal = np.stack((signal_begin, signal_end))

sample_period = 1e-12

signal_sampled = np.repeat(signal, int(signal_period / sample_period), 0)

# Introduce random skews between 0 and 10 ps
for i in np.arange(0, signal_sampled.shape[1]):
    signal_sampled[:, i] = np.roll(signal_sampled[:, i], np.random.randint(0, 10))

# Calculate plotting variables
binary_weights = 2 ** np.arange(signal_sampled.shape[1] - 1, -1, -1)
signal_sampled_decimal = signal_sampled.dot(binary_weights)
t = np.arange(0, 2 * signal_period - sample_period, sample_period) * 1E12

print(t)
print(signal_sampled_decimal)

fig, ax = plt.subplots()

fig.suptitle('Major carry transition with parasitic effects')

ax.plot(t, signal_sampled_decimal)

ax.set_xlim(100, 150)
ax.set_ylim(0, 32)

ax.set_xticks(np.arange(100, 150 + 5, 5))
ax.set_yticks(np.arange(0, 32 + 2, 2))

ax.set_xlabel('Time [ps]')
ax.set_ylabel('Decimal value')

ax.grid(True, 'both', 'both')

plt.show()
