index_of_refraction_fig = figure(3)
%Set plot range
z_range = parameters.H*linspace(0,20,1000);

maximal_plasma_frequency = parameters.fpmax;


%Generate Chapman Electron Density Profile data
rescale = 1.25;
n_sq = index_of_refraction_squared(parameters, z_range, rescale*maximal_plasma_frequency);
plot(z_range/1000, n_sq, DisplayName= rescale + "$\cdot f_{\text{pe,max}}$", ...
    Color = 'black', LineStyle =':')

hold on

rescale = 1;
n_sq = index_of_refraction_squared(parameters, z_range, rescale*maximal_plasma_frequency);
plot(z_range/1000, n_sq, DisplayName="$1.00\cdot f_{\text{pe,max}}$", ...
    Color = 'black', LineStyle ='-')

hold on

rescale = 0.75;
n_sq = index_of_refraction_squared(parameters, z_range, rescale*maximal_plasma_frequency);
plot(z_range/1000, n_sq, DisplayName= rescale + "$\cdot f_{\text{pe,max}}$", ...
    Color = 'black', LineStyle ='--')

ylabel("(Index of Refraction)$^2$")
xlabel("Altitude (km)")
grid off
yline(0, 'k-', 'LineWidth', 1, HandleVisibility='off');

legend show;

hold off

exportgraphics(index_of_refraction_fig, 'index_of_refraction.png', 'Resolution', 500);

