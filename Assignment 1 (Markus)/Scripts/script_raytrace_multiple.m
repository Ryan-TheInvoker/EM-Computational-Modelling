clc


maxdist = (2*parameters.alt);
maxdist = 1200000;

for angles = linspace(0,0.499*pi,10)

    alpha0 = angles;
    x0 = 0;
    z0 = 0;
    sinalpha0 = sin(alpha0);
    freq = 12.6*2e6;
    
    N = 1000000;
    
    zmax = altitude_of_reflection(z0, sinalpha0,freq, parameters);
    
    
    if zmax > maxdist
        zmax = maxdist;
        [x,z,sinalpha] = trace_ray(x0, z0, zmax, sinalpha0, freq, N, parameters);
    else
        [x,z,sinalpha] = trace_ray(x0, z0, zmax, sinalpha0, freq, N, parameters);
        x = [x, 2*x(end) - fliplr(x)]; %stitches onto symmetry
        z = [z, fliplr(z)];
    end

    inside = x < maxdist & z < maxdist;
    x = x(inside);
    z = z(inside);

    plot(x/1000,z/1000, Color = 'black')
    hold on;
    axis equal
    axis tight

    xlim([0,maxdist/1000]);
    ylim([0,maxdist/1000])
    ylabel('Altitude (km)', 'Interpreter', 'latex', 'fontsize', 10);
    xlabel('Horizontal distance (km)', 'Interpreter', 'latex', 'fontsize', 10);
    
    title('$f$ = ??? MHz', 'Interpreter', 'latex', 'fontsize', 10)

    set(groot, 'DefaultFigureUnits', 'centimeters');
    set(groot, 'DefaultFigurePosition', [10, 10, 2,2]); % [left, bottom, width, height]

    

    

end

