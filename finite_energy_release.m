function Problem = finite_energy_release(Problem, theta, plt)
if (nargin < 3)
    plt = 0;
end

ma = Problem.pin*Problem.V(1)/Problem.Rair/Problem.Tin;
Qin = Problem.phi*Problem.LHV*ma/Problem.ma1;
gamma = Problem.gamma;

p = zeros(1,size(theta,2));
dpdth = zeros(1,size(theta,2));
p(1) = Problem.pin;
V = Problem.V;
dVdth = Problem.dVdth;
dxbdth = Problem.dxbdth;
dtheta = theta(2)-theta(1);

for i = 1:size(theta,2)-1
    dpdth(i) = -gamma*p(i)/V(i)*dVdth(i) + (gamma-1)*Qin/V(i)*dxbdth(i);
    p(i+1) = p(i) + dtheta*dpdth(i);
end

if (plt == 1)
    figure();
    plot(theta*180/pi,p); grid;
end



end
