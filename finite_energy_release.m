function Problem = finite_energy_release(Problem, theta, plt)
if (nargin < 3)
    plt = 0;
end

m0 = Problem.pin*Problem.V(1)/Problem.Rair/Problem.Tin;
Qin = 0;
gamma = Problem.gamma;


Problem.mi     = zeros(1,size(theta,2));
Problem.me     = zeros(1,size(theta,2));
Problem.m      = zeros(1,size(theta,2));
Problem.p      = zeros(1,size(theta,2));
Problem.T      = zeros(1,size(theta,2));
Problem.dmidth = zeros(1,size(theta,2));
Problem.dmedth = zeros(1,size(theta,2));
Problem.dpdth  = zeros(1,size(theta,2));
Problem.dTdth  = zeros(1,size(theta,2));
Problem.mi(1)  = m0;
Problem.me(1)  = 0;
Problem.m(1)  = Problem.mi(1);
Problem.p(1)   = Problem.pin;
Problem.T(1)   = Problem.Tin;

V = Problem.V;
dVdth = Problem.dVdth;
dxbdth = Problem.dxbdth;
dtheta = theta(2)-theta(1);

for i = 1:size(theta,2)-1
    Problem.dmidth(i) = massflow(Problem, i,'in')/Problem.omega;
    Problem.dmedth(i) = massflow(Problem, i,'out')/Problem.omega;
    Problem.dmdth(i) = Problem.dmidth(i) - Problem.dmedth(i);
    % Uncomment following line for combustion in the engine
    Qin = Problem.combustion*Problem.phi*Problem.LHV*Problem.m(i)/Problem.ma1;
    Problem.dTdth(i) = (-Problem.p(i)/(Problem.m(i)*Problem.cv))*dVdth(i) + (1/Problem.m(i))*Problem.dmidth(i)*(gamma*Problem.Tin-Problem.T(i)) - (1/Problem.m(i))*Problem.dmedth(i)*(Problem.T(i)*(gamma-1));


  
    if (Problem.Ai(i) + Problem.Ae(i) == 0)
        Problem.dpdth(i) = -gamma*Problem.p(i)/V(i)*dVdth(i) + (gamma-1)*Qin/V(i)*dxbdth(i);
    else 
        Problem.dpdth(i) = (Problem.Rair/V(i))*(Problem.m(i)*Problem.dTdth(i) + Problem.T(i)*Problem.dmdth(i)) - (Problem.Rair/V(i)^2)*Problem.m(i)*Problem.T(i)*Problem.dVdth(i);
    end

    % Uncomment following line for information at every iteration
    %fprintf('p = %e; T = %e; m = %e; Ai = %e; Ae = %e; dmidth = %e; dmedth = %e; dTdth = %e; dpdth = %e\n',Problem.p(i), Problem.T(i),Problem.m(i),Problem.Ai(i),Problem.Ae(i),Problem.dmidth(i),Problem.dmedth(i),Problem.dTdth(i),Problem.dpdth(i));

    Problem.p(i+1) = Problem.p(i) + dtheta*Problem.dpdth(i);
    Problem.m(i+1) = Problem.m(i) + dtheta*Problem.dmdth(i);
    Problem.T(i+1) = Problem.T(i) + dtheta*Problem.dTdth(i);
    Problem.m(i+1) = Problem.m(i) + dtheta*Problem.dmdth(i);
    if (Problem.Ai(i) + Problem.Ae(i) == 0)
        Problem.T(i+1) = Problem.V(i+1)*Problem.p(i+1)/Problem.m(i+1)/Problem.Rair;
    end
end
rho0 = Problem.pin/Problem.Rair/Problem.Tin;
totdeb = Problem.dmidth;
totdeb(totdeb==0) = [];
dVidth_int = sum(totdeb)/rho0/Problem.cycles; %integrale de dVidth
tb = (Problem.ipc - Problem.ipo)/(Problem.N*2*pi); %scavening time [s]
sc = dVidth_int*tb/Problem.Vd;
Problem.sc = sc; %scavening coefficient
Vscave = Problem.iph*(pi/4)*(Problem.b)^2; % Intake Scavenging volume
c = 1  - Vscave/Problem.Vd;
if (sc <= (c+1/(Problem.r-1)))
    eta_vol = sc;
else
    eta_vol = c+1/(Problem.r-1);
end
Problem.eta_vol = eta_vol;
fprintf('Scanvenging coefficient: %.3f\n', Problem.sc);
fprintf('Volumetric efficiency: %.3f\n', Problem.eta_vol);

if (plt == 1)
     figure();
     yyaxis left;
     plot(theta*180/pi,[Problem.p]); grid;
     xlabel('Crank angle $\theta$ [$^\circ$]','interpreter','latex');
     ylabel('Pressure [$Pa$]','interpreter','latex');
     yyaxis right;
     plot(theta*180/pi,[Problem.T]); grid;
     xlabel('Crank angle $\theta$ [$^\circ$]','interpreter','latex');
     ylabel('Temperature [$K$]','interpreter','latex');
     figure();
     yyaxis left;
     plot(theta*180/pi,[Problem.dmedth]);
     xlabel('Crank angle $\theta$ [$^\circ$]','interpreter','latex');
     ylabel('Exhaust flux [$kg/s$]','interpreter','latex');
     yyaxis right;
     plot(theta*180/pi,[Problem.dmidth]);
     xlabel('Crank angle $\theta$ [$^\circ$]','interpreter','latex');
     ylabel('Intake flux [$kg/s$]','interpreter','latex');
     figure();
     plot(theta*180/pi,Problem.m); grid;
     xlabel('Crank angle $\theta$ [$^\circ$]','interpreter','latex');
     ylabel('masse[$kg$]','interpreter','latex');
end

end
