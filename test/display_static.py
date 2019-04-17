# 2D plotting library
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

# Scientific computing
import numpy as np

deltatimes = np.loadtxt('measurements.txt')

# Remove negative values and convert to ps
deltatimes = [deltatime * 1e12 if deltatime > 0 else 125 - deltatime * 1e12 for deltatime in deltatimes]

plt.style.use('seaborn-dark')

fig = plt.figure()

gs = gridspec.GridSpec(1, 2)

ax_scatter = fig.add_subplot(gs[0, 0])
ax_hist = fig.add_subplot(gs[0, 1])

ax_scatter.scatter(range(0, len(deltatimes)), deltatimes, marker='x')
ax_hist.hist(deltatimes, bins=200, density=True, orientation='horizontal')

ax_scatter.grid(True, 'both', 'y')
ax_scatter.set_ylabel('Skew [ps]')
ax_scatter.set_ylim(40.0, 140.0)
ax_scatter.set_yticks(np.arange(50.0, 150.0, 10.0))
ax_scatter.set_xticks([])

ax_hist.grid(True, 'both', 'y')
ax_hist.set_xlabel('Density')
ax_hist.set_ylim(40.0, 120.0)
ax_hist.set_yticks(np.arange(50.0, 150.0, 10.0))

plt.suptitle('Skews')
plt.show()

