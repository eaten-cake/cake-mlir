import ctypes

lib = ctypes.CDLL("./add.so")

add = lib["add"]

add.restype = ctypes.c_int32
add.argtypes = [ctypes.c_int32, ctypes.c_int32]

print(add(5, 3))