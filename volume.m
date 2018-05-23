function Problem = volume(Problem, theta, plt)
if (nargin < 3)
    plt = 0;
end

r  = Problem.r;
Vd = Problem.Vd;
nc = Problem.nc;
l  = Problem.l;
a  = Problem.a;
b  = Problem.b;

V1 = r/(r-1)*Vd/nc; % Cylinder volume [m^3]
Vc = V1/r;          % Clearance volume [m^3]

thetae = theta;
thetai = theta-Problem.exh_lead;

ye     = l + a - (sqrt(l^2 - a^2*sin(theta).^2) + a*cos(theta));
dyedth = (a^2*sin(theta).*cos(theta))./sqrt(l^2-a^2*sin(theta).^2) + a*sin(theta);
yi     = l + a - (sqrt(l^2 - a^2*sin(thetai).^2) + a*cos(thetai));
dyidth = -(a^2*sin(-thetai).*cos(-thetai))./sqrt(l^2-a^2*sin(-thetai).^2) - a*sin(-thetai);

xe = @(theta) a*cos(theta) + sqrt(l^2-a^2*sin(theta).^2); % Exhaust piston position [m]
xi = @(theta) xe(theta-Problem.exh_lead); % Intake piston position [m]
Ae = @(theta) (mod(theta,2*pi) >= Problem.epo & mod(theta,2*pi) <= Problem.epc).*(min(-(xe(theta)-xe(Problem.epo)),Problem.eph))*Problem.Sep/Problem.eph; % Exhaust port surface [m^2]
Ai = @(theta) (mod(theta,2*pi) >= Problem.ipo & mod(theta,2*pi) <= Problem.ipc).*(min(-(xi(theta)-xi(Problem.ipo)),Problem.iph))*Problem.Sip/Problem.iph; % Exhaust port surface [m^2]

Ae = Ae(theta);
Ai = Ai(theta);

Ve    = Vc + pi/4*b^2*ye; % Exhaust piston volume [m^3]
Vi    = Vc + pi/4*b^2*yi; % Intake piston volume [m^3]
V     = Ve+Vi;            % Opposed-piston volume [m^3]
dVdth = pi/4*b^2*(dyedth + dyidth);

Vscave = (Problem.eph)*pi*(Problem.b/2)^2; % Intake Scavenging volume
Vcyl = Problem.Vd/Problem.nc; % Cylinder volume

if (plt == 1)
    figure();
    plot(theta,[Ve;Vi;Ve+Vi]); grid;
    legend({'$V_e$','$V_i$','$V$'},'interpreter','latex');
    title('Piston volumes','interpreter','latex');
    xlabel('Crank angle $\theta$ [$^\circ$]','interpreter','latex');
    ylabel('Volume [$m^3$]','interpreter','latex');
end

Problem.V1    = V1;
Problem.Vc    = Vc;
Problem.Ve    = Ve;
Problem.Vi    = Vi;
Problem.V     = V;
Problem.dVdth = dVdth;
Problem.Ae = Ae;
Problem.Ai = Ai;

end
