function Problem = breathing_phase(Problem, theta, plt)

Vc = Problem.Vd/Problem.nc % Cylinder volume
hcyl = Vc/(pi*(Problem.b/2)^2); % Cylinder height
Vcc = Problem.Vc; % Combustion chamber volume
Vscav = (Problem.eph+Problem.iph)*pi*(Problem.b/2)^2; % Scavenging volume
c = 1-Vscav/Vc;
Vcs = c*Vc; % Compression stroke volume

rho0 = Problem.pin/Problem.Rair/Problem.Tin;








end
