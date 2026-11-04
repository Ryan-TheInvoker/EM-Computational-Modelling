function [x,z, sinalpha] = trace_ray(x0, z0, zmax, sinalpha0, freq, N, parameters)

x = zeros(1, N);
z = linspace(z0, zmax, N);
zavg = (z(1:end-1) + z(2:end)) / 2;
dz = diff(z);

sinalpha = index_of_refraction(parameters, z0, freq) * sinalpha0 ./ index_of_refraction(parameters, zavg, freq);

dx = dz.*sinalpha0./sqrt(1 - sinalpha.^2);

x(2:end) = x0 + cumsum(dx);
sinalpha = [sinalpha0, sinalpha];

return