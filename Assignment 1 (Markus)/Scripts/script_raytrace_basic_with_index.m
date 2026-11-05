close all
figure(5)
hold off

%Initial conditions
alpha0 = 0.4*pi;
x0 = 0;
z0 = 0;
freq = 5e6
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
nc = sqrt(max(n2c, 0));                          % index, 0 where n^2 < 0

%Colormap of the index (0 = white, 1 = gray)
[X, Z] = meshgrid([x(1) x(end)], z_range);
C = nan(numel(z_range), 2);
C(1:end-1, 1) = nc;                  % last row is never drawn by pcolor
pcolor(X/1000, Z/1000, C, DisplayName="Index of refraction");
shading flat
axis tight
colormap(repmat(linspace(0, 1, 256)', 1, 3))   % white -> gray
clim([0 1])
cb = colorbar;
cb.Label.String = 'Index of refraction';

%Contour line where n^2 = 0
hold on;
contour([x(1) x(end)]/1000, zc/1000, [n2c n2c], [0 0], 'Linestyle',':', ...
        'LineWidth', 1, 'Color', [0.5 0.5 0.5], 'DisplayName', 'Zero index');

%Ray curve
plot(x/1000, z/1000, Color = 'black', DisplayName='Ray')
xlabel('Horizontal distance (km)')
ylabel('Altitude (km)')
title(sprintf('$\\alpha_0$ = %.1f$^\\circ$, $f$ = %.1f MHz', (180/pi)*alpha0, freq/1e6))
legend show
grid on
axis equal
axis tight