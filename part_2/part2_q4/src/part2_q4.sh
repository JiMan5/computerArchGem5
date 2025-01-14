#!/bin/bash

./build/ARM/gem5.opt -d spec_results/specbzip_DDRfast3GHz configs/example/se.py --cpu-type=MinorCPU --cpu-clock=3GHz --mem-type=DDR3_2133_8x8 --caches --l2cache -c spec_cpu2006/401.bzip2/src/specbzip -o "spec_cpu2006/401.bzip2/data/input.program 10" -I 100000000
./build/ARM/gem5.opt -d spec_results/specbzip_DDRfast1GHz configs/example/se.py --cpu-type=MinorCPU --cpu-clock=1GHz --mem-type=DDR3_2133_8x8 --caches --l2cache -c spec_cpu2006/401.bzip2/src/specbzip -o "spec_cpu2006/401.bzip2/data/input.program 10" -I 100000000

echo "All benchmarks have been executed."
