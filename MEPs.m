function Problem = MEPs(Problem, theta, plt)
% MEPs per cylinder calculated on last cycle
Vcyl = Problem.Vd/Problem.nc;
m = Problem.m(end-Problem.precision:end);
p = Problem.p(end-Problem.precision:end);
V = Problem.V(end-Problem.precision:end);
dVdth = Problem.dVdth(end-Problem.precision:end);



% FuelMEP
mf = Problem.phi*m(1)/Problem.ma1;
FuelMEP = mf*Problem.LHV/Vcyl;
fprintf('FuelMEP =\t%.3f kPa\n',FuelMEP/1e3);

% QMEP
Qin = Problem.phi*Problem.LHV*m(1)/Problem.ma1;
QMEP = Qin/Vcyl;
fprintf('QMEP =\t\t%.3f kPa\n',QMEP/1e3);

% IMEP
IMEP = trapz(V,p)/Vcyl;
fprintf('IMEP =\t\t%.3f kPa\n',IMEP/1e3);

% FMEP
CMEP = trapz(V(dVdth<0),p(dVdth<0))/Vcyl; % Probably incorrect
FMEP = Problem.FMEP0 + Problem.ks*(2*CMEP + IMEP) + Problem.kv*Problem.Up/Problem.b;
fprintf('FMEP =\t\t%.3f kPa\n',FMEP/1e3);

% BMEP 
BMEP = IMEP - FMEP;
fprintf('BMEP =\t\t%.3f kPa\n',BMEP/1e3);



% Power
P = Problem.N*BMEP*Problem.Vd;
fprintf('\nPe =\t\t%.3f kW\n',P/1e3);







end
