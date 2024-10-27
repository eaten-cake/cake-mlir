import numpy as np

from cake_mlir import ir

def create_mlir_dtype(dtype : np.dtype, context : ir.Context) -> ir.Type:
    """
    Create an MLIR type from a numpy dtype.
    """
    with context:
        if dtype == np.float32:
            return ir.F32Type.get()
        elif dtype == np.float64:
            return ir.F64Type.get()
        elif dtype == np.int32:
            return ir.IntegerType.get_signless(32)
        elif dtype == np.int64:
            return ir.IntegerType.get_signless(64)
        else:
            raise ValueError(f"Unsupported dtype: {dtype}")