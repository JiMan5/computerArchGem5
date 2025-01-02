"""This script is the syscall emulation example script from the ARM
Research Starter Kit on System Modeling. More information can be found
at: http://www.arm.com/ResearchEnablement/SystemModeling
"""

from __future__ import print_function
from __future__ import absolute_import

import os
import m5
from m5.util import addToPath
from m5.objects import *
import argparse
import shlex

m5.util.addToPath('../..')

from common import ObjectList
from common import MemConfig
from common.cores.arm import HPI

import devices

cpu_types = {
    "atomic" : ( AtomicSimpleCPU, None, None, None, None),
    "minor" : (MinorCPU,
               devices.L1I, devices.L1D,
               devices.WalkCache,
               devices.L2),
    "hpi" : ( HPI.HPI,
              HPI.HPI_ICache, HPI.HPI_DCache,
              HPI.HPI_WalkCache,
              HPI.HPI_L2)
}

class SimpleSeSystem(System):
    '''
    Example system class for syscall emulation mode
    '''

    # cache size = 64 bytes
    cache_line_size = 64

    def __init__(self, args, **kwargs):
        super(SimpleSeSystem, self).__init__(**kwargs)

        # Voltage = 3.3V, clock = 1GHz
        self.voltage_domain = VoltageDomain(voltage="3.3V")
        self.clk_domain = SrcClockDomain(clock="1GHz",
                                         voltage_domain=self.voltage_domain)

        # Off-chip memory bus
        self.membus = SystemXBar()

        self.system_port = self.membus.slave

        # Number of cores, CPU frequency, voltage, and CPU type are passed
        self.cpu_cluster = devices.CpuCluster(self,
                                              args.num_cores,  
                                              args.cpu_freq,   
                                              "1.2V",
                                              *cpu_types[args.cpu])  

        # Cache hierarchy, L1 and L2 only if timing is enabled
        if self.cpu_cluster.memoryMode() == "timing":
            self.cpu_cluster.addL1()  # Adds L1 cache
            self.cpu_cluster.addL2(self.cpu_cluster.clk_domain)  # Adds L2 cache

        self.cpu_cluster.connectMemSide(self.membus)

        self.mem_mode = self.cpu_cluster.memoryMode()

    def numCpuClusters(self):
        return len(self._clusters)

    def addCpuCluster(self, cpu_cluster, num_cpus):
        assert cpu_cluster not in self._clusters
        assert num_cpus > 0
        self._clusters.append(cpu_cluster)
        self._num_cpus += num_cpus

    def numCpus(self):
        return self._num_cpus

def get_processes(cmd):
    """Interprets commands to run and returns a list of processes"""

    cwd = os.getcwd()
    multiprocesses = []
    for idx, c in enumerate(cmd):
        argv = shlex.split(c) 

        process = Process(pid=100 + idx, cwd=cwd, cmd=argv, executable=argv[0])

        print("info: %d. command and arguments: %s" % (idx + 1, process.cmd))
        multiprocesses.append(process)

    return multiprocesses

def create(args):
    ''' Create and configure the system object. '''

    system = SimpleSeSystem(args)

    # Specifies start address and size of memory (the default is used at 2GB)
    system.mem_ranges = [ AddrRange(start=0, size=args.mem_size) ]

    MemConfig.config_mem(args, system)

    processes = get_processes(args.commands_to_run)
    if len(processes) != args.num_cores: 
        print("Error: Cannot map %d command(s) onto %d CPU(s)" %
              (len(processes), args.num_cores))
        sys.exit(1)
    for cpu, workload in zip(system.cpu_cluster.cpus, processes):
        cpu.workload = workload

    return system

def main():
    parser = argparse.ArgumentParser(epilog=__doc__)

    # Argument for commands to execute
    parser.add_argument("commands_to_run", metavar="command(s)", nargs='*',
                        help="Command(s) to run")

    # Argument for CPU model selection (default = atomic)
    parser.add_argument("--cpu", type=str, choices=cpu_types.keys(),
                        default="atomic",
                        help="CPU model to use")

    # Argument for CPU frequency (default = 1GHz)
    parser.add_argument("--cpu-freq", type=str, default="1GHz")

    # Argument for number of CPU cores (default = 1)
    parser.add_argument("--num-cores", type=int, default=1,
                        help="Number of CPU cores")

    # Argument for memory type (default = DDR3_1600_8x8)
    parser.add_argument("--mem-type", default="DDR3_1600_8x8",
                        choices=ObjectList.mem_list.get_names(),
                        help = "type of memory to use")

    # Argument for memory channels (default = 2)
    parser.add_argument("--mem-channels", type=int, default=2,
                        help = "number of memory channels")

    # Argument for memory ranks per channel (default = None)
    parser.add_argument("--mem-ranks", type=int, default=None,
                        help = "number of memory ranks per channel")

    # Argument for memory size (default = 2GB)
    parser.add_argument("--mem-size", action="store", type=str,
                        default="2GB",
                        help="Specify the physical memory size")

    args = parser.parse_args()

    root = Root(full_system=False)  # Syscall emulation mode specified here

    root.system = create(args)

    # Instantiate the simulation objects
    m5.instantiate()

    # Start the simulation and capture the exit event
    event = m5.simulate()

    # Log the reason for simulation exit and exit with the appropriate code
    print(event.getCause(), " @ ", m5.curTick())
    sys.exit(event.getCode())

if __name__ == "__m5_main__":
    main()
