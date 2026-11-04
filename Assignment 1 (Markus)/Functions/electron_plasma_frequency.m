%assumed the parameters are global and loaded
function  f_pe = electron_plasma_frequency(parameters, z)
f_pe = sqrt(electron_density(parameters, z)*parameters.q*parameters.q ...
    / (parameters.epsilon0 * parameters.me))/(2*pi());
return;