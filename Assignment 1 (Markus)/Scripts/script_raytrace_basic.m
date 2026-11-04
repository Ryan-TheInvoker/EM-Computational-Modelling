clc


%Initial conditions

alpha0 = pi/4;
x0 = 0;
z0 = 0;
freq = 14e6

sinalpha0 = sin(alpha0)

zmax = parameters.alt*3;

%The raytracer only integrates between two z-cooordinates and
%cannot reverse direction. If you want to trace back to ground
%but appending a mirror set the parameter below to true

trace_back_to_ground = true;

%Number of layers
N = 100000


%Computes the altitude at which
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

%Plot code

plot(x/1000,z/1000,   Color = 'black')
xlabel('Horizontal distance (km)')
ylabel('Altitude (km)')
title(sprintf('$\\alpha_0$ = %.1f$^\\circ$, $f$ = %.1f MHz', (180/pi)*alpha0, freq/1e6))
grid on
axis equal