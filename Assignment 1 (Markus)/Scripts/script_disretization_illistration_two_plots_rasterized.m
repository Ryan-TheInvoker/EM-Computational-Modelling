clc
%Notice: The subplot DO NOT RESPECT DEFAULT FONTS
%It is maddening!!!!
two_discretization_plots = figure(5);
clf
alpha0 = pi/5;
freq   = 15.7e6;
z_max  = 10*parameters.H;
n      = @(z) index_of_refraction(parameters, z, freq);

% Absolute gray ramp: 0 = black, 1 = white
cmap = gray(256);

t = tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

ax1 = nexttile;
r1 = trace_and_draw(ax1, parameters, n, freq, alpha0, z_max, 6, 'patch');
title(ax1, 'Discretized', 'Interpreter', 'latex', 'fontsize', 10);
xlabel(ax1, 'Horizontal distance (km)', 'Interpreter', 'latex', 'fontsize', 10);

ax2 = nexttile;
r2 = trace_and_draw(ax2, parameters, n, freq, alpha0, z_max, 5000, 'image');
title(ax2, 'Continuous', 'Interpreter', 'latex', 'fontsize', 10);
xlabel(ax2, 'Horizontal distance (km)', 'Interpreter', 'latex', 'fontsize', 10);

% Shared altitude axis
ylabel(t, 'Altitude (km)', 'Interpreter', 'latex', 'fontsize', 10);
linkaxes([ax1 ax2], 'y');
ax2.YTickLabel = [];

% Shared color scale and colorbar
colormap(t.Parent, cmap);
clim(ax1, [0 1]);
clim(ax2, [0 1]);
c = colorbar(ax2);
c.Layout.Tile = 'east';
c.Label.String = 'Index of refraction';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 10;

% ---- Export: PDF, exactly 12 cm wide ----
two_discretization_plots.Units = 'centimeters';
two_discretization_plots.Position(3:4) = [12 5.5];
drawnow
outdir = fullfile(fileparts(mfilename('fullpath')), '..', 'Images');
if ~exist(outdir, 'dir'), mkdir(outdir); end
exportgraphics(two_discretization_plots, fullfile(outdir, 'two_discretizations.pdf'), ...
               'ContentType', 'vector', 'Padding', 'figure');

% ---------------------------------------------------------------
function range_n = trace_and_draw(ax, parameters, n, freq, alpha0, z_max, N, style)
    z = linspace(0, z_max, N);
    sinalpha0 = sin(alpha0);
    sinalfa = [sinalpha0, zeros(1, N-1)];
    x = zeros(1, N);
    for k = 2:N
        sinalfa(k) = sinalpha0 / index_of_refraction(parameters, (z(k) + z(k-1))/2, freq);
        x(k) = x(k-1) + (z(k) - z(k-1)) * sinalfa(k-1) / sqrt(1 - sinalfa(k)^2);
    end
    x_max = max(x);

    hold(ax, 'on');
    if strcmp(style, 'image')
        % High-resolution raster: n sampled on a fine altitude grid, drawn as one image.
        % Pixel centers are placed so the image edges land exactly on [0 x_max] and [0 z_max].
        Nimg = 4000;                                 % rows (vertical resolution)
        dz   = z_max / Nimg;
        zi   = ((1:Nimg) - 0.5) * dz;                % pixel centers in altitude
        ni   = n(zi(:));
        imagesc(ax, [0.25 0.75]*x_max/1000, [zi(1) zi(end)]/1000, [ni ni]);
        set(ax, 'YDir', 'normal')                    % imagesc flips the y-axis by default
        nc = ni;
    else
        % Layer values (one per layer, evaluated at the layer center)
        zc = (z(1:end-1) + z(2:end))/2;
        nc = n(zc(:));
        % pcolor wants corner-sized data; the last row is never drawn
        [Xe, Ze] = meshgrid([0 x_max], z);
        C = nan(N, 2);
        C(1:end-1, 1) = nc;
        pcolor(ax, Xe/1000, Ze/1000, C);
        shading(ax, 'flat');
    end

    plot(ax, x/1000, z/1000, 'k', 'LineWidth', 2);
    axis(ax, 'tight');
    hold(ax, 'off');
    axis equal
    range_n = [min(nc), max(nc)];
end