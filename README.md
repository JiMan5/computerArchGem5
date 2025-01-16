# Αναφορά προαιρετικής εργασίας gem5

## Ερωτήματα πρώτου μέρους
### Υποερώτημα 1
Μέσο της εντολής που δίνεται στην εκφώνηση, περνάει μονάχα η παράμετρος για τον τύπο της CPU. Όλες οι άλλες παράμετροι μπορούν να βρεθούν εντός του αρχείου starter_se.py ως οι Default παράμετροι και καταγράφονται παρακάτω:
	* CPU type = minor
	*  CPU frequency = 1 GHz
	* Number of cores = 1 core
	* Memory type = DDR3_1600_8x8
	* Memory Channels = 2
	* Memory Size = 2GB
	* Memory Bus = SystemXBar
	* L1 Cache = 64 bytes line size (Instruction και Data, ιδιωτική για κάθε CPU)
	* L2 Cache = 64 bytes line size (μοιράζεται σε όλο το cluster, μονο για timing memory mode)
	* System Voltage = 3.3V
	* CPU Voltage = 1.2V

### Υποερώτημα 2
Για το δεύτερο ερώτημα μελετάω τα αρχεία που παρήχθησαν από το emulation (stats.txt, config.ini και config.json)
* Αρχικά μπορώ να επιβεβαιώσω πως οι παράμετροι που περάστηκαν από το _starter_se.py_ αρχείο πέρασαν όντως στο σύστημα και η εξομοίωση έγινε ορθώς.
	* Από το _config.ini_ έχουμε τα εξής δεδομένα: 
		> [system.cpu_cluster.cpus]  
		type=MinorCPU  
		numThreads=1
			>
			>[system.cpu_cluster.clk_domain]  
			clock=1000
			>
			>[system]  
			cache_line_size=64
			>
			>[system]  
			mem_mode=timing  
			mem_ranges=0:2147483647
			>
			>[system.voltage_domain]  
			voltage=3.3  
			[system.cpu_cluster.voltage_domain]  
			voltage=1.2
			>
			>[system.cpu_cluster.cpus.icache] 
			type=Cache 
			size=49152 
			assoc=3 
			block_size=64 
			[system.cpu_cluster.cpus.dcache]
			 type=Cache
			 size=32768
			 assoc=2 
			 block_size=64
			 >
			 >[system.membus]   type=CoherentXBar 
			 width=16
		
	* Από το _config.json_ επίσης επιβεβαιώνουμε τα δεδομένα:
		>"cxx_class": "MinorCPU"
		>
		>"clk_domain": { 
		"clock": [1000] 
		}  
		>
		>"cache_line_size": 64
		>
		>"mem_ranges": ["0:2147483647"], 
		"mem_mode": "timing"
		>
		>"voltage_domain": { 
		"voltage": [3.3] 
		}, 
		"cpu_cluster": { 
		"voltage_domain": { 
		"voltage": [1.2] 
			} 
		}
		>
		>"icache": { 
		"size": 49152, 
		"assoc": 3, 
		"block_size": 64 
		}, 
		"dcache": { 
		"size": 32768, 
		"assoc": 2, 
		"block_size": 64 
		}
		>
		>"membus": { 
		"type": "CoherentXBar", 
		"width": 16 
		}
	
	* Τόσο στα _config_ αρχεία, όσο και στο _stats.txt_ εντωπίζουμε τα sim_seconds, sim_insts και host_inst_rate. Εντός των config αρχείων φαίνονται όλα να είναι ίσα με το 0, όμως στο .txt αρχείο βρίσκουμε τις ακριβείς τιμές:
		* sim_seconds = 0.000035s or 35 μs, είναι ο προσομοιωμένος χρόνος σε δευτερόλεπτα
		*  sim_insts = 5027, είναι ο συνολικός αριθμός εντολών που εκτελέστηκαν στην προσομοίωση.
		* host_inst_rate = 67456 inst/s, ο αριθμός των εντολών ανά δευτερόλεπτο στην προσομοίωση από τον host machine.
	
	* Εντός του stats.txt βρίσκω τα δεδομένα των **system.cpu_cluster.cpus.committedInsts** και **system.cpu_cluster.cpus.committedOps**, που αποτελούν πολύ σημαντικά στοιχεία μιας εξομοίωσης. Οι "committed" εντολές είναι αυτές που ο επεξεργαστής, η CPU, κατάφερε να εκτελέσει και να δεσμεύσει, δηλαδή να τελειωποιήσει και να γράψει στην αρχιτεκτονική κατάστασή της. (δηλαδή τα αποτελέσματα των εκτελεσμένων εντελών καταγράφονται και γίνονται μόνιμα και προσβάσιμα από το υπόλοιπο σύστημα).
		* system.cpu_cluster.cpus.committedInsts = 5027
		* system.cpu_cluster.cpus.committedOps = 5831 (αυτές συμπεριλαμβάνουν και μικρο-πράξεις για την εκτέλεση των εντολών, για αυτό και ο αριθμός είναι μεγαλύτερος)
	
		Επίσης εντός του stats.txt βρίσκω τις **system.cpu_cluster.cpus.discardedOps** = 1300, που είναι ο αριθμός των εντολών που απορρίφθηκαν λόγω πιθανών αποτυχιών στην εκτέλεσή τους.
			
	* Η μνήμη cache L2 προσπελάστηκε **system.cpu_cluster.l2.overall_accesses::total** = 474 φορές. Αν όμως δεν μου δινόταν αυτή η πληροφορία άμεσα, θα μπορούσα να υπολογίσω τις προσπελάσεις, υπολογίζοντας τις φορές που είχα miss στη μνήμη cache L1. Συγκεκριμένα, βλέποντας τις **system.cpu_cluster.cpus.icache.overall_misses::total** = 327 (instruction L1) και **system.cpu_cluster.cpus.dcache.overall_misses::total** = 147 (data L1), παίρνω το άθροισμα 327 + 147 = 474.

