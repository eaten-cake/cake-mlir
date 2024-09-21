module {
  llvm.func @free(!llvm.ptr)
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.mlir.global private constant @__constant_10xf32(dense_resource<torch_tensor_10_torch.float32> : tensor<10xf32>) {addr_space = 0 : i32, alignment = 64 : i64} : !llvm.array<10 x f32>
  llvm.mlir.global private constant @__constant_10x10xf32(dense_resource<torch_tensor_10_10_torch.float32> : tensor<10x10xf32>) {addr_space = 0 : i32, alignment = 64 : i64} : !llvm.array<10 x array<10 x f32>>
  func.func @main(%arg0: tensor<1x10xf32>) -> tensor<1x10xf32> {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.mlir.constant(10 : index) : i64
    %2 = llvm.mlir.constant(0 : index) : i64
    %3 = builtin.unrealized_conversion_cast %2 : i64 to index
    %4 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %5 = bufferization.to_memref %arg0 : memref<1x10xf32, strided<[?, ?], offset: ?>>
    %6 = builtin.unrealized_conversion_cast %5 : memref<1x10xf32, strided<[?, ?], offset: ?>> to !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %7 = llvm.mlir.constant(10 : index) : i64
    %8 = llvm.mlir.constant(10 : index) : i64
    %9 = llvm.mlir.constant(1 : index) : i64
    %10 = llvm.mlir.constant(100 : index) : i64
    %11 = llvm.mlir.zero : !llvm.ptr
    %12 = llvm.getelementptr %11[%10] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %13 = llvm.ptrtoint %12 : !llvm.ptr to i64
    %14 = llvm.mlir.addressof @__constant_10x10xf32 : !llvm.ptr
    %15 = llvm.getelementptr %14[0, 0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<10 x array<10 x f32>>
    %16 = llvm.mlir.constant(3735928559 : index) : i64
    %17 = llvm.inttoptr %16 : i64 to !llvm.ptr
    %18 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %19 = llvm.insertvalue %17, %18[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %20 = llvm.insertvalue %15, %19[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %21 = llvm.mlir.constant(0 : index) : i64
    %22 = llvm.insertvalue %21, %20[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %23 = llvm.insertvalue %7, %22[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %24 = llvm.insertvalue %8, %23[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %25 = llvm.insertvalue %8, %24[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %26 = llvm.insertvalue %9, %25[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %27 = llvm.mlir.constant(10 : index) : i64
    %28 = llvm.mlir.constant(1 : index) : i64
    %29 = llvm.mlir.zero : !llvm.ptr
    %30 = llvm.getelementptr %29[%27] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %31 = llvm.ptrtoint %30 : !llvm.ptr to i64
    %32 = llvm.mlir.addressof @__constant_10xf32 : !llvm.ptr
    %33 = llvm.getelementptr %32[0, 0] : (!llvm.ptr) -> !llvm.ptr, !llvm.array<10 x f32>
    %34 = llvm.mlir.constant(3735928559 : index) : i64
    %35 = llvm.inttoptr %34 : i64 to !llvm.ptr
    %36 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %37 = llvm.insertvalue %35, %36[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %38 = llvm.insertvalue %33, %37[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %39 = llvm.mlir.constant(0 : index) : i64
    %40 = llvm.insertvalue %39, %38[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %41 = llvm.insertvalue %27, %40[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %42 = llvm.insertvalue %28, %41[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %43 = llvm.mlir.constant(10 : index) : i64
    %44 = llvm.mlir.constant(10 : index) : i64
    %45 = llvm.mlir.constant(1 : index) : i64
    %46 = llvm.mlir.constant(100 : index) : i64
    %47 = llvm.mlir.zero : !llvm.ptr
    %48 = llvm.getelementptr %47[%46] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %49 = llvm.ptrtoint %48 : !llvm.ptr to i64
    %50 = llvm.mlir.constant(64 : index) : i64
    %51 = llvm.add %49, %50 : i64
    %52 = llvm.call @malloc(%51) : (i64) -> !llvm.ptr
    %53 = llvm.ptrtoint %52 : !llvm.ptr to i64
    %54 = llvm.mlir.constant(1 : index) : i64
    %55 = llvm.sub %50, %54 : i64
    %56 = llvm.add %53, %55 : i64
    %57 = llvm.urem %56, %50  : i64
    %58 = llvm.sub %56, %57 : i64
    %59 = llvm.inttoptr %58 : i64 to !llvm.ptr
    %60 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %61 = llvm.insertvalue %52, %60[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %62 = llvm.insertvalue %59, %61[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %63 = llvm.mlir.constant(0 : index) : i64
    %64 = llvm.insertvalue %63, %62[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %65 = llvm.insertvalue %43, %64[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %66 = llvm.insertvalue %44, %65[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %67 = llvm.insertvalue %44, %66[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %68 = llvm.insertvalue %45, %67[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    cf.br ^bb1(%3 : index)
  ^bb1(%69: index):  // 2 preds: ^bb0, ^bb5
    %70 = builtin.unrealized_conversion_cast %69 : index to i64
    %71 = builtin.unrealized_conversion_cast %69 : index to i64
    %72 = llvm.icmp "slt" %71, %1 : i64
    llvm.cond_br %72, ^bb2, ^bb6
  ^bb2:  // pred: ^bb1
    cf.br ^bb3(%3 : index)
  ^bb3(%73: index):  // 2 preds: ^bb2, ^bb4
    %74 = builtin.unrealized_conversion_cast %73 : index to i64
    %75 = builtin.unrealized_conversion_cast %73 : index to i64
    %76 = llvm.icmp "slt" %75, %1 : i64
    llvm.cond_br %76, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %77 = llvm.extractvalue %26[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %78 = llvm.mlir.constant(10 : index) : i64
    %79 = llvm.mul %74, %78 : i64
    %80 = llvm.add %79, %70 : i64
    %81 = llvm.getelementptr %77[%80] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %82 = llvm.load %81 : !llvm.ptr -> f32
    %83 = llvm.extractvalue %68[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %84 = llvm.mlir.constant(10 : index) : i64
    %85 = llvm.mul %70, %84 : i64
    %86 = llvm.add %85, %74 : i64
    %87 = llvm.getelementptr %83[%86] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %82, %87 : f32, !llvm.ptr
    %88 = llvm.add %75, %0 : i64
    %89 = builtin.unrealized_conversion_cast %88 : i64 to index
    cf.br ^bb3(%89 : index)
  ^bb5:  // pred: ^bb3
    %90 = llvm.add %71, %0 : i64
    %91 = builtin.unrealized_conversion_cast %90 : i64 to index
    cf.br ^bb1(%91 : index)
  ^bb6:  // pred: ^bb1
    %92 = llvm.mlir.constant(1 : index) : i64
    %93 = llvm.mlir.constant(10 : index) : i64
    %94 = llvm.mlir.constant(1 : index) : i64
    %95 = llvm.mlir.constant(10 : index) : i64
    %96 = llvm.mlir.zero : !llvm.ptr
    %97 = llvm.getelementptr %96[%95] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %98 = llvm.ptrtoint %97 : !llvm.ptr to i64
    %99 = llvm.mlir.constant(64 : index) : i64
    %100 = llvm.add %98, %99 : i64
    %101 = llvm.call @malloc(%100) : (i64) -> !llvm.ptr
    %102 = llvm.ptrtoint %101 : !llvm.ptr to i64
    %103 = llvm.mlir.constant(1 : index) : i64
    %104 = llvm.sub %99, %103 : i64
    %105 = llvm.add %102, %104 : i64
    %106 = llvm.urem %105, %99  : i64
    %107 = llvm.sub %105, %106 : i64
    %108 = llvm.inttoptr %107 : i64 to !llvm.ptr
    %109 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %110 = llvm.insertvalue %101, %109[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %111 = llvm.insertvalue %108, %110[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %112 = llvm.mlir.constant(0 : index) : i64
    %113 = llvm.insertvalue %112, %111[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %114 = llvm.insertvalue %92, %113[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %115 = llvm.insertvalue %93, %114[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %116 = llvm.insertvalue %93, %115[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %117 = llvm.insertvalue %94, %116[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    cf.br ^bb7(%3 : index)
  ^bb7(%118: index):  // 2 preds: ^bb6, ^bb11
    %119 = builtin.unrealized_conversion_cast %118 : index to i64
    %120 = builtin.unrealized_conversion_cast %118 : index to i64
    %121 = llvm.icmp "slt" %120, %0 : i64
    llvm.cond_br %121, ^bb8, ^bb12
  ^bb8:  // pred: ^bb7
    cf.br ^bb9(%3 : index)
  ^bb9(%122: index):  // 2 preds: ^bb8, ^bb10
    %123 = builtin.unrealized_conversion_cast %122 : index to i64
    %124 = builtin.unrealized_conversion_cast %122 : index to i64
    %125 = llvm.icmp "slt" %124, %1 : i64
    llvm.cond_br %125, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %126 = llvm.extractvalue %117[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %127 = llvm.mlir.constant(10 : index) : i64
    %128 = llvm.mul %119, %127 : i64
    %129 = llvm.add %128, %123 : i64
    %130 = llvm.getelementptr %126[%129] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %4, %130 : f32, !llvm.ptr
    %131 = llvm.add %124, %0 : i64
    %132 = builtin.unrealized_conversion_cast %131 : i64 to index
    cf.br ^bb9(%132 : index)
  ^bb11:  // pred: ^bb9
    %133 = llvm.add %120, %0 : i64
    %134 = builtin.unrealized_conversion_cast %133 : i64 to index
    cf.br ^bb7(%134 : index)
  ^bb12:  // pred: ^bb7
    cf.br ^bb13(%3 : index)
  ^bb13(%135: index):  // 2 preds: ^bb12, ^bb20
    %136 = builtin.unrealized_conversion_cast %135 : index to i64
    %137 = builtin.unrealized_conversion_cast %135 : index to i64
    %138 = llvm.icmp "slt" %137, %0 : i64
    llvm.cond_br %138, ^bb14, ^bb21
  ^bb14:  // pred: ^bb13
    cf.br ^bb15(%3 : index)
  ^bb15(%139: index):  // 2 preds: ^bb14, ^bb19
    %140 = builtin.unrealized_conversion_cast %139 : index to i64
    %141 = builtin.unrealized_conversion_cast %139 : index to i64
    %142 = llvm.icmp "slt" %141, %1 : i64
    llvm.cond_br %142, ^bb16, ^bb20
  ^bb16:  // pred: ^bb15
    cf.br ^bb17(%3 : index)
  ^bb17(%143: index):  // 2 preds: ^bb16, ^bb18
    %144 = builtin.unrealized_conversion_cast %143 : index to i64
    %145 = builtin.unrealized_conversion_cast %143 : index to i64
    %146 = llvm.icmp "slt" %145, %1 : i64
    llvm.cond_br %146, ^bb18, ^bb19
  ^bb18:  // pred: ^bb17
    %147 = llvm.extractvalue %6[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %148 = llvm.extractvalue %6[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %149 = llvm.getelementptr %147[%148] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %150 = llvm.extractvalue %6[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %151 = llvm.mul %136, %150 : i64
    %152 = llvm.extractvalue %6[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %153 = llvm.mul %144, %152 : i64
    %154 = llvm.add %151, %153 : i64
    %155 = llvm.getelementptr %149[%154] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %156 = llvm.load %155 : !llvm.ptr -> f32
    %157 = llvm.extractvalue %68[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %158 = llvm.mlir.constant(10 : index) : i64
    %159 = llvm.mul %144, %158 : i64
    %160 = llvm.add %159, %140 : i64
    %161 = llvm.getelementptr %157[%160] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %162 = llvm.load %161 : !llvm.ptr -> f32
    %163 = llvm.extractvalue %117[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %164 = llvm.mlir.constant(10 : index) : i64
    %165 = llvm.mul %136, %164 : i64
    %166 = llvm.add %165, %140 : i64
    %167 = llvm.getelementptr %163[%166] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %168 = llvm.load %167 : !llvm.ptr -> f32
    %169 = llvm.fmul %156, %162  : f32
    %170 = llvm.fadd %168, %169  : f32
    %171 = llvm.extractvalue %117[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %172 = llvm.mlir.constant(10 : index) : i64
    %173 = llvm.mul %136, %172 : i64
    %174 = llvm.add %173, %140 : i64
    %175 = llvm.getelementptr %171[%174] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %170, %175 : f32, !llvm.ptr
    %176 = llvm.add %145, %0 : i64
    %177 = builtin.unrealized_conversion_cast %176 : i64 to index
    cf.br ^bb17(%177 : index)
  ^bb19:  // pred: ^bb17
    %178 = llvm.add %141, %0 : i64
    %179 = builtin.unrealized_conversion_cast %178 : i64 to index
    cf.br ^bb15(%179 : index)
  ^bb20:  // pred: ^bb15
    %180 = llvm.add %137, %0 : i64
    %181 = builtin.unrealized_conversion_cast %180 : i64 to index
    cf.br ^bb13(%181 : index)
  ^bb21:  // pred: ^bb13
    %182 = llvm.mlir.constant(1 : index) : i64
    %183 = llvm.mlir.constant(10 : index) : i64
    %184 = llvm.mlir.constant(1 : index) : i64
    %185 = llvm.mlir.constant(10 : index) : i64
    %186 = llvm.mlir.zero : !llvm.ptr
    %187 = llvm.getelementptr %186[%185] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %188 = llvm.ptrtoint %187 : !llvm.ptr to i64
    %189 = llvm.mlir.constant(64 : index) : i64
    %190 = llvm.add %188, %189 : i64
    %191 = llvm.call @malloc(%190) : (i64) -> !llvm.ptr
    %192 = llvm.ptrtoint %191 : !llvm.ptr to i64
    %193 = llvm.mlir.constant(1 : index) : i64
    %194 = llvm.sub %189, %193 : i64
    %195 = llvm.add %192, %194 : i64
    %196 = llvm.urem %195, %189  : i64
    %197 = llvm.sub %195, %196 : i64
    %198 = llvm.inttoptr %197 : i64 to !llvm.ptr
    %199 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %200 = llvm.insertvalue %191, %199[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %201 = llvm.insertvalue %198, %200[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %202 = llvm.mlir.constant(0 : index) : i64
    %203 = llvm.insertvalue %202, %201[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %204 = llvm.insertvalue %182, %203[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %205 = llvm.insertvalue %183, %204[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %206 = llvm.insertvalue %183, %205[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %207 = llvm.insertvalue %184, %206[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    cf.br ^bb22(%3 : index)
  ^bb22(%208: index):  // 2 preds: ^bb21, ^bb26
    %209 = builtin.unrealized_conversion_cast %208 : index to i64
    %210 = builtin.unrealized_conversion_cast %208 : index to i64
    %211 = llvm.icmp "slt" %210, %0 : i64
    llvm.cond_br %211, ^bb23, ^bb27
  ^bb23:  // pred: ^bb22
    cf.br ^bb24(%3 : index)
  ^bb24(%212: index):  // 2 preds: ^bb23, ^bb25
    %213 = builtin.unrealized_conversion_cast %212 : index to i64
    %214 = builtin.unrealized_conversion_cast %212 : index to i64
    %215 = llvm.icmp "slt" %214, %1 : i64
    llvm.cond_br %215, ^bb25, ^bb26
  ^bb25:  // pred: ^bb24
    %216 = llvm.extractvalue %42[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %217 = llvm.getelementptr %216[%213] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %218 = llvm.load %217 : !llvm.ptr -> f32
    %219 = llvm.extractvalue %207[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %220 = llvm.mlir.constant(10 : index) : i64
    %221 = llvm.mul %209, %220 : i64
    %222 = llvm.add %221, %213 : i64
    %223 = llvm.getelementptr %219[%222] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %218, %223 : f32, !llvm.ptr
    %224 = llvm.add %214, %0 : i64
    %225 = builtin.unrealized_conversion_cast %224 : i64 to index
    cf.br ^bb24(%225 : index)
  ^bb26:  // pred: ^bb24
    %226 = llvm.add %210, %0 : i64
    %227 = builtin.unrealized_conversion_cast %226 : i64 to index
    cf.br ^bb22(%227 : index)
  ^bb27:  // pred: ^bb22
    %228 = llvm.mlir.constant(1 : index) : i64
    %229 = llvm.mlir.constant(10 : index) : i64
    %230 = llvm.mlir.constant(1 : index) : i64
    %231 = llvm.mlir.constant(10 : index) : i64
    %232 = llvm.mlir.zero : !llvm.ptr
    %233 = llvm.getelementptr %232[%231] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %234 = llvm.ptrtoint %233 : !llvm.ptr to i64
    %235 = llvm.mlir.constant(64 : index) : i64
    %236 = llvm.add %234, %235 : i64
    %237 = llvm.call @malloc(%236) : (i64) -> !llvm.ptr
    %238 = llvm.ptrtoint %237 : !llvm.ptr to i64
    %239 = llvm.mlir.constant(1 : index) : i64
    %240 = llvm.sub %235, %239 : i64
    %241 = llvm.add %238, %240 : i64
    %242 = llvm.urem %241, %235  : i64
    %243 = llvm.sub %241, %242 : i64
    %244 = llvm.inttoptr %243 : i64 to !llvm.ptr
    %245 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)>
    %246 = llvm.insertvalue %237, %245[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %247 = llvm.insertvalue %244, %246[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %248 = llvm.mlir.constant(0 : index) : i64
    %249 = llvm.insertvalue %248, %247[2] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %250 = llvm.insertvalue %228, %249[3, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %251 = llvm.insertvalue %229, %250[3, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %252 = llvm.insertvalue %229, %251[4, 0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %253 = llvm.insertvalue %230, %252[4, 1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %254 = builtin.unrealized_conversion_cast %253 : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> to memref<1x10xf32>
    cf.br ^bb28(%3 : index)
  ^bb28(%255: index):  // 2 preds: ^bb27, ^bb32
    %256 = builtin.unrealized_conversion_cast %255 : index to i64
    %257 = builtin.unrealized_conversion_cast %255 : index to i64
    %258 = llvm.icmp "slt" %257, %0 : i64
    llvm.cond_br %258, ^bb29, ^bb33
  ^bb29:  // pred: ^bb28
    cf.br ^bb30(%3 : index)
  ^bb30(%259: index):  // 2 preds: ^bb29, ^bb31
    %260 = builtin.unrealized_conversion_cast %259 : index to i64
    %261 = builtin.unrealized_conversion_cast %259 : index to i64
    %262 = llvm.icmp "slt" %261, %1 : i64
    llvm.cond_br %262, ^bb31, ^bb32
  ^bb31:  // pred: ^bb30
    %263 = llvm.extractvalue %117[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %264 = llvm.mlir.constant(10 : index) : i64
    %265 = llvm.mul %256, %264 : i64
    %266 = llvm.add %265, %260 : i64
    %267 = llvm.getelementptr %263[%266] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %268 = llvm.load %267 : !llvm.ptr -> f32
    %269 = llvm.extractvalue %207[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %270 = llvm.mlir.constant(10 : index) : i64
    %271 = llvm.mul %256, %270 : i64
    %272 = llvm.add %271, %260 : i64
    %273 = llvm.getelementptr %269[%272] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %274 = llvm.load %273 : !llvm.ptr -> f32
    %275 = llvm.fadd %268, %274  : f32
    %276 = llvm.extractvalue %253[1] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    %277 = llvm.mlir.constant(10 : index) : i64
    %278 = llvm.mul %256, %277 : i64
    %279 = llvm.add %278, %260 : i64
    %280 = llvm.getelementptr %276[%279] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    llvm.store %275, %280 : f32, !llvm.ptr
    %281 = llvm.add %261, %0 : i64
    %282 = builtin.unrealized_conversion_cast %281 : i64 to index
    cf.br ^bb30(%282 : index)
  ^bb32:  // pred: ^bb30
    %283 = llvm.add %257, %0 : i64
    %284 = builtin.unrealized_conversion_cast %283 : i64 to index
    cf.br ^bb28(%284 : index)
  ^bb33:  // pred: ^bb28
    %285 = bufferization.to_tensor %254 : memref<1x10xf32>
    %286 = llvm.extractvalue %68[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%286) : (!llvm.ptr) -> ()
    %287 = llvm.extractvalue %117[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%287) : (!llvm.ptr) -> ()
    %288 = llvm.extractvalue %207[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%288) : (!llvm.ptr) -> ()
    %289 = llvm.extractvalue %253[0] : !llvm.struct<(ptr, ptr, i64, array<2 x i64>, array<2 x i64>)> 
    llvm.call @free(%289) : (!llvm.ptr) -> ()
    return %285 : tensor<1x10xf32>
  }
}

{-#
  dialect_resources: {
    builtin: {
      torch_tensor_10_torch.float32: "0x0400000091591A3D43E34DBEF850643EA7A14EBE97CAA53CF2C6903E3A36863CB7A628BEBD21583C2F98883E",
      torch_tensor_10_10_torch.float32: "0x04000000467D5E3EEE8AACBC7E822F3EF69F113E7BF036BE912824BE0351973E0EDD65BE7D272E3E10CB8BBE4F65873DE5008F3E85E348BE169450BDA66B20BE2C68ADBDB38FB03C809A6F3E45E9D0BD6EBA9A3E3B76393EAE322D3EFE95B13DBD02D03D46109F3EF8AE943E01A433BE096412BD4DCF6D3D6E3C92BE3DEE0CBEB1E7CD3BCA9F6F3E07A2213ED5325C3E0AA9883E612057BEE8909EBEDED2B83CB4519AB89DF393BEA1D034BC5C9E823E8B10463E267666BEE8AB3A3E3E712D3E791B1E3E8C2C97BE515F4ABD3A4978BDFC5A9C3DBB7DA13E54468DBEC728953D172E53BE3EFBB43D37CB803EE52F953ECF25873DC2D194BE0327323E039895BDC1D71FBE1672053BED5E123EEE5353BD8CB225BE5D91443EC11C34BE8371EC3DBB0B093C23CE27BEA3EBD9BBD51F113EC3569ABD04AE383E494E8ABCCED064BD8137423E4BEC7ABED63A613DC457FA3DD1D2A93DF9FD603E1E0DFA3D65892BBE9BEF9B3E9A0F73BE7D64023D5BC8FC3DC59214BCC64D21BEB11511BE845F87BEA06DF73DD1C345BEE27479BE822F30BE25280BBE"
    }
  }
#-}
