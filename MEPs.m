function Problem = MEPs(Problem, theta, plt)
% MEPs per cylinder calculated on last cycle
Vcyl = Problem.Vd/Problem.nc;
m = Problem.m(end-Problem.precision:end);
dmedth = Problem.dmedth(end-Problem.precision:end);
dmidth = Problem.dmidth(end-Problem.precision:end);
p = Problem.p(end-Problem.precision:end);
V = Problem.V(end-Problem.precision:end);
dVdth = Problem.dVdth(end-Problem.precision:end);



% FuelMEP
mf = Problem.phi*m(1)/Problem.ma1;
FuelMEP = mf*Problem.LHV/Vcyl;
fprintf('FuelMEP =\t%.3f bar\n',FuelMEP/1e5);

% QMEP
Qin = Problem.phi*Problem.LHV*m(1)/Problem.ma1;
QMEP = Qin/Vcyl;
fprintf('QMEP =\t\t%.3f bar\n',QMEP/1e5);

% PMEP
meanpe = mean(p(dmedth > 0));
meanpi = mean(p(dmidth > 0));
PMEP = meanpe-meanpi;
fprintf('PMEP =\t\t%.3f bar\n',PMEP/1e5);

% IMEP
IMEPn = trapz(V,p)/Vcyl;
IMEPg = IMEPn + PMEP;
fprintf('IMEPg =\t\t%.3f bar\n',IMEPg/1e5);
fprintf('IMEPn =\t\t%.3f bar\n',IMEPn/1e5);

% FMEP
CMEP = trapz(V(dVdth<0),p(dVdth<0))/Vcyl;
FMEP = Problem.FMEP0 + Problem.ks*(2*CMEP + IMEPg) + Problem.kv*Problem.Up/Problem.b;
fprintf('FMEP =\t\t%.3f bar\n',FMEP/1e5);




% BMEP 
BMEP = IMEPn - FMEP;
fprintf('BMEP =\t\t%.3f bar\n',BMEP/1e5);



% Power
P = Problem.N*BMEP*Problem.Vd;
pmax = max(p);
fprintf('\npmax =\t\t%.3f bar\n',pmax/1e5);
fprintf('Pe@%dRPM =\t%.3f kW\n',round(Problem.N*60),P/1e3);

figure();
plot(V,p/1e5);
ylabel('Pressure [$bar$]','interpreter','latex');
xlabel('Volume [$m^3$]','interpreter','latex');
title('p-V diagram of the cycle','interpreter','latex');
grid on;







end
