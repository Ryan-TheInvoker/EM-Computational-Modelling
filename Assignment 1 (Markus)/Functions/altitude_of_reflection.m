%Checks if n^2 - n0^2 sinalpha0^2 has a sign change in which case there
%is a reflection and 
%code does not handle the case of perfect symmetry so let us hope it
%doesn't happen :|
function zmax = altitude_of_reflection(z0, sinalpha0, freq, parameters)

f = @(z) index_of_refraction_squared(parameters, z, freq) - index_of_refraction_squared(parameters, z0, freq).*sinalpha0.^2;

opts = optimset('TolX', 1e-12);

if f(z0)*f(parameters.alt)<0
    zmax = fzero(f, [z0, parameters.alt], opts);
else
    zmax = inf;

end
return;