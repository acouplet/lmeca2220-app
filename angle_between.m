function isBetween = angle_between(n,a,b)
    n = mod(2*pi + mod(n,2*pi), 2*pi);
    a = mod(100*pi + a, 2*pi);
    b = mod(100*pi + b, 2*pi);

    if (a<b)
        isBetween = (a <= n & n <= b);
    else
        isBetween = (a <= n | n <= b);
    end
end
