function  [aa ai ar I0 n0 T f alpha] = get_parameters(birthdate)

rng(birthdate);

g = 9.81;          
kB = 1.38e-23;     
q = 1.60e-19;     
epsilon0 = 8.85e-12;   
me = 9.1e-31;     
mp = 1.67e-27;
mO = 16*mp; 
p = 1e5;

aa = 8.0e-28 + (9.0e-28-8.0e-28)*rand;   
ai = 7.0e-26 + (11.0e-26-7.0e-26)*rand;   
ar = 0.5e-14 + (2.0e-14-0.5e-14)*rand;   
I0 = 1e14 + (2e14-1e14)*rand;
T = 1000 + (1500-1000)*rand;
n0 = 2e24 + (3e24-2e24)*rand;
alpha = 25 + (65-25)*rand;
 
H = kB*T/(mO*g) 
zmax = H*log(aa*n0*H)
nemax = sqrt(ai/ar*n0*exp(-zmax/H)*I0*exp(-H*aa*n0*exp(-zmax/H)))
fpemax = 1/(2*pi)*sqrt(nemax*q^2/(epsilon0*me));
%factor = random('unif',0.6,0.9); %Markus note: This line of code does not
%seem to do anything and throws errors in my version
factor = 0.6 + (0.9-0.6)*rand;
f = factor*fpemax;


disp(' ');
disp('====================================');
disp('======  Modelling parameters  ======');
disp('====================================');
disp('');
str = ['aa = ' num2str(aa,'%.2e') '    (m^2)'];
disp(str);
str = ['ai = ' num2str(ai,'%.2e') '    (m^2)'];
disp(str);
str = ['ar = ' num2str(ar,'%.2e') '    (m^3 s^-1)'];
disp(str);
str = ['I0 = ' num2str(I0,'%.2e') '    (photons m^-2 s^-1)'];
disp(str);
str = ['n0 = ' num2str(n0,'%.2e') '    (m^-3)'];
disp(str);
str = ['T = ' num2str(T,'%.2e') '     (K)'];
disp(str);
str = ['f = ' num2str(f,'%.2e') '     (Hz)'];
disp(str);
str = ['alpha = ' num2str(alpha,'%2.0f') '       (degrees)'];
disp(str);
disp(' ');


return;