### Υποερώτημα 3

Για το τρίτο ερώτημα αρχικά ζητάται να γίνει μια μικρή έρευνα γύρω από τα διάφορα μοντέλα in-order επεξεργαστών που προσφέρει το gem5. Έχουμε λοιπόν τα εξής: 
* BaseSimpleCPU: Απλή CPU χωρίς pipeline, εντελώς μη ρεαλιστική, όμως πάρα πολύ γρήγορη. Βασική λειτουργικότητα για την προσομοίωση. Έχει τις δύο εξείς υλοποιήσεις:
	* AtomicSimpleCPU: Η προεπιλογή του gem5. Οι προσπελάσεις μνήμης πραγματοποιούνται ακαριαία μέσω του atomic memory accesses. Η ταχύτερη προσομοίωση, αλλά καθόλου ρεαλιστική. Χρησιμοποιείται για να κάνει ουσιαστικά fast-forward προσομοιώσεις, όταν η ανάλυση χρονισμού δεν είναι κρίσιμη.
	* TimingSimpleCPU: Σε αυτή την υλοποίηση οι προσπελάσεις μνήμης είναι ρεαλιστικές στον χρόνο, αλλά η CPU δεν διαθέτει pipeline. Η προσομοίωση είναι ταχύτερη από τα λεπτομερή μοντέλα, αλλά πιο αργή από την AtomicSimpleCPU.
