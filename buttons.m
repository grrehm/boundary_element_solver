function [a,b,c,d,u,v,q] = buttons(x, y, ig, sl, xm, ym, ba, bb, bc, bd, Xo, Yo, Kx, Ky)
% return button signal at x, y
B   = -log(sqrt((x-xm).^2+(y-ym).^2));
sig = ig*B.';
% a   = sum(sig(ba));
% b   = sum(sig(bb));
% c   = sum(sig(bc));
% d   = sum(sig(bd));
% s   = a+b+c+d;
ps = sum(sl.*sig');
a         = sum(sl(ba).*sig(ba)');
b         = sum(sl(bb).*sig(bb)');
c         = sum(sl(bc).*sig(bc)');
d         = sum(sl(bd).*sig(bd)');

% work out what this means in terms of the difference over sum mapping
s = a+b+c+d;
u =-(a-b-c+d)/s;
v = (a+b-c-d)/s;
q = (a+c-b-d)/s;

% apply offset
u = u-Xo;
v = v-Yo;

% apply scaling
u = u*Kx;
v = v*Ky;
