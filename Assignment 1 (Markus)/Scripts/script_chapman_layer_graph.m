

%Set plot range
z_range = parameters.H*linspace(0,20,1000);


%Generate Chapman Electron Density Profile data
electron_density_profile = electron_density(parameters, z_range);
[max_val, index_of_max] = max(electron_density_profile);
electron_density_maximum = max_val;
altitude_of_density_max = z_range(index_of_max);

%Generate Plasma Frequency Density Profile data

electron_plasma_frequency_profile = electron_plasma_frequency(parameters, z_range);
[maxval, index_of_max] = max(electron_plasma_frequency_profile);
altitude_of_plasma_max_frequency = z_range(index_of_max);
electron_plasma_frequency_max = maxval;

%Generate double y-axis graps for
%density and frequency



set(0,'DefaultAxesFontSize', 11);
set(0,'DefaultFigureColor','w');
set(0,'defaulttextinterpreter','tex');
set(0,'DefaultAxesFontName','times');
set(0,'DefaultLineLineWidth', 1.2);
set(0,'defaultAxesLabelFontSizeMultiplier', 1.1);

dual_fig = figure(2);
set(gcf, 'Units', 'centimeters')
set(gcf, 'Position', [0 0 8.89 6])
yyaxis left
plot(z_range/1000,electron_density_profile, ...
    DisplayName = "Plasma density", ...
    Color='black', LineStyle ='-');
yticks([0 0.5e12 1e12 1.5e12 2e12])
ylabel("Plasma density (m^{-3})", FontSize=14)

ax = gca;
ax.YColor = 'black';

yyaxis right
plot(z_range/1000, electron_plasma_frequency_profile/1e6, ...
    DisplayName = "Electron plasma frequency", ...
    Color='black', LineStyle =':');
ylabel("Electron plasma frequency (MHz)", FontSize=14)
xlabel("Altitude (km)", FontSize=14)
legend show

ax = gca;
ax.YColor = 'black';

%title("Chapman layer")
legend show;

disp(" ")
disp('====================================');
disp('===  script_chapman_layer_graph  ===');
disp('====================================');
disp("Data computed from the model series data");
disp("Altitude of maximal (electron) density: " + altitude_of_density_max / 1000 + " km");
disp("Magnitude of maximal density " + electron_density_maximum + " m^{-3}");
disp("Altitude of maximal plasma frequency: " + altitude_of_plasma_max_frequency / 1000 + " km");
disp("Maximum plasma frequency: " + electron_plasma_frequency_max / 1e6 + " MHz");

exportgraphics(dual_fig, 'chapman_layer.pdf', 'ContentType', 'vector');
exportgraphics(dual_fig, 'chapman_layer.png', 'Resolution', 500);