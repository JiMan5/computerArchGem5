% Create folder for graphs
output_folder = 'cpi_graphs';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Data
benchmarks_specbzip = {'specbzip_0', 'specbzip_1', 'specbzip_2', 'specbzip_3', 'specbzip_4', 'specbzip_5'};
benchmarks_specmcf = {'specmcf_0', 'specmcf_1', 'specmcf_2', 'specmcf_3', 'specmcf_4', 'specmcf_5'};
benchmarks_spechmmer = {'spechmmer_0', 'spechmmer_1', 'spechmmer_2', 'spechmmer_3', 'spechmmer_4', 'spechmmer_5'};
benchmarks_specsjeng = {'specsjeng_0', 'specsjeng_1', 'specsjeng_2', 'specsjeng_3', 'specsjeng_4'};
benchmarks_speclibm = {'speclibm_0', 'speclibm_1', 'speclibm_2', 'speclibm_3', 'speclibm_4'};

cpi_specbzip = [1.712208, 1.682914, 1.649604, 1.624885, 1.617195, 1.610993];
cpi_specmcf = [1.303750, 1.160209, 1.155606, 1.155199, 1.155043, 1.155043];
cpi_spechmmer = [1.191346, 1.187917, 1.186170, 1.185883, 1.185423, 1.191663];
cpi_specsjeng = [10.270554, 10.270520, 10.265530, 10.265417, 6.794691];
cpi_speclibm = [3.493415, 3.493415, 3.489639, 3.489639, 2.576667];

% Plot and save specbzip
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_specbzip), cpi_specbzip, 'red');
title('CPI for specbzip Benchmarks');
xlabel('Benchmark');
ylabel('CPI');
set(gca, 'XTick', 1:length(benchmarks_specbzip), 'XTickLabel', benchmarks_specbzip);
ylim([0 max(cpi_specbzip)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'cpi_plot_specbzip.png'));
close;

% Plot and save specmcf
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_specmcf), cpi_specmcf, 'red');
title('CPI for specmcf Benchmarks');
xlabel('Benchmark');
ylabel('CPI');
set(gca, 'XTick', 1:length(benchmarks_specmcf), 'XTickLabel', benchmarks_specmcf);
ylim([0 max(cpi_specmcf)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'cpi_plot_specmcf.png'));
close;

% Plot and save spechmmer
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_spechmmer), cpi_spechmmer, 'red');
title('CPI for spechmmer Benchmarks');
xlabel('Benchmark');
ylabel('CPI');
set(gca, 'XTick', 1:length(benchmarks_spechmmer), 'XTickLabel', benchmarks_spechmmer);
ylim([0 max(cpi_spechmmer)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'cpi_plot_spechmmer.png'));
close;

% Plot and save specsjeng
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_specsjeng), cpi_specsjeng, 'red');
title('CPI for specsjeng Benchmarks');
xlabel('Benchmark');
ylabel('CPI');
set(gca, 'XTick', 1:length(benchmarks_specsjeng), 'XTickLabel', benchmarks_specsjeng);
ylim([0 max(cpi_specsjeng)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'cpi_plot_specsjeng.png'));
close;

% Plot and save speclibm
figure('Position', [100 100 800 500]);
bar(1:length(benchmarks_speclibm), cpi_speclibm, 'red');
title('CPI for speclibm Benchmarks');
xlabel('Benchmark');
ylabel('CPI');
set(gca, 'XTick', 1:length(benchmarks_speclibm), 'XTickLabel', benchmarks_speclibm);
ylim([0 max(cpi_speclibm)*1.2]);
xtickangle(45);
grid on;
saveas(gcf, fullfile(output_folder, 'cpi_plot_speclibm.png'));
close;