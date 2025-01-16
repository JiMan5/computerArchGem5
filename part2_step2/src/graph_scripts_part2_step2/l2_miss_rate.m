% Create folder for graphs
output_folder = 'l2_miss_graphs';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Data
benchmarks_specbzip = {'specbzip_0', 'specbzip_1', 'specbzip_2', 'specbzip_3', 'specbzip_4', 'specbzip_5'};
benchmarks_specmcf = {'specmcf_0', 'specmcf_1', 'specmcf_2', 'specmcf_3', 'specmcf_4', 'specmcf_5'};
benchmarks_spechmmer = {'spechmmer_0', 'spechmmer_1', 'spechmmer_2', 'spechmmer_3', 'spechmmer_4', 'spechmmer_5'};
benchmarks_specsjeng = {'specsjeng_0', 'specsjeng_1', 'specsjeng_2', 'specsjeng_3', 'specsjeng_4'};
benchmarks_speclibm = {'speclibm_0', 'speclibm_1', 'speclibm_2', 'speclibm_3', 'speclibm_4'};

l2_overall_miss_rate_specbzip = [0.322489, 0.414964, 0.363010, 0.324116, 0.350311, 0.376199];
l2_overall_miss_rate_specmcf = [0.059346, 0.767534, 0.711878, 0.706414, 0.706527, 0.706527];
l2_overall_miss_rate_spechmmer = [0.054065, 0.077760, 0.179990, 0.191371, 0.234873, 0.254200];
l2_overall_miss_rate_specsjeng = [0.999972, 0.999976, 0.999976, 0.999979, 0.999952];
l2_overall_miss_rate_speclibm = [0.999944, 0.999944, 0.999944, 0.999945, 0.999800];

% Plot and save specbzip
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_specbzip), l2_overall_miss_rate_specbzip, 'magenta');
title('L2\_overall\_miss\_rate for specbzip Benchmarks');
xlabel('Benchmark');
ylabel('l2\_overall\_miss\_rate');
set(gca, 'XTick', 1:length(benchmarks_specbzip), 'XTickLabel', benchmarks_specbzip);
ylim([0 max(l2_overall_miss_rate_specbzip)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'L2_plot_specbzip.png'));
close;

% Plot and save specmcf
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_specmcf), l2_overall_miss_rate_specmcf, 'magenta');
title('L2\_overall\_miss\_rate for specmcf Benchmarks');
xlabel('Benchmark');
ylabel('l2\_overall\_miss\_rate');
set(gca, 'XTick', 1:length(benchmarks_specmcf), 'XTickLabel', benchmarks_specmcf);
ylim([0 max(l2_overall_miss_rate_specmcf)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'L2_plot_specmcf.png'));
close;

% Plot and save spechmmer
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_spechmmer), l2_overall_miss_rate_spechmmer, 'magenta');
title('L2\_overall\_miss\_rate for spechmmer Benchmarks');
xlabel('Benchmark');
ylabel('l2\_overall\_miss\_rate');
set(gca, 'XTick', 1:length(benchmarks_spechmmer), 'XTickLabel', benchmarks_spechmmer);
ylim([0 max(l2_overall_miss_rate_spechmmer)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'L2_plot_spechmmer.png'));
close;

% Plot and save specsjeng
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_specsjeng), l2_overall_miss_rate_specsjeng, 'magenta');
title('L2\_overall\_miss\_rate for specsjeng Benchmarks');
xlabel('Benchmark');
ylabel('l2\_overall\_miss\_rate');
set(gca, 'XTick', 1:length(benchmarks_specsjeng), 'XTickLabel', benchmarks_specsjeng);
ylim([0 max(l2_overall_miss_rate_specsjeng)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'L2_plot_specsjeng.png'));
close;

% Plot and save speclibm
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_speclibm), l2_overall_miss_rate_speclibm, 'magenta');
title('L2\_overall\_miss\_rate for speclibm Benchmarks');
xlabel('Benchmark');
ylabel('l2\_overall\_miss\_rate');
set(gca, 'XTick', 1:length(benchmarks_speclibm), 'XTickLabel', benchmarks_speclibm);
ylim([0 max(l2_overall_miss_rate_speclibm)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'L2_plot_speclibm.png'));
close;