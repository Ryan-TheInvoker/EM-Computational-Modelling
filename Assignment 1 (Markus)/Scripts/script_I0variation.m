clc
clf


setup_global_parameters;

set(0,'DefaultAxesFontSize', 11);
set(0,'DefaultFigureColor','w');
set(0,'defaulttextinterpreter','tex');
set(0,'DefaultAxesFontName','times');
set(0,'DefaultLineLineWidth', 1.2);
set(0,'defaultAxesLabelFontSizeMultiplier', 1.1);
set(0, 'DefaultAxesTickLabelInterpreter', 'tex')

figure('Position', [0, 0, 12, 8]);

set(gcf, 'Units', 'centimeters')
set(gcf, 'Position', [0 0 8.89 6])

multiplier = [1,5,10]
I0_vals = [parameters.I0, parameters.I0, parameters.I0].*multiplier;

%This renders the atmosphere model insoncistent so be careful

line_styles = ["-";":";"--"];


for k = [1,2,3]

    %Initial conditions

    alpha0 = (pi/180)*parameters.alpha;
    x0 = 0;
    z0 = 0;
    freq = parameters.f;

    parameters.I0 = I0_vals(k)

    sinalpha0 = sin(alpha0);

    zmax = parameters.alt*3;

    %The raytracer only integrates between two z-cooordinates and
    %cannot reverse direction. If you want to trace back to ground
    %but appending a mirror set the parameter below to true

    trace_back_to_ground = true;

    %Number of layers
    N = 1000000;


    %Computes the altitude at which ray becomes horizontal
    zrefl = altitude_of_reflection(z0, sinalpha0,freq, parameters)

    if zrefl == Inf
        trace_back_to_ground = false;
    end

    zmax = min(zrefl, zmax);

    [x,z,sinalpha] = trace_ray(x0, z0, zmax, sinalpha0, freq, N, parameters);


    if trace_back_to_ground
        [x,z,sinalpha] = trace_ray(x0, z0, zmax, sinalpha0, freq, N, parameters);
        x = [x, 2*x(end) - fliplr(x)];   % stitch onto symmetry
        z = [z, fliplr(z)];
    end

    %Ray curve

    hold on;


    plot(x/1000,z/1000, ...
        Color = 'black', ...
        DisplayName=sprintf('%.1f $I_0$', multiplier(k)), ...
        LineStyle= line_styles(k))
    hold on
    xlabel('Horizontal distance (km)')
    ylabel('Altitude (km)')
    %title(sprintf('$\\alpha_0$ = %.1f$^\\circ$, $f$ = %.1f MHz', (180/pi)*alpha0, freq/1e6))
    grid on
    legend show

    axis equal
    %axis tight

end

axis([0 400 0 250])
xticks([0 100 200 300 400])
yticks([0 50 100 150 200 250])