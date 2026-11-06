clc
maxdist = 1200000;
freqs   = [12.6 25.2 50.4]*1e6;      % one frequency per subplot (Hz)
angles  = linspace(0, 0.499*pi, 10);
N       = 1000000;
x0 = 0;  z0 = 0;
fs = 10;                             % font size used everywhere

% ---- Figure: 12 cm wide ----
figW = 12;  figH = 6.5;              % cm
fig = figure('WindowStyle','normal', 'Units','centimeters', ...
             'Position',[5 5 figW figH], ...
             'PaperUnits','centimeters', 'PaperSize',[figW figH], ...
             'PaperPosition',[0 0 figW figH], ...
             'Resize','off');
drawnow;
fig.Position(3:4) = [figW figH];

tl = tiledlayout(fig, 1, 3, 'TileSpacing','compact', 'Padding','compact');

for k = 1:numel(freqs)
    freq = freqs(k);
    ax = nexttile(tl);
    hold(ax, 'on');

    for alpha0 = angles
        sinalpha0 = sin(alpha0);
        zmax = altitude_of_reflection(z0, sinalpha0, freq, parameters);

        if zmax > maxdist
            zmax = maxdist;
            [x,z,sinalpha] = trace_ray(x0, z0, zmax, sinalpha0, freq, N, parameters);
        else
            [x,z,sinalpha] = trace_ray(x0, z0, zmax, sinalpha0, freq, N, parameters);
            x = [x, 2*x(end) - fliplr(x)];   % stitch onto symmetry
            z = [z, fliplr(z)];
        end

        inside = x < maxdist & z < maxdist;
        plot(ax, x(inside)/1000, z(inside)/1000, 'Color','black');
    end

    axis(ax, 'equal');
    xlim(ax, [0, maxdist/1000]);
    ylim(ax, [0, maxdist/1000]);
    xticks(ax, 0:400:1200);          % fewer ticks so 10 pt labels don't overlap
    ax.FontSize = fs;
    xtickangle(ax, 0);
    ax.TickLabelInterpreter = 'latex';
    title(ax, sprintf('$f$ = %.1f MHz', freq/1e6), ...
          'Interpreter','latex', 'FontSize',fs);

    % Common y-axis: hide tick labels on tiles 2 and 3
    if k > 1
        ax.YTickLabel = [];
    end
end

% Shared axis labels
xlabel(tl, 'Horizontal distance (km)', 'Interpreter','latex', 'FontSize',fs);
ylabel(tl, 'Altitude (km)',            'Interpreter','latex', 'FontSize',fs);

% ---- Export ----
exportgraphics(fig, 'rays.pdf', 'ContentType','vector');
% exportgraphics(fig, 'rays.png', 'Resolution',600);