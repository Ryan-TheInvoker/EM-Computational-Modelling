clc
figure(5)

%Initial conditions
alpha0 = pi/4;
x0 = 0;
z0 = 0;
freq = 14e6
sinalpha0 = sin(alpha0)
zmax = parameters.alt*3;

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
    [x,z,sinalpha] = trace_ray(x0, z0, zmax, sinalpha0, freq, N, parameters);
    x = [x, 2*x(end) - fliplr(x)];   % stitch onto symmetry
    z = [z, fliplr(z)];
end

%Plot color bar for index of refraction squared
n = @(z) index_of_refraction_squared(parameters, z, freq);
width = max(max(x), max(z))*10;
z_range = linspace(0,width,1000);
zc = (z_range(1:end-1) + z_range(2:end))/2;      % layer centers
nc = n(zc(:));                       % one value per layer
[X, Z] = meshgrid([x(1) x(end)], z_range);
C = nan(numel(z_range), 2);
C(1:end-1, 1) = nc;                  % last row is never drawn by pcolor
pcolor(X/1000, Z/1000, C);
shading flat
axis tight

% Colormap: 0 -> white, +1 -> intense blue, negative -> white to intense red
cmin = min(min(nc), 0);              % most negative value (0 if none)
v    = linspace(cmin, 1, 256)';      % values the 256 colors represent
blue = [0 0.2 0.8];                  % intense blue
red  = [0.8 0 0];                    % intense red
cmap = ones(256, 3);                 % start with white
pos  = v >= 0;
neg  = v < 0;
cmap(pos,:) = (1 - v(pos)) * [1 1 1] + v(pos) * blue;
if any(neg)
    s = v(neg) / cmin;               % 0 at zero, 1 at most negative value
    cmap(neg,:) = (1 - s) * [1 1 1] + s * red;
end
colormap(cmap)
clim([cmin 1])
cb = colorbar;
cb.Label.String = '$n^2$';

%Ray curve
hold on;
plot(x/1000,z/1000,   Color = 'black')
xlabel('Horizontal distance (km)')
ylabel('Altitude (km)')
title(sprintf('$\\alpha_0$ = %.1f$^\\circ$, $f$ = %.1f MHz', (180/pi)*alpha0, freq/1e6))
grid on
axis equal
axis tight