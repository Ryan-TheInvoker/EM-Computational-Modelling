function nsq = index_of_refraction_squared(parameters, z, frequency)
    nsq = 1 - electron_plasma_frequency(parameters, z).^2 ./ frequency.^2;
    return;