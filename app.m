function main()
close all;
clc;

Problem          = struct();
Problem.b        = 0.105;             % Bore [m]
Problem.s        = 0.160;             % Stroke [m]
Problem.l        = 0.290;             % Conrod length [m]
Problem.a        = 0.080;             % Crank radius (half stroke) [m]
Problem.Vd       = 16.62e-3;          % Displacement volume [m^3]
Problem.r        = 17;                % Compression ratio [-]
Problem.lh       = 0.676;             % Liner height [m]
Problem.nc       = 6;                 % Number of cylinders [-]
Problem.eph      = 0.035;             % Exhaust port height [m]
Problem.iph      = 0.0302;            % Intake port height [m]
Problem.pin      = 1.4e5;             % Intake pressure [Pa]
Problem.pexh     = 1e5;               % Exhaust pressure [Pa]
Problem.Tin      = 50+273.15;         % Intake temperature [K]
Problem.N        = 2200/60;           % Rotation speed [rev/s]
Problem.epo      = (180-68.5)*pi/180; % Exhaust port opening [rad]
Problem.epc      = (180+68.5)*pi/180; % Exhaust port closing [rad]
Problem.ipo      = (180-53.5)*pi/180; % Intake port opening [rad]
Problem.ipc      = (180+71.5)*pi/180; % Intake port closing [rad]
Problem.Sip      = 0.00512;           % Total surface of the intake ports [m^2]
Problem.Sep      = 0.00679;           % Total surface of the exhaust ports [m^2]
Problem.exh_lead = 9.2*pi/180;        % Exhaust piston leading angle [rad]

Problem.gamma = 1.4;        % Adiabatic coefficient [-]
Problem.Rair  = 287.1;      % Air specific gas constant [J/kg/K]
Problem.cv    = 718;        % Constant pressure heat capacity [J/kg/K]
Problem.phi   = 0.6;        % Fuel-air equivalence ratio
Problem.ma1   = 14.5;       % Stoichiometric air-fuel ratio
Problem.LHV   = 43e6;       % Lower heating value [J/kg]
Problem.thd   = 30*pi/180;  % duration of energy release [rad]
Problem.ths   = -20*pi/180; % start of energy release [rad]
Problem.dcoef = 0.6;        % Discharge coefficient [-]
Problem.combustion = 1;
Problem.FMEP0 = 50e3;
Problem.ks = 0.025;
Problem.kv = 0.6125e3;

% Quick calculations
Problem.omega = Problem.N*2*pi;
Problem.cp = Problem.gamma*Problem.cv;
Problem.Up = 2*Problem.N*Problem.s; % Piston mean velocity [m/s]

Problem.cycles = 10;
Problem.precision = 10000;
theta = linspace(Problem.ipc,Problem.cycles*2*pi+Problem.ipc,Problem.cycles*Problem.precision);

Problem = volume(Problem, theta, 0);
Problem = cumulative_energy_release(Problem, theta, 0); % Correct for 4S engine
Problem = finite_energy_release(Problem, theta, 1);
Problem = MEPs(Problem, theta, 1); % Only last cycle is taken into account


end
