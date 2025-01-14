%data here
data = struct(...
    'Benchmark', {'specbzip', 'specmcf', 'spechmmer', 'specsjeng', 'speclibm'}, ...
    'sim_seconds', [0.083982, 0.064955, 0.059396, 0.513528, 0.174671], ...
    'system_cpu_cpi', [1.679650, 1.299095, 1.187917, 10.270554, 3.493415], ...
    'system_cpu_dcache_overall_miss_rate_total', [0.014798, 0.002108, 0.001637, 0.121831, 0.060972], ...
    'system_cpu_icache_overall_miss_rate_total', [0.000077, 0.023612, 0.000221, 0.000020, 0.000094], ...
    'system_l2_overall_miss_rate_total', [0.282163, 0.055046, 0.077760, 0.999972, 0.999944] ...
);

%easier form to handle
Benchmarks = data.Benchmark;
sim_seconds = data.sim_seconds;
system_cpu_cpi = data.system_cpu_cpi;
system_cpu_dcache_overall_miss_rate_total = data.system_cpu_dcache_overall_miss_rate_total;
system_cpu_icache_overall_miss_rate_total = data.system_cpu_icache_overall_miss_rate_total;
system_l2_overall_miss_rate_total = data.system_l2_overall_miss_rate_total;

%directory for graphs
graphs_part2_q2 = 'graphs_part2_q2';
if ~exist(graphs_part2_q2, 'dir')
    mkdir(graphs_part2_q2);
end

% metrics for plotting
metrics = {'sim_seconds', 'system_cpu_cpi', 'system_cpu_dcache_overall_miss_rate_total', ...
    'system_cpu_icache_overall_miss_rate_total', 'system_l2_overall_miss_rate_total'};

metric_data = {sim_seconds, system_cpu_cpi, system_cpu_dcache_overall_miss_rate_total, ...
    system_cpu_icache_overall_miss_rate_total, system_l2_overall_miss_rate_total};

% create diagrams
for i = 1:length(metrics)
    figure('Visible', 'off');
    % Create bar plot with specific positions
    bar(1:5, metric_data{i});
    title(metrics{i}, 'Interpreter', 'none');
    ylabel('Value');
    
    % Fix: Set x-axis properties with correct benchmark names
    ax = gca;
    ax.XLim = [0.5 5.5];
    ax.XTick = 1:5;
    % Explicitly list the benchmark names in the correct order
    ax.XTickLabel = {'specbzip', 'specmcf', 'spechmmer', 'specsjeng', 'speclibm'};
    
    xtickangle(45);
    
    % save graph
    output_file = fullfile(graphs_part2_q2, [strrep(metrics{i}, '.', '_'), '.png']);
    saveas(gcf, output_file);
    close(gcf);
end

disp('Success!');

