from cake_mlir import runtime

import numpy as np

x = np.random.uniform(0, 1, size=(1, 10)).astype(np.float32)

memref_x = runtime.get_ranked_memref_descriptor(x)



