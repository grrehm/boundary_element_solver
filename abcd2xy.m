function xys = abcd2xy(abcds, B)
% function xys = abcd2xy(abcds, B)
% 
% converts a 4 by N array of ABCD values to XY pairs using BPM structure B
% we'll take a copy of B so we don't modify the original.
% convergence tolerance (1e-6 mm, or 1 nm)
tol = 1e-6;
% we need normalised ABCD
abcds=abcds./repmat(sum(abcds),4,1);
B.invGa=B.invG(:,[B.ai]);
B.invGb=B.invG(:,[B.bi]);
B.invGc=B.invG(:,[B.ci]);
B.invGd=B.invG(:,[B.di]);

% bpm calibration factors now in S structure
fprintf('Using kx = %6.4f, ky = %6.4f\n',B.kx,B.ky)

% want to solve for xy
% abcd = buttons(xy)
% root of
% buttons(xy) - abcd = 0
maxit = 0;
for n = 1:size(abcds, 2)

    abcd = abcds(:, n);
    abcd = abcd ./ sum(abcd);
    guess = linvert(abcd, B.kx, B.ky);
        
    xy1 = guess*1;

    for it = 1:100
        last = xy1;
        
        xy1 = buttons_deriv(xy1, abcd, B);
        if norm(last - xy1) < tol
            break
        end
    end

    maxit = max(maxit, it);

    xys(:, n) = xy1;

    % end for n
end

fprintf('BPM solve converged in maximum %d iterations\n', maxit);

% end function
end

function abcd = buttons(xy,B)
% return button signal at x, y

%        charge=(-log(sqrt((xy(1)-B.xm).^2+(xy(2)-B.ym).^2)))*B.invG;
%        a=sum(B.sl(B.ai).*charge(B.ai));
%        b=sum(B.sl(B.bi).*charge(B.bi));
%        c=sum(B.sl(B.ci).*charge(B.ci));
%        d=sum(B.sl(B.di).*charge(B.di));
        lsxy=(-log(sqrt((xy(1)-B.xm).^2+(xy(2)-B.ym).^2)));
        a=sum(B.sl(B.ai).*(lsxy*B.invGa));
        b=sum(B.sl(B.bi).*(lsxy*B.invGb));
        c=sum(B.sl(B.ci).*(lsxy*B.invGc));
        d=sum(B.sl(B.di).*(lsxy*B.invGd));
        abcd=[a;b;c;d]/(a+b+c+d);
end

function newxy = buttons_deriv(xy, abcd0, S)
% newton step for BPM buttons
% newtons method x(n+1) = x(n) - f(x(n)) / f'(x(n))
% here f(xy) = buttons(xy) - abcd0

% newton's method with finite differences
% yes secant method is almost certainly better

f = buttons(xy, S) - abcd0;

delta = 1e-3;

dxy0 = xy;
dxy0(1) = dxy0(1) + delta;
dxy1 = xy;
dxy1(2) = dxy1(2) + delta;

df0 = (buttons(dxy0, S) - abcd0 - f) ./ delta;
df1 = (buttons(dxy1, S) - abcd0 - f) ./ delta;

fdash = [df0 df1]';
newxy = xy - (f.' / fdash).';

end


function xy = linvert(abcd, kx, ky)
    % this is the function in the libera, use for a guess
    a = abcd(1);
    b = abcd(2);
    c = abcd(3);
    d = abcd(4);
    s = a+b+c+d;
    x = -(a-b-c+d)/s;
    y = (a+b-c-d)/s;
    xy = [x * kx; y * ky];
end