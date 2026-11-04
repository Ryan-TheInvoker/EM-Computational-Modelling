function n = index_of_refraction(parameters, z, frequency)
    n = sqrt(index_of_refraction_squared(parameters, z, frequency));
    return;