* MinorCPU: Λεπτομερές in-order CPU, με σταθερή δομή pipeline και ανοιχτές προς διαμόρφωση συμπεριφορές εκτέλεσης και data paths. Έχει σχεδιαστεί για να προσομοιώνει επεξεργαστές με αυστηρή in-order εκτέλεση, επιτρέποντας έτσι τις μελέτες μικρο-αρχιτεκτονικής και τις αναλύσεις απόδοσης.
* DerivO3CPU: Λεπτομερής out-of-order CPU μοντελοποίηση που υποστηρίζει περίπλοκες superscalar αρχιτεκτονικές (δηλαδή πολλές εντολές μπορούν να ξεκινήσουν ταυτόχρονα και να εκτελεστούν ανεξάρτητα). Επιτρέπει έτσι την προσομοίωση πολλαπλών σύγχρονων επεξεργαστών που στηρίζουν τεχνολογίες όπως speculative execution και dynamic scheduling.
* KvmCPU: Μοντέλο επεξεργαστή που αξιοποιεί το visualization του υλικού μέσω του Kernel-based Virtual Machine (KVM) για να επιταχύνει την προσομοίωση εκτελώντας τον κώδικα απευθείας στην κεντρική μονάδα επεξεργασίας του host όταν τα Instruction Set Architectures τόσο του guest όσο και του host ISAs είναι συμβατά.
* TraceCPU: Μοντέλο επεξεργαστή τεχνολογίας trace, δηλαδή που αναπαράγει προ-καταγεγραμμένα traces εντολών με σημειώσεις timing. Χρησιμεύει για την μελέτη συστημάτων μνήμης και τις αποδόσεις τους χωρίς το βάρος της λεπτομερούς μοντελοποίησης του επεξεργαστή.
#### 3_A
|   | MinorCPU  | TimingSimpleCPU  |
|---|---|---|
|  Number of Ticks |  35224000 |  40196000  |
|  Simulation seconds   | 0.000035  |  0.00004  |
|  Number of CPU cycles | 70448  |  80392  | 
|  Number of committed instructions | 9213  |  9156  | 
|  CPI (cycles per instruction) |  7.646586  |  N/A |

#### 3_B
Τα αποτελέσματα στους χρόνους είναι σαφώς διαφορετικά. Βλέπουμε πως ο MinorCPU ειναι 12.36% γρηγορότερος από τον TimingSimpleCPU. Αυτό οφείλεται στο ότι ο TimingSimpleCPU δε διαθέτει pipeline και λαμβάνει υπόψιν του καθυστερήσεις των προσπελάσεων της μνήμης κατά τη μοντελοποίηση, γεγονός που αυξάνει τον χρόνο εκτέλεσης. Παρατηρώ πως ο αριθμός των committed instructions είναι παρόλα αυτά σχεδόν ίδιος, παρά τις διαφορετικές τεχνολογίες, πράγμα απολύτως λογικό αφού ο αριθμός αυτός καθορίζεται μονάχα από τη λογική του προγράμματος κι όχι από παραμέτρους υλικού. (Δεν είναι ακριβώς ίδιος λόγω μικροδιαφορών στις διαχειρίσεις και την προσομοίωση του κάθε επεξεργαστή)

#### 3_C
##### CPU clock: 100MHz
|   | MinorCPU  | TimingSimpleCPU  |
|---|---|---|
|  Number of Ticks |  189020000 |  310290000  |
|  Simulation seconds   | 0.000189  |  0.000310  |
|  Number of CPU cycles | 18902  |  31029  | 
|  Number of committed instructions | 9213  |  9156  | 
|  CPI (cycles per instruction) |  2.0516  |  N/A |

##### Memory type: DDR4_2400_8x8
|   | MinorCPU  | TimingSimpleCPU  |
|---|---|---|
|  Number of Ticks |  33908000 |  39874000  |
|  Simulation seconds   | 0.000034  |  0.000040  |
|  Number of CPU cycles | 67816  |  79748  | 
|  Number of committed instructions | 9213  |  9156  | 
|  CPI (cycles per instruction) |  7.3609  | N/A |

