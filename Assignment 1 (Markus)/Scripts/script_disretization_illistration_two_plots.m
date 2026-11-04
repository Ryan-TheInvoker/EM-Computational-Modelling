clc

two_discretization_plots = figure(5);

alpha0 = pi/4;
freq   = 18e6;
z_max  = 10*parameters.H;
n      = @(z) index_of_refraction(parameters, z, freq);

% Shared gray ramp: dark gray -> white
ng = 256;
g  = linspace(0.5, 1, ng)';
cmap = [g g g];

t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

ax1 = nexttile;
r1 = trace_and_draw(ax1, parameters, n, freq, alpha0, z_max, 8);
title(ax1, 'Discretized', 'Interpreter', 'latex');
xlabel(ax1, 'Horizontal distance (km)', 'Interpreter', 'latex');

ax2 = nexttile;
r2 = trace_and_draw(ax2, parameters, n, freq, alpha0, z_max, 5000);
title(ax2, 'Non-discretized', 'Interpreter', 'latex');
xlabel(ax2, 'Horizontal distance (km)', 'Interpreter', 'latex');

% Shared altitude axis
ylabel(t, 'Altitude (km)', 'Interpreter', 'latex', 'fontsize', 9);
linkaxes([ax1 ax2], 'y');
ax2.YTickLabel = [];

% Shared color scale and colorbar
colormap(t.Parent, cmap);
clim_range = [min(r1(1), r2(1)), max(r1(2), r2(2))];
clim(ax1, clim_range);
clim(ax2, clim_range);

c = colorbar(ax2);
c.Layout.Tile = 'east';
c.Label.String = 'Index of refraction';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 10;

% ---------------------------------------------------------------
function range_n = trace_and_draw(ax, parameters, n, freq, alpha0, z_max, N)
    z = linspace(0, z_max, N);
    sinalpha0 = sin(alpha0);
    sinalfa = [sinalpha0, zeros(1, N-1)];
    x = zeros(1, N);
    for k = 2:N
        sinalfa(k) = sinalpha0 / index_of_refraction(parameters, (z(k) + z(k-1))/2, freq);
        x(k) = x(k-1) + (z(k) - z(k-1)) * sinalfa(k-1) / sqrt(1 - sinalfa(k)^2);
    end
    x_max = max(x);

    % Layer values (one per layer, evaluated at the layer center)
    zc = (z(1:end-1) + z(2:end))/2;
    nc = n(zc(:));

    % pcolor wants corner-sized data; the last row is never drawn
    [Xe, Ze] = meshgrid([0 x_max], z);
    C = nan(N, 2);
    C(1:end-1, 1) = nc;

    hold(ax, 'on');
    pcolor(ax, Xe/1000, Ze/1000, C);
    shading(ax, 'flat');
    plot(ax, x/1000, z/1000, 'k', 'LineWidth', 2);
    axis(ax, 'tight');
    hold(ax, 'off');

    range_n = [min(nc), max(nc)];
end

exportgraphics(two_discretization_plots, 'two_discretizations.png', 'Resolution', 500);