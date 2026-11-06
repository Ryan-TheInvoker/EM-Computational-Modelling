clc; clear; close all

% ---- Field on the unit square ----
[x, y] = meshgrid(linspace(0, 1, 400));
Z = cos(2*pi*y);

fig = figure('Units','centimeters', 'Position',[5 5 12 7]);
ax = axes(fig);
hold(ax, 'on')

% Positive part: grayscale, 0 = white, 1 = black. Negatives are clipped to 0, so they show as white.
imagesc(ax, x(1,:), y(:,1), max(Z, 0));
set(ax, 'YDir', 'normal')
colormap(ax, flipud(gray(256)))
clim(ax, [0 1])
cb = colorbar(ax);
cb.Label.String = 'z';

% Dashed line where z = 0
contour(ax, x, y, Z, [0 0], 'k--', 'LineWidth', 1, 'DisplayName', 'Zero index');

legend show

axis(ax, 'equal'); axis(ax, [0 1 0 1]); box(ax, 'on')
xlabel(ax, 'x'); ylabel(ax, 'y')