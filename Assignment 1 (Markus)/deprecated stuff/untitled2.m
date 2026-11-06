clc
figure(5)

%Initial conditions
alpha0 = 2*pi/3;
x0 = 0;
z0 = 0;
freq = 12e6
sinalpha0 = sin(alpha0)
zmax = parameters.alt*2;

%The raytracer only integrates between two z-coordinates and
%cannot reverse direction. If you want to trace back to ground
%by appending a mirror, set the parameter below to true
trace_back_to_ground = true;

%Number of layers
N = 100000

%Computes the altitude at which the ray reflects
zrefl = altitude_of_reflection(z0, sinalpha0, freq, parameters)
if zrefl == Inf
    trace_back_to_ground = false;
end
zmax = min(zrefl, zmax);

[x,z,sinalpha] = trace_ray(x0, z0, zmax, sinalpha0, freq, N, parameters);
if trace_back_to_ground
    x = [x, 2*x(end) - fliplr(x)];   % stitch onto symmetry
    z = [z, fliplr(z)];
end

%Index of refraction squared as a function of altitude
n2 = @(z) index_of_refraction_squared(parameters, z, freq);
width = max(max(x), max(z));
z_range = linspace(0, width, 1000);
zc = (z_range(1:end-1) + z_range(2:end))/2;      % layer centers
n2c = n2(zc(:));                                 % n^2, one value per layer
nre = sqrt(max( n2c, 0));                        % real index, 0 where n^2 < 0
nim = sqrt(max(-n2c, 0));                        % imaginary part, 0 where n^2 > 0

hold on;
xs = [x(1) x(end)]/1000;
step = 0.25;

%Contour lines of the real index (n^2 > 0), labeled 0.25, 0.5, ...
levels = step:step:max(nre);
if ~isempty(levels)
    [Cn, hn] = contour(xs, zc/1000, [nre nre], levels, 'k-', 'LineWidth', 0.5);
    clabel(Cn, hn, 'FontSize', 8, 'Color', 'k');
end

%Contour lines of the imaginary index (n^2 < 0), labeled 0.25i, 0.5i, ...
levels_im = step:step:max(nim);
if ~isempty(levels_im)
    [Ci, hi] = contour(xs, zc/1000, [nim nim], levels_im, 'k-', 'LineWidth', 0.5);
    ti = clabel(Ci, hi, 'FontSize', 8, 'Color', 'k');
    for k = 1:numel(ti)
        if isgraphics(ti(k), 'text')
            ti(k).String = [ti(k).String 'i'];   % append the imaginary unit
        end
    end
end

%Contour line where n^2 = 0
[~, hz] = contour(xs, zc/1000, [n2c n2c], [0 0], 'k:', ...
                  'LineWidth', 1, 'DisplayName', 'Zero index');

%Ray curve
hr = plot(x/1000, z/1000, Color = 'black', DisplayName='Ray');

xlabel('Horizontal distance (km)')
ylabel('Altitude (km)')
title(sprintf('$\\alpha_0$ = %.1f$^\\circ$, $f$ = %.1f MHz', (180/pi)*alpha0, freq/1e6))
legend([hz hr])        % explicit handles, so the index contours stay out of the legend
grid on
axis equal
axis tight