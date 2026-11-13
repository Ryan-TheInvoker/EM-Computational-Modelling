
clf

set(0,'DefaultAxesFontSize', 11);
set(0,'DefaultFigureColor','w');
set(0,'defaulttextinterpreter','tex');
set(0,'DefaultAxesFontName','times');
set(0,'DefaultLineLineWidth', 1.2);
set(0,'defaultAxesLabelFontSizeMultiplier', 1.1);
set(0, 'DefaultAxesTickLabelInterpreter', 'tex')

figure(5)
set(gcf, 'Units', 'centimeters')
set(gcf, 'Position', [0 0 8.89 6])

%Initial conditions

alpha0 = (pi/180)*parameters.alpha;
x0 = 0;
z0 = 0;
freq = parameters.f;

sinalpha0 = sin(alpha0);

zmax = parameters.alt*3;

%The raytracer only integrates between two z-cooordinates and
%cannot reverse direction. If you want to trace back to ground
%but appending a mirror set the parameter below to true

trace_back_to_ground = true;

%Number of layers (note at 1000000000 it eats all my ram)
N = 100000000;

%Computes the altitude at which ray becomes horizontal
zrefl = altitude_of_reflection(z0, sinalpha0,freq, parameters);

if zrefl == Inf
    trace_back_to_ground = false;
end

zmax = min(zrefl, zmax);

[x,z,sinalpha] = trace_ray(x0, z0, zmax, sinalpha0, freq, N, parameters);


if trace_back_to_ground
    x = [x, 2*x(end) - fliplr(x)];   % stitch onto symmetry
    z = [z, fliplr(z)];
end

%Ray curve

hold on;


plot(x/1000,z/1000,   Color = 'black', DisplayName = 'Ray trace')
hold on
xlabel('Horizontal distance (km)')
ylabel('Altitude (km)')
%title(sprintf('$\\alpha_0$ = %.1f$^\\circ$, $f$ = %.1f MHz', (180/pi)*alpha0, freq/1e6))
grid on


y_straight = [0,zmax, 0]/1000;
x_straight = [0,zmax*tan(alpha0), 2*zmax*tan(alpha0)]/1000;
plot(x_straight, y_straight, Color = 'black', LineStyle=':', DisplayName = 'Estimate')
axis([0 400 0 250])

disp(' ')
disp('Using ' + string(N) + ' layers we get')
disp('Height ' + string(zmax/1000) + " km" )
disp('xmax ' + string(x(end)/1000) + " km" )


disp('Alfamax ' + string(asin(sinalpha(end))*(180/pi)) + " deg" )

axis equal
axis([0 400 0 250])
xticks([0 100 200 300 350 383.795 400])
xticklabels({"0", "100", "200", "300", "350", "x_{rec}"})

yticks([0 50 100 150 203.3760742254406 250])
yticklabels({"0", "50", "100", "150", "z_{refl}", "250"})
legend({'Ray trace', 'Estimate'})