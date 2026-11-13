clc
two_discretization_plots = figure(5);
clf
alpha0 = pi/5;
freq   = 15.7e6;
z_max  = 10*parameters.H;
n      = @(z) index_of_refraction(parameters, z, freq);
N_disc = 6;          % number of layer boundaries in the discretized panels
N_cont = 5000;       % layers for the continuous ray
Nimg   = 4000;       % image rows for the continuous colormap

% Absolute gray ramp: 0 = black, 1 = white
cmap = gray(256);

% ---- Rays ----
[x_c, z_c] = compute_ray(parameters, freq, alpha0, z_max, N_cont);   % continuous
[x_d, z_d] = compute_ray(parameters, freq, alpha0, z_max, N_disc);   % discretized
dx  = diff(x_d);                                                     % horizontal step per layer
x_w = max(x_d);          % common width of every colormap strip (full discrete ray)

% First line segment (layer 1), shown in every panel
seg1_x = [0, dx(1)]/1000;
seg1_z = [z_d(1), z_d(2)]/1000;

% ---- Layout: 2x2 panels, separate y-axes, one colorbar ----
t = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% 1) Continuous: high-resolution image plus the first segment (top left)
ax1 = nexttile;
hold(ax1, 'on')
draw_image(ax1, n, z_max, x_w, Nimg);
plot(ax1, x_c/1000, z_c/1000, 'k:', 'LineWidth', 1);
plot(ax1, seg1_x, seg1_z, 'k', 'LineWidth', 1.5);
style_axes(ax1, '(a)');
ylabel(ax1, 'Altitude (km)', 'Interpreter', 'latex', 'fontsize', 10);

% 2) Discretization: layers plus the first segment (top right)
ax2 = nexttile;
hold(ax2, 'on')
draw_layers(ax2, n, z_d, x_w);
plot(ax2, seg1_x, seg1_z, 'k', 'LineWidth', 1.5);
style_axes(ax2, '(b)');

% 3) Construct orientation: layers plus ray segments, each starting at x = 0 (bottom left)
%    The first segment is the first of these, so it is already included.
ax3 = nexttile;
hold(ax3, 'on')
draw_layers(ax3, n, z_d, x_w);
Nseg = numel(dx);
Xs = [zeros(1, Nseg); dx;         nan(1, Nseg)];   % segment k: (0, z_k) -> (dx_k, z_k+1)
Zs = [z_d(1:end-1);   z_d(2:end); nan(1, Nseg)];
plot(ax3, Xs(:)/1000, Zs(:)/1000, 'k', 'LineWidth', 1.5);
style_axes(ax3, '(c)');
xlabel(ax3, 'Horizontal distance (km)', 'Interpreter', 'latex', 'fontsize', 10);
ylabel(ax3, 'Altitude (km)', 'Interpreter', 'latex', 'fontsize', 10);

% 4) Full ray: layers plus the connected ray (bottom right)
%    The first segment is the start of the ray, so it is already included.
ax4 = nexttile;
hold(ax4, 'on')
draw_layers(ax4, n, z_d, x_w);
plot(ax4, x_d/1000, z_d/1000, 'k', 'LineWidth', 1.5);
style_axes(ax4, '(d)');
xlabel(ax4, 'Horizontal distance (km)', 'Interpreter', 'latex', 'fontsize', 10);

% ---- Shared color scale and colorbar ----
colormap(t.Parent, cmap);
for ax = [ax1 ax2 ax3 ax4]
    clim(ax, [0 1]);
end
c = colorbar(ax4);
c.Layout.Tile = 'east';
c.Label.String = 'Index of refraction';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 10;

% ---- Export: PDF, exactly 12 cm wide ----
two_discretization_plots.Units = 'centimeters';
two_discretization_plots.Position(3:4) = [12 8];
drawnow
outdir = fullfile(fileparts(mfilename('fullpath')), '..', 'Images');
if ~exist(outdir, 'dir'), mkdir(outdir); end
exportgraphics(two_discretization_plots, fullfile(outdir, 'four_discretizations.pdf'), ...
               'ContentType', 'vector', 'Padding', 'figure');

% ---------------------------------------------------------------
function [x, z] = compute_ray(parameters, freq, alpha0, z_max, N)
    z = linspace(0, z_max, N);
    sinalpha0 = sin(alpha0);
    sinalfa = [sinalpha0, zeros(1, N-1)];
    x = zeros(1, N);
    for k = 2:N
        sinalfa(k) = sinalpha0 / index_of_refraction(parameters, (z(k) + z(k-1))/2, freq);
        x(k) = x(k-1) + (z(k) - z(k-1)) * sinalfa(k-1) / sqrt(1 - sinalfa(k)^2);
    end
end

function draw_layers(ax, n, z, x_max)
    % One flat-colored strip per layer, evaluated at the layer center
    zc = (z(1:end-1) + z(2:end))/2;
    nc = n(zc(:));
    [Xe, Ze] = meshgrid([0 x_max], z);
    C = nan(numel(z), 2);
    C(1:end-1, 1) = nc;                  % last row is never drawn by pcolor
    pcolor(ax, Xe/1000, Ze/1000, C);
    shading(ax, 'flat');
end

function draw_image(ax, n, z_max, x_max, Nimg)
    % High-resolution raster of n(z); pixel centers placed so the image edges
    % land exactly on [0 x_max] and [0 z_max]
    dz = z_max / Nimg;
    zi = ((1:Nimg) - 0.5) * dz;
    ni = n(zi(:));
    imagesc(ax, [0.25 0.75]*x_max/1000, [zi(1) zi(end)]/1000, [ni ni]);
    set(ax, 'YDir', 'normal')            % imagesc flips the y-axis by default
end

function style_axes(ax, ttl)
    axis(ax, 'tight');
    axis(ax, 'equal');
    hold(ax, 'off');
    title(ax, ttl, 'Interpreter', 'latex', 'fontsize', 10);
end