% Create folder for graphs
output_folder = 'icache_miss_graphs';
if ~exist(output_folder, 'dir')
   mkdir(output_folder);
end

% Data
benchmarks_specbzip = {'specbzip_0', 'specbzip_1', 'specbzip_2', 'specbzip_3', 'specbzip_4', 'specbzip_5'};
benchmarks_specmcf = {'specmcf_0', 'specmcf_1', 'specmcf_2', 'specmcf_3', 'specmcf_4', 'specmcf_5'};
benchmarks_spechmmer = {'spechmmer_0', 'spechmmer_1', 'spechmmer_2', 'spechmmer_3', 'spechmmer_4', 'spechmmer_5'};
benchmarks_specsjeng = {'specsjeng_0', 'specsjeng_1', 'specsjeng_2', 'specsjeng_3', 'specsjeng_4'};
benchmarks_speclibm = {'speclibm_0', 'speclibm_1', 'speclibm_2', 'speclibm_3', 'speclibm_4'};

icache_overall_miss_rate_specbzip = [0.000077, 0.000077, 0.000077, 0.000077, 0.000077, 0.000077];
icache_overall_miss_rate_specmcf = [0.023612, 0.000018, 0.000018, 0.000018, 0.000018, 0.000018];
icache_overall_miss_rate_spechmmer = [0.000221, 0.000221, 0.000212, 0.000210, 0.000208, 0.000184];
icache_overall_miss_rate_specsjeng = [0.000020, 0.000020, 0.000020, 0.000020, 0.000015];
icache_overall_miss_rate_speclibm = [0.000094, 0.000094, 0.000094, 0.000094, 0.000112];

% Plot and save specbzip
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_specbzip), icache_overall_miss_rate_specbzip, 'green');
title('Icache\_overall\_miss\_rate for specbzip Benchmarks');
xlabel('Benchmark');
ylabel('icache\_overall\_miss\_rate');
set(gca, 'XTick', 1:length(benchmarks_specbzip), 'XTickLabel', benchmarks_specbzip);
ylim([0 max(icache_overall_miss_rate_specbzip)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'icache_misses_plot_specbzip.png'));
close;

% Plot and save specmcf
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_specmcf), icache_overall_miss_rate_specmcf, 'green');
title('Icache\_overall\_miss\_rate for specmcf Benchmarks');
xlabel('Benchmark');
ylabel('icache\_overall\_miss\_rate');
set(gca, 'XTick', 1:length(benchmarks_specmcf), 'XTickLabel', benchmarks_specmcf);
ylim([0 max(icache_overall_miss_rate_specmcf)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'icache_misses_plot_specmcf.png'));
close;

% Plot and save spechmmer
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_spechmmer), icache_overall_miss_rate_spechmmer, 'green');
title('Icache\_overall\_miss\_rate for spechmmer Benchmarks');
xlabel('Benchmark');
ylabel('icache\_overall\_miss\_rate');
set(gca, 'XTick', 1:length(benchmarks_spechmmer), 'XTickLabel', benchmarks_spechmmer);
ylim([0 max(icache_overall_miss_rate_spechmmer)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'icache_misses_plot_spechmmer.png'));
close;

% Plot and save specsjeng  
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_specsjeng), icache_overall_miss_rate_specsjeng, 'green');
title('Icache\_overall\_miss\_rate for specsjeng Benchmarks');
xlabel('Benchmark');
ylabel('icache\_overall\_miss\_rate');
set(gca, 'XTick', 1:length(benchmarks_specsjeng), 'XTickLabel', benchmarks_specsjeng);
ylim([0 max(icache_overall_miss_rate_specsjeng)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'icache_misses_plot_specsjeng.png'));
close;

% Plot and save speclibm
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_speclibm), icache_overall_miss_rate_speclibm, 'green');
title('Icache\_overall\_miss\_rate for speclibm Benchmarks');
xlabel('Benchmark');
ylabel('icache\_overall\_miss\_rate');
set(gca, 'XTick', 1:length(benchmarks_speclibm), 'XTickLabel', benchmarks_speclibm);
ylim([0 max(icache_overall_miss_rate_speclibm)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'icache_misses_plot_speclibm.png'));
close;