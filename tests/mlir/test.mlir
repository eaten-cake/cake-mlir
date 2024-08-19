// RUN: cake-opt %s

func.func @main(%arg0: i32) {
  %0 = math.ctlz %arg0 : i32
  func.return
}