Αρχικά, και για τις δύο αλλαγές στις παραμέτρους των επεξεργαστών, η MinorCPU παραμένει συγκριτικά γρηγορότερη από την TimingSimpleCPU. Οι λόγοι που προαναφέρθηκαν συνεχίζουν να ισχύουν. Παρατηρώ πως ο αριθμός των committed instructions παραμένει ακριβώς ο ίδιος παρά τις αλλαγές στις τεχνολογίες, πράγμα απολύτως λογικό για τον λόγο που προαναφέρθηκε. Τα υπόλοιπα όμως αλλάζουν.   
Όταν μειώνω την συχνότητα του ρολογιού στα 100MHz, αρχικά βλέπω πως ο αριθμός των συνολικών ticks και των simulated δευτερολέπτων αυξήθηκε μία τάξη μεγέθους, όπως θα περιμέναμε. Επίσης, CPU Cycles =Number of Ticks​ / Ticks Per Cycle, οπότε πράγματι ο αριθμός αυτός μειώθηκε αισθητά.
Όταν αλλάζω την τεχνολογία μνήμης σε DDR4, παρατηρώ πως όλοι μου οι χρόνοι μειώθηκαν, όπως περίμενα. Φυσικά όχι αισθητά πολύ, καθώς η DDR4 RAM είναι πάλι πιο αργή από την cache του επεξεργαστή.
## Ερωτήματα δεύτερου μέρους
Το δεύτερο μέρος της εργασίας χωρίζεται σε 3 βήματα. Αφού γράφτηκαν τα απαραίτητα bash scripts, προχωράμε στην υλοποίηση
### Βήμα 1ο
Αρχικά, εκτελούμε 5 διαφορετικά benchmarks του SPEC CPU2006 στον gem5 με κοινές παραμέτρους. 
#### Υποερώτημα 1
Για όλες τις εκτελέσεις μας λαμβάνουμε τα εξής δεδομένα (που βρίσκω εύκολα στα __config.json__ αρχεία.

|  Cache Type  |  Associativity  |  Size  |  Line size (bytes)  |
|---|---|---|---|
|  L1 Data [system.cpu.dcache]  |  2  |  65536  |  64  |
|  L1 instruction [system.cpu.icache]  |  2  |  32768  |  64  |
|  L2 [system.l2]  |  8  |  2097152  |  64  |

#### Υποερώτημα 2
Εδώ θα συγκρίνω τα αποτελέσματα των προσομοιώσεων
|  Benchmark  |  sim_seconds  |  system.cpu.cpi  |  system.cpu.dcache.overall_miss_rate::total  |  system.cpu.icache.overall_miss_rate::total  |  system.l2.overall_miss_rate::total  |
|---|---|---|---|---|---|
|  specbzip  |  0.083982  |  1.679650  |  0.014798  |  0.000077  |  0.282163  |
|  specmcf |  0.064955  |  1.299095  |  0.002108  |  0.023612  |  0.055046  |
|  spechmmer |  0.059396  |  1.187917  |  0.001637  |  0.000221  |  0.077760  |
|  specsjeng  |  0.513528  |  10.270554  |  0.121831  |  0.000020  |  0.999972  |
| speclibm   |  0.174671  |  3.493415  |  0.060972  |  0.000094  |  0.999944  |

Κι εδώ παρατίθονται τα γραφήματα:
![sim seconds graph](https://github.com/JiMan5/computerArchGem5/blob/main/part_2/part2_q1/graphs_part2_q2/sim_seconds.png)

![cpi graph](https://github.com/JiMan5/computerArchGem5/blob/main/part_2/part2_q1/graphs_part2_q2/system_cpu_cpi.png)

![L1 data miss rate](https://github.com/JiMan5/computerArchGem5/blob/main/part_2/part2_q1/graphs_part2_q2/system_cpu_dcache_overall_miss_rate_total.png)

![L1 instructions miss rate](https://github.com/JiMan5/computerArchGem5/blob/main/part_2/part2_q1/graphs_part2_q2/system_cpu_icache_overall_miss_rate_total.png)

![L2 miss rate](https://github.com/JiMan5/computerArchGem5/blob/main/part_2/part2_q1/graphs_part2_q2/system_l2_overall_miss_rate_total.png)

Από τον πίνακα με τα δεδομένα, που έπειτα αναπαρίστανται και σε γραφήματα, παρατηρώ πως το χειρότερο από τα benchmarks είναι το
specsjeng, το οποίο έχει τον μεγαλύτερο ρυθμό αστοχίας της L1 data cache και L2 cache. Το specmcf, παρόλο που έχει τη χειρότερη απόδοση με μεγάλη διαφορά όσον αφορά τον ρυθμό αστοχίας της L1 instruction cache επιτυγχάνει τον δεύτερο καλύτερο CPI. Αυτό συμβαίνει επειδή η L2 cache είναι πολύ πιο αργή από την L1 και η έλλειψη απόδοσης σε αυτήν μπορεί να καθιστά την CPU πολύ αργή. Το spechmmer αποτελεί την καλύτερη εκτέλεση με cpi = 1.187917.

#### Υποερώτημα 3
Αφού έτρεξαν ξανά τα benchmarks με --cpu-clock = 1, 3 GHz, παρατίθονται τα ζητούμενα αποτελέσματα στους παρακάτω πίνακες
##### system.clk_domain.clock
|  Benchmark  |  --cpu-clock=default(2GHz)  |  --cpu-clock=1GHz  |  --cpu-clock=default=3GHz  |
|---|---|---|---|
|  ∀  |  1000  |  1000  |  1000  |

##### system.cpu_clk_domain.clock
|  Benchmark  |  --cpu-clock=default(2GHz)  |  --cpu-clock=1GHz  |  --cpu-clock=default=3GHz  |
|---|---|---|---|
|  ∀  |  500  |  1000  |  333  |

Παρατηρώ αρχικά πως και στις τρεις προσομοιώσεις τo system.clk_domain.clock = 1000 ticks. Η αλλαγή που παρατηρείται είναι στο system.cpu.clk_domain.clock όπως φαίνεται στον παραπάνω πίνακα. Αυτό συμβαίνει γιατί το  system.cpu.clk_domain.clock είναι το ρολόι του πυρήνα του επεξεργαστή, ενώ το system.clk_domain.clock διατηρεί μια baseline συχνότητα επικοινωνίας για όλο το υπόλοιπο σύστημα. Έτσι, υπάρχει συγχρονισμός και αποφεύγεται το drifting. Κοιτώντας το __config.json__ της προσομοίωσης σε 1GHz, δεν είναι εύκολο να αντιληφθούμε πλήρως τι συμβαίνει και γιατί, καθώς τα system.cpu.clk_domain.clock, system.clk_domain.clock είναι ίσα με 1000 και ενδέχεται να επικρατήσει σύγχυση. Κοιτώντας όμως και τις άλλες δύο εκτελέσεις, μπορούμε να καταλήξουμε στο συμπέρασμα που προαναφέρεται.

Αν προσθέσουμε ακόμα έναν επεξεργαστή (πυρήνα), η συχνότητά του περιμένω πως θα παραμείνει 1GHz. Δεν υπάρχει τέλειο scaling. Για παράδειγμα, στην περίπτωση --cpu-clock=default=3GHz, η συχνότητα τριπλασιάζεται από την περίπτωση του --cpu-clock=default=1GHz, αλλά ο χρόνος εκτέλεσης των benchmarks δεν μειώνεται αντιστρόφως ανάλογα. Αυτό συμβαίνει για διάφορους λόγους, με τους σημαντικότερους να είναι:
* Ο απόλυτος χρόνος των memory latencies, που άρα δεν συνδέονται με το cpu-clock. Αυτό, σε υψηλότερες συχνότητες σημαίνει πως η CPU περνά περισσότερους κύκλους αναμένοντας για τη μνήμη
* Ο MinorCPU είναι ένας in-order επεξεργαστής, άρα οι εξαρτήσεις μεταξύ εντολών μπορούν να προκαλέσουν pipeline stalls. Σε υψηλότερες συχνότητες, το αντίκτυπο αυτών των stalls παραμένει, μειώνοντας, έτσι, την απόδοση της κλιμάκωσης.
* Το gem5 εισάγει καθυστερήσεις προσομοίωσης που είναι ανεξάρτητες από τη συχνότητα του επεξεργαστή.  Αυτές συνεισφέρουν σε μια σταθερή καθυστέρηση κι έτσι μειώνουν την απόδοση της κλιμάκωσης
#### Υποερώτημα 4
Για την specbzip έτρεξα ξανά την προσομοίωση αλλάζοντας την μνήμη στη **DDR3_2133_8x8**. Οι προσομοιώσεις έγιναν τόσο για cpu-clock = 1GHz όσο και για cpu-clock = 3GHz. Παρακάτω παρατίθονται οι διαφορές για τα 3GHz:
|  Benchmarks  |  sim_seconds  |  system.cpu.cpi  |  system.cpu.dcache.overall_miss_rate::total  |  system.cpu.icache.overall_miss_rate::total  |  system.l2.overall_miss_rate::total  | 
|---|---|---|---|---|---|
|  specbzip 3GHz DDR3_1600_8x8  |  0.058385  |  1.753291  |  0.014932  |  0.000077  |  0.282166  |  
|  specbzip 3GHz DDR3_2133_8x8  |  0.057996  |  1.741632  |  0.014932  |  0.000077  |  0.282167  | 

Σύγκρινοντας τα αποτελέσματα βλέπουμε πως:

   * Ο χρόνος εκτέλεσης είναι απειροελάχιστα μικρότερος με τη μνήμη DDR3_2133_8x8. Επομένως, μια γρηγορότερη μνήμη ενδέχεται να βελτιώσει τη συνολική απόδοση, αλλά στην ουσία όχι.
    * Το cpi είναι κι αυτό ελάχιστα βελτιωμένο, όμως πρακτικά σχεδόν ίδιο για τις δύο μνήμες. Επομένως, ίσως μια γρηγορότερη μνήμη να βελτιώσει την συνολική απόδοση, αλλα στην ουσία όχι.
    * Ο συνολικός ρυθμός αστοχίας της L1 είναι ακριβώς ο ίδιος, επομένως μια ταχύτερη μνήμη δεν επηρεάζει το συνολικό ρυθμό αστοχίας στην L1.
    * Ο συνολικός ρυθμός αστοχίας κρυφής μνήμης L2 είναι ουσιαστικά ο ίδιος και στις δύο περιπτώσεις, επομένως μια ταχύτερη μνήμη δεν επηρεάζει το συνολικό ρυθμό αστοχίας στην L2.

Παρατηρώ άρα πως δεν υπάρχει καμία ουσιαστική επίδραση στα αποτελέσματα της προσομοίωσης με την αλλαγή της μνήμης. Το benchmark του specbzip είναι κυρίως __compute intensive__ και ενδέχεται να μην καταπονεί πολύ το υποσύστημα μνήμης. Ως αποτέλεσμα, οι διαφορές στην απόδοση μεταξύ των DDR3_1600 και DDR3_2133 είναι ελάχιστες εώς καθόλου. Επιπλέον, όπως αναφέρθηκε και προηγουμένως, η φύση της MinorCPU είναι in-order, κι έτσι δε μπορεί να παραλληλήσει επαρκώς εντολές μνήμης κι άρα δεν υπάρχει κέρδος λόγω της DDR3_2133.

### Βήμα 2ο
Φυσικά, επειδή οι προσομοιώσεις παίρνουν πάρα πολύ χρόνο, δε θα δοκιμάσω κάθε πιθανό συνδυασμό για κάθε benchmark. Θα διαλέξω μερικούς συνδυασμούς για το κάθε benchmark και θα τους εκτελέσω. Έπειτα θα συγκρίνω τα αποτελέσματα για να απαντήσω υποερωτήματα. 
#### Υποερώτημα 1
Κοιτώντας τα αρχικά αποτελέσματα για τα dcache, icache και l2cache από τις προσομοιώσεις του βήματος 1, πειραματίζομαι με τις τιμές τόσο των μεγεθών όσο και του associativity και πειράζω αυτά που πιστεύω πως θα επηρεάσουν περισσότερο το αποτέλεσμα αν άλλαζαν δραστικά (οι τιμές που έβαλα ως όριο στον εαυτό μου είναι αυτές που φαίνονται παρακάτω και μπήκαν με σκοπό να τρέξω ένα συντηρητικό δείγμα για τα ζητούμενα της εργασίας και λόγω έλειψης χρόνου στη περίοδο πριν την εξεταστική)
* L1 DCache Size: 64 kB, 128 kB
* L1 ICache Size: 32 kB
* L2 Cache Size: 1 MB, 2 MB, 4 MB
* L1 DCache Assoc: 2, 4, 8
* L1 ICache Assoc: 2, 4, 8
* L2 Cache Assoc: 4, 8
* Cache Line Size: 64B, 128B, 256B

| Benchmarks   | L1\_dcache\_size | L1\_icache\_size | L2\_cache\_size | L1\_dcache\_assoc | L1\_icache\_assoc | L2\_cache\_assoc | cacheline\_size |
| ------------ | ---------------- | ---------------- | --------------- | ----------------- | ----------------- | ---------------- | --------------- |
| specbzip\_0  | 64               | 32               | 1024            | 2                 | 2                 | 4                | 128              |
| specbzip\_1  | 128              | 32               | 1024            | 2                 | 2                 | 4                | 128              |
| specbzip\_2  | 128              | 32               | 2048            | 2                 | 2                 | 4                | 64              |
| specbzip\_3  | 128              | 32               | 4096            | 2                 | 2                 | 4                | 64              |
| specbzip\_4  | 128              | 32               | 4096            | 4                 | 2                 | 4                | 64              |
| specbzip\_5  | 128              | 32               | 4096            | 8                 | 2                 | 4                | 256              |
| specmcf\_0   | 64               | 64              | 1024            | 2                 | 2                 | 8                | 64              |
| specmcf\_1   | 128               | 64               | 1024            | 2                 | 2                 | 8                | 128              |
| specmcf\_2   | 64               | 64               | 2048            | 2                 | 2                 | 8                | 64              |
| specmcf\_3   | 64               | 64               | 4096            | 2                 | 2                 | 8                | 64              |
| specmcf\_4   | 64               | 128               | 4096            | 2                 | 4                 | 8                | 64              |
| specmcf\_5   | 128              | 64               | 4096            | 2                 | 2                 | 4                | 256              |
| spechmmer\_0 | 32               | 32               | 2048            | 2                 | 2                 | 8                | 64              |
| spechmmer\_1 | 64               | 32               | 2048            | 2                 | 2                 | 8                | 64              |
| spechmmer\_2 | 128              | 32               | 2048            | 2                 | 2                 | 8                | 64              |
| spechmmer\_3 | 128              | 32               | 2048            | 4                 | 2                 | 8                | 64              |
| spechmmer\_4 | 128              | 32               | 2048            | 8                 | 2                 | 8                | 128              |
| spechmmer\_5 | 128              | 32               | 2048            | 8                 | 2                 | 8                | 256             |
| specsjeng\_0 | 64               | 32               | 2048            | 2                 | 2                 | 8                | 64              |
| specsjeng\_1 | 128              | 32               | 2048            | 2                 | 2                 | 2                | 64              |
| specsjeng\_2 | 128              | 64               | 4096            | 4                 | 2                 | 8                | 128              |
| specsjeng\_3 | 128              | 128               | 4096            | 4                 | 2                 | 4                | 256              |
| specsjeng\_4 | 128              | 64               | 4096            | 2                 | 2                 | 4                | 256             |
| speclibm\_0  | 64               | 32               | 2048            | 2                 | 2                 | 4                | 64              |
| speclibm\_1  | 64              | 32               | 2048            | 2                 | 2                 | 8                | 64              |
| speclibm\_2  | 128              | 32               | 4096            | 2                 | 2                 | 8                | 64              |
| speclibm\_3  | 128              | 32               | 4096            | 4                 | 2                 | 4                | 128              |
| speclibm\_4  | 128              | 32               | 4096            | 2                | 2                 | 4                | 256             |

Αφού γράφτηκε το bash script για όλες τις εκτελέσεις, λαμβάνουμε τα αποτελέσματα των προσομοιώσεων τα οποία θα απεικονιστούν και στο επόμενο υποερώτημα.
#### Υποερώτημα 2
Παρακάτω θα παρατεθούν γραφήματα για το __cpi__ και τα __cache misses__.
#### CPI
![cpi_all](https://github.com/JiMan5/computerArchGem5/blob/main/part_2/part2_step2/part2_step2_graphs/cpi_graphs/final_merged.png)
fdfdfd
#### L1 Data Cache miss rate
![dcache_all](https://github.com/JiMan5/computerArchGem5/blob/main/part_2/part2_step2/part2_step2_graphs/dcache_miss_graphs/final_merge.png)
dfdsfdsf
#### L1 Instruction Cache miss rate
![icache_all](https://github.com/JiMan5/computerArchGem5/blob/main/part_2/part2_step2/part2_step2_graphs/icache_miss_graphs/final_merged.png)
sffsdfds
#### L2 Cache miss rate
![l2_all](https://github.com/JiMan5/computerArchGem5/blob/main/part_2/part2_step2/part2_step2_graphs/l2_miss_graphs/final_merge.png)
dfdfsfs
