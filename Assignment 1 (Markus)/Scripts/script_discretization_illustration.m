clc
alpha0 = pi/4;
x0 = 0;
z0 = 0;
sinalpha0 = sin(alpha0)
freq = 18e6

z_max = 10*parameters.H;

N = 5000
z = linspace(0,z_max,N);
sinalfa = [sinalpha0, zeros(0,N-1)];
x = [x0, zeros(0,N-1)];

for k = 2:N
    sinalfa(k) = sinalpha0 / index_of_refraction(parameters, (z(k) + z(k-1))/2, freq);
    x(k) = x(k-1) + (z(k) - z(k-1)) * sinalfa(k-1) / sqrt(1 - sinalfa(k)^2);
end

x_max = max(x);

hold on;

%The code below was heavily claude assisted and I have not bothered
%to check it as its just graphics



zc = (z(1:end-1) + z(2:end))/2;     % layer centers (N-1 of them)
nc = n(zc(:));                      % one index value per layer

xe = [0 x_max];                     % horizontal edges (stratified, so one column)
[Xe, Ze] = meshgrid(xe, z);         % corner grid, size N x 2

C = nan(N, 2);                      % pcolor needs corner-sized data
C(1:end-1, 1) = nc;                 % layer value goes to its lower-left corner

hold on


pcolor(Xe/1000, Ze/1000, C);
shading flat
colormap(gray); colorbar;

plot(x/1000, z/1000, 'black', 'LineWidth', 2);
xlabel('Horizontal distance (km)', 'Interpreter', 'latex');
ylabel('Altitude [km]', 'Interpreter', 'latex');
axis tight
hold off

g = linspace(0.5, 1, ng)';        % dark gray -> white
colormap([g g g]);
c = colorbar;
c.Label.String = '$n$ (index of refraction)';
c.Label.Interpreter = 'latex';
c.Label.FontSize = 12;