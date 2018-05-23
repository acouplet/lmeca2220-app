function dmdth = massflow(Problem, i, inout)
inout;
gamma = Problem.gamma;

if (strcmp(inout,'in'))
    rhoin = Problem.pin/Problem.Rair/Problem.Tin;
    cin = sqrt(gamma*Problem.Rair*Problem.Tin);
    pout = Problem.p(i);
    pin = Problem.pin;
    Af = Problem.Ai(i)*Problem.dcoef;
elseif (strcmp(inout,'out'))
    rhoin = Problem.p(i)/Problem.Rair/Problem.T(i);
    cin = sqrt(gamma*Problem.Rair*Problem.T(i));
    pin = Problem.p(i);
    pout = Problem.pexh;
    Af = Problem.Ae(i)*Problem.dcoef;
end



prcritical = ((gamma+1)/2)^(gamma/(gamma-1));
if (pin < pout)
    dmdth = 0;
elseif (pin/pout < prcritical)
    dmdth = rhoin*Af*cin*sqrt(2/(gamma-1)*((pout/pin)^(2/gamma) - (pout/pin)^((gamma+1)/gamma)));
else % Choked
    dmdth = rhoin*Af*cin*(2/(gamma+1))^((gamma+1)/(2*(gamma-1)));
end

end
