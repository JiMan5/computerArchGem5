% specbzip
L1_dcache_size_specbzip = [64, 128, 128, 128, 128, 128];
L1_icache_size_specbzip = [32, 32, 32, 32, 32, 32];
L2_cache_size_specbzip = [1024, 1024, 2048, 4096, 4096, 4096];
L1_dcache_assoc_specbzip = [2, 2, 2, 2, 4, 8];
L1_icache_assoc_specbzip = [2, 2, 2, 2, 2, 2];
L2_cache_assoc_specbzip = [4, 4, 4, 4, 4, 4];
cacheline_size_specbzip = [128, 128, 64, 64, 64, 256];
cpi_specbzip = [1.692537, 1.660100, 1.649604, 1.624885, 1.617195, 1.592772];

% specmcf
L1_dcache_size_specmcf = [64, 128, 64, 64, 64, 128];
L1_icache_size_specmcf = [64, 64, 64, 64, 128, 64];
L2_cache_size_specmcf = [1024, 1024, 2048, 4096, 4096, 4096];
L1_dcache_assoc_specmcf = [2, 2, 2, 2, 2, 2];
L1_icache_assoc_specmcf = [2, 2, 2, 2, 4, 2];
L2_cache_assoc_specmcf = [8, 8, 8, 8, 8, 4];
cacheline_size_specmcf = [64, 128, 64, 64, 64, 256];
cpi_specmcf = [1.160209, 1.127683, 1.155606, 1.155199, 1.155043, 1.108120];

% spechmmer
L1_dcache_size_spechmmer = [32, 64, 128, 128, 128, 128];
L1_icache_size_spechmmer = [32, 32, 32, 32, 32, 32];
L2_cache_size_spechmmer = [2048, 2048, 2048, 2048, 2048, 2048];
L1_dcache_assoc_spechmmer = [2, 2, 2, 4, 8, 8];
L1_icache_assoc_spechmmer = [2, 2, 2, 2, 2, 2];
L2_cache_assoc_spechmmer = [8, 8, 8, 8, 8, 8];
cacheline_size_spechmmer = [64, 64, 64, 64, 128, 256];
cpi_spechmmer = [1.191346, 1.187917, 1.186170, 1.185883, 1.180142, 1.178082];

% specsjeng
L1_dcache_size_specsjeng = [64, 128, 128, 128, 128];
L1_icache_size_specsjeng = [32, 32, 64, 128, 64];
L2_cache_size_specsjeng = [2048, 2048, 4096, 4096, 4096];
L1_dcache_assoc_specsjeng = [2, 2, 4, 4, 2];
L1_icache_assoc_specsjeng = [2, 2, 2, 2, 2];
L2_cache_assoc_specsjeng = [8, 2, 8, 4, 4];
cacheline_size_specsjeng = [64, 64, 128, 256, 256];
cpi_specsjeng = [10.270554, 10.270140, 6.795158, 5.171570, 5.171666];

% speclibm
L1_dcache_size_speclibm = [64, 64, 128, 128, 128];
L1_icache_size_speclibm = [32, 32, 32, 32, 32];
L2_cache_size_speclibm = [2048, 2048, 4096, 4096, 4096];
L1_dcache_assoc_speclibm = [2, 2, 2, 4, 2];
L1_icache_assoc_speclibm = [2, 2, 2, 2, 2];
L2_cache_assoc_speclibm = [4, 8, 8, 4, 4];
cacheline_size_speclibm = [64, 64, 64, 128, 256];
cpi_speclibm = [3.493415, 3.493415, 3.489639, 2.576600, 1.989308];

% cost and score calc function so that I can calculate for each one for
% each benchmark. Then print out the results of each and of the best!
function calculate_and_display_scores(L1_dcache_size, L1_icache_size, L2_cache_size, ...
    L1_dcache_assoc, L1_icache_assoc, L2_cache_assoc, cacheline_size, cpi, benchmark_name)

    cost = (1/64) * (L1_dcache_size.^2) + ...
           (1/32) * (L1_icache_size.^2) + ...
           (1/2048) * (L2_cache_size.^2) + ...
           (1/2) * (L1_dcache_assoc) + ...
           (1/2) * (L1_icache_assoc) + ...
           (1/4096) * (L2_cache_assoc .* L2_cache_size) + ...
           (1/10) * log(cacheline_size);

    score = cpi .* cost;

    [sorted_score, sorted_indices] = sort(score);

    disp(['Benchmark ', benchmark_name, ':']);
    for i = 1:length(sorted_score)
        idx = sorted_indices(i);
        fprintf('%s_%d score = %.2f, cost = %.2f, cpi = %.6f\n', ...
            benchmark_name, idx-1, sorted_score(i), cost(idx), cpi(idx));
    end

    [best_cpi, best_cpi_index] = min(cpi);
    fprintf('Best CPI for %s: %s_%d = %.6f\n', benchmark_name, benchmark_name, best_cpi_index-1, best_cpi);

    [best_score, best_score_index] = min(score);
    fprintf('Best score for %s: %s_%d = %.2f\n\n', benchmark_name, benchmark_name, best_score_index-1, best_score);
end

% function calls for every benchmark.
calculate_and_display_scores(L1_dcache_size_specbzip, L1_icache_size_specbzip, L2_cache_size_specbzip, ...
    L1_dcache_assoc_specbzip, L1_icache_assoc_specbzip, L2_cache_assoc_specbzip, cacheline_size_specbzip, ...
    cpi_specbzip, 'specbzip');

calculate_and_display_scores(L1_dcache_size_specmcf, L1_icache_size_specmcf, L2_cache_size_specmcf, ...
    L1_dcache_assoc_specmcf, L1_icache_assoc_specmcf, L2_cache_assoc_specmcf, cacheline_size_specmcf, ...
    cpi_specmcf, 'specmcf');

calculate_and_display_scores(L1_dcache_size_spechmmer, L1_icache_size_spechmmer, L2_cache_size_spechmmer, ...
    L1_dcache_assoc_spechmmer, L1_icache_assoc_spechmmer, L2_cache_assoc_spechmmer, cacheline_size_spechmmer, ...
    cpi_spechmmer, 'spechmmer');

calculate_and_display_scores(L1_dcache_size_specsjeng, L1_icache_size_specsjeng, L2_cache_size_specsjeng, ...
    L1_dcache_assoc_specsjeng, L1_icache_assoc_specsjeng, L2_cache_assoc_specsjeng, cacheline_size_specsjeng, ...
    cpi_specsjeng, 'specsjeng');

calculate_and_display_scores(L1_dcache_size_speclibm, L1_icache_size_speclibm, L2_cache_size_speclibm, ...
    L1_dcache_assoc_speclibm, L1_icache_assoc_speclibm, L2_cache_assoc_speclibm, cacheline_size_speclibm, ...
    cpi_speclibm, 'speclibm');
