function Problem = cumulative_energy_release(Problem, theta, plt)
if (nargin < 3)
    plt = 0;
end

% Trigonometric functoin representing the cumulative energy release function
xb = 0.5*(1-cos(pi*(mod(theta-Problem.ths,2*pi))/Problem.thd)).*angle_between(theta,Problem.ths,Problem.ths+Problem.thd);
dxbdth = 1.5708*sin(pi*mod(theta-Problem.ths,2*pi)/Problem.thd)/Problem.thd.*angle_between(theta,Problem.ths,Problem.ths+Problem.thd);

if (plt)
    figure();
    plot(theta/pi*180,[xb;dxbdth]); grid;
    legend({'$x_b$','$\frac{dx_b}{d\theta}$'},'interpreter','latex');
    title('Cumulative energy release function','interpreter','latex');
    xlabel('Crank angle $\theta$ [$^\circ$]','interpreter','latex');
end

Problem.xb = xb;
Problem.dxbdth = dxbdth;

end
