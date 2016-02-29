function B=find_apply_scalefactor(B)

%          .kx/.ky horizontal/vertical scale factor in mm  

%find centre indices
[cx,B.cxi]=min(abs(B.xb(1,:)));
[cy,B.cyi]=min(abs(B.yb(:,1)));
%scale factor is change of beam pos divided by change of x/y around centres 
B.kx=diff(B.xb(B.cyi,B.cxi+[-1 1]))/diff(B.x(B.cyi,B.cxi+[-1 1]));
B.ky=diff(B.yb(B.cyi+[-1 1],B.cxi))/diff(B.y(B.cyi+[-1 1],B.cxi));
%apply scale factor
B.x=B.x*B.kx;
B.y=B.y*B.ky;
fprintf('horizontal scale factor %2.1f mm, vertical scale factor %2.1f mm\n',B.kx,B.ky)