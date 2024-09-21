from cake_mlir.extras import fx_importer
from cake_mlir.ir import Module

import torch

def from_torch(
        prog : torch.export.ExportedProgram
) -> Module:
    pass