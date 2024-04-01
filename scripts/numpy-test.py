import time
import numpy as np
np.random.seed(0)
a = np.random.uniform(size=(300, 300))
start = time.time()
for _ in range(100):
    a += 1
    np.linalg.svd(a)
t = time.time() - start
print(f'{t:.2f}s')