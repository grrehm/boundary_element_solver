function [S,u,v,q,xout,yout] = boundary_invert(geometry, varargin)

% function inputs:
% geometry - can be one of:
%            'arc', 'primary', 'primary-ALBA', 'arc-DDBA', 'primary-DDBA', 'i10'
% plotflag - 1 or 0
%
%
% Structure S contains outputs:
% ig, sl         - inverse G matrix (Daphne technical note CD-10, 1997) and amplitude vector
% ba, bb, bc, bd - button indices into the data
% xm, ym         - button x/y coordinated on the vacuum chanber aperture
% Xo, Yo         - electrical centre of the BPM
% Kx, Ky         - BPM scale factors
%
% Other function outputs from plots
% u, v           - Beam positions calculated with difference over sum mapping
% q              - BPM q value (gives measure of beam tilt)
% xout, yout     - Actual beam positions
%
% see also buttons.m for using the above output to convert between real x/y to output u/v

if isempty(varargin)
    plotflag = 0;
else
    plotflag = varargin{1};
end


spacing = 1;      % used when calculating the grid of beam positions
ext     = 7;      % amplitude for beam position grid used for plots 
xs      = ext/spacing;
ys      = ext/spacing;

switch geometry
    
    case 'arc'
        % bpm in arc vessel
        n    = 180;
        x    = [l(-48,-48,n) l(-48,-16,n) l(-16,16,161) l(16,41,n) l(41,41,n)];
        y    = [l(.1,4.5,n)   l(4.5,19,n)     l(19,19,161)       l(19,7.25,n) l(7.25,0,n)];
        x    = [x fliplr(x) x(1)];
        y    = [y -fliplr(y) y(1)];
        bdia = 10.7;  % button diameter
        bcs  = 17;    % separation of button centres
        bt   = 3.3;
        bg   = 0.3;
        
    case 'primary'
        %bpm in primary 72 wide 20 high WRONG!
        %bpm in primary 70 wide 22 high RIGHT!
        w    = 72;
        h    = 22;
        r    = h/2;
        s    = (w-h)/2;
        x    = [-s-r*sin(l(0,pi,90)) l(-s,s,270) s+r*sin(l(0,pi,90)) l(s,-s,270) -s];
        y    = [-r*cos(l(0,pi,90)) l(r,r,270) r*cos(l(0,pi,90)) l(-r,-r,270) -r];
        % PMB button
        bdia = 10.7;  % button diameter
        bcs  = 15.3;  % separation of button centres
        bt   = 3.3;
        bg   = 0.3;
        
    case 'primary-ALBA'
        % new ALBA button
        w    = 72;
        h    = 22;
        r    = h/2;
        s    = (w-h)/2;
        x    = [-s-r*sin(l(0,pi,90)) l(-s,s,270) s+r*sin(l(0,pi,90)) l(s,-s,270) -s];
        y    = [-r*cos(l(0,pi,90)) l(r,r,270) r*cos(l(0,pi,90)) l(-r,-r,270) -r];
        bdia = 7;     % button diameter
        bcs  = 13.7;  % separation of button centres
        bt   = 3.5;
        bg   = 0.3;
        %ID pump port, round sides 20 high 62 wide
        %x=[-21-10*sin(l(0,pi,90)) l(-21,21,210) 21+10*sin(l(0,pi,90)) l(21,-21,210) -21];
        %y=[-10*cos(l(0,pi,90)) l(10,10,210) 10*cos(l(0,pi,90)) l(-10,-10,210) -10];
        
    case 'arc-DDBA'
        %%elliptical for DDBA
        x    = 27/2*cos(linspace(0,2*pi,1441));
        y    = 18/2*sin(linspace(0,2*pi,1441));
        bdia = 6;     % button diameter
        bcs  = 12;    % separation of button centres
        bt   = 4;
        bg   = 0.3;
        
    case 'primary-DDBA'
        %%racetrack 40 wide 20 high for DDBA
        w    = 40;
        h    = 20;
        r    = h/2;
        s    = (w-h)/2;
        x    = [-s-r*sin(l(0,pi,90)) l(-s,s,270) s+r*sin(l(0,pi,90)) l(s,-s,270) -s];
        y    = [-r*cos(l(0,pi,90)) l(r,r,270) r*cos(l(0,pi,90)) l(-r,-r,270) -r];
        bdia = 6;
        bcs  = 12;
        bt   = 4;
        bg   = 0.3;
        
    case 'i10'
        %%elliptical for I10
        x    = 37*cos(linspace(0,2*pi,1441));
        y    = 5.5*sin(linspace(0,2*pi,1441));
        bdia = 7;     % button diameter
        bcs  = 8.5;    % separation of button centres
        bt   = 3.5;
        bg   = 0.3;
end

%%elliptical for booster
%x=26*cos(linspace(0,2*pi,721));
%y=12*sin(linspace(0,2*pi,721));

%%circular for transfer paths
%x=33*cos(linspace(0,2*pi,361));
%y=33*sin(linspace(0,2*pi,361));

%calculate middle positions
e  = length(x)-1;
xm = (x(1:e)+x(2:e+1))/2;
ym = (y(1:e)+y(2:e+1))/2;

% button location between bx1 and bx2, defined before
bx1 = bcs/2 - bdia/2;
bx2 = bcs/2 + bdia/2;
ba  = find(and((xm(1:e/2)>-bx2),(xm(1:e/2)<-bx1)));        % index into the xm and ym positions
bb  = find(and((xm(1:e/2)>bx1),(xm(1:e/2)<bx2)));          % index into the xm and ym positions
bc  = find(and((xm(e/2:e)>bx1),(xm(e/2:e)<bx2)))+e/2-1;    % index into the xm and ym positions
bd  = find(and((xm(e/2:e)>-bx2),(xm(e/2:e)<-bx1)))+e/2-1;  % index into the xm and ym positions

% for circular vessel, diagonal pickups
%a=45;s=round(0.187*180);
%bb=(a-s:a+s);
%ba=(180-s-a:180+s-a);
%bd=(a+180-s:a+180+s);
%bc=(360-s-a:360+s-a);

% for circular vessel, NWSE pickups
%s=round(0.187*180);
%bb=([1:s 360-s:360]);
%ba=(90-s:90+s);
%bd=(180-s:180+s);
%bc=(270-s:270+s);

% calculate G and inverse
G=zeros(e,e);
for j=1:e
    sl(j)=sqrt((x(j+1)-x(j))^2+(y(j+1)-y(j))^2);
    for i=1:e
        if i==j
            G(j,i)=2*sl(j)*(1-log(sl(j)));
        else
            G(i,j)=-log(sqrt((xm(j)-xm(i))^2+(ym(j)-ym(i))^2))*sl(j);
        end
    end
end
ig = inv(G);

% initialise data arrays
B    = zeros(1,e);
xout = zeros(xs+1,ys+1);
yout = zeros(xs+1,ys+1);
u    = zeros(xs+1,ys+1);
v    = zeros(xs+1,ys+1);
q    = zeros(xs+1,ys+1);
for y0=1:2*ys+1
    for x0=1:2*xs+1
        
        xout(x0,y0)=(x0-xs-1)*spacing;
        yout(x0,y0)=(y0-ys-1)*spacing;

%         B   = -log(sqrt((xout(x0,y0)-xm).^2+(yout(x0,y0)-ym).^2));   
%         sig = ig*B.';
%         
%         ps(x0,y0) = sum(sl.*sig');
%         a         = sum(sl(ba).*sig(ba)');
%         b         = sum(sl(bb).*sig(bb)');
%         c         = sum(sl(bc).*sig(bc)');
%         d         = sum(sl(bd).*sig(bd)');
%         pa(x0,y0) = a;
%         pb(x0,y0) = b;
%         pc(x0,y0) = c;
%         pd(x0,y0) = d;
%         s         = a+b+c+d;
%      
%         % standard calc
%         u(x0,y0)= (a-b-c+d)/s;
%         v(x0,y0)= (a+b-c-d)/s;
%         q(x0,y0)= (a+c-b-d)/s;

        % In the first instance, set scaling to 1 and offset to zero
        Xo = 0;
        Yo = 0;
        Kx = 1;
        Ky = 1;
        [a,b,c,d,u2,v2,q2] = buttons(xout(x0,y0), yout(x0,y0), ig, sl, xm, ym, ba, bb, bc, bd, Xo, Yo, Kx, Ky);
        pa(x0,y0) = a;
        pb(x0,y0) = b;
        pc(x0,y0) = c;
        pd(x0,y0) = d;
        s         = a+b+c+d;
        u(x0,y0)  =-(a-b-c+d)/s;
        v(x0,y0)  = (a+b-c-d)/s;
        q(x0,y0)  = (a+c-b-d)/s;

    end
end

% electrical centres
Xo = u(xs+1,ys+1);
Yo = v(xs+1,ys+1);
u = u-Xo;
v = v-Yo;

% calculate scale factors
Kx = spacing/u(2+xs,1+ys);
Ky = spacing/v(1+xs,2+ys);

% apply scaling
u = u*Kx;
v = v*Ky;

S.xm = xm;
S.ym = ym;
S.ig = ig;
S.sl = sl;
S.ba = ba;
S.bb = bb;
S.bc = bc;
S.bd = bd;
S.Kx = Kx;
S.Ky = Ky;
S.Xo = Xo;
S.Yo = Yo;

% calculate button capacitance
e0 = 8.85*1e-12;        % Vacuum permittivity
rb = (bdia/2)*1e-3;     % button radius
Cb = ((2*pi*e0*bt*1e-3)/(log((rb+bg*1e-3)/rb)));

% calculate power from button
w  = 2*pi*500e6;	%RF frequency (Hz)
w1 = 1/(50*Cb);
w2 = 3e8/(2*rb);
I  = 0.3;
Pb = 0.5*(I.^2)*50*(pa(8,8)^2)*((w1/w2)^2)*(((w/w1)^2)/(1+((w/w1)^2)));		%Average Power on the load [W]

if plotflag
    
    fprintf('button capacitance %3.2f pF\n',Cb*1e12)
    fprintf('current fraction on one button MIN/CENTRE/MAX: %2.1f %2.1f %2.1f per cent\n',min(min(pa))*100,pa(6,6)*100,max(max(pa))*100)
    fprintf('power from one button with beam at centre at 300mA: %3.1f dBm   ',log10(Pb*1000)*10);
    fprintf('0dBm at: %3.3f mA\n',sqrt(1e-3/Pb)*300);
    fprintf('scale factors %3.1f %3.1f mm\n',-Kx,Ky);
    fprintf('electric centre at %f %f mm\n',Xo,Yo);

    figure(1)
    %plot(u,v,'bx',x,y,'k-',xm(ba),ym(ba),'kd',xm(bb),ym(bb),'kd',xm(bc),ym(bc),'kd',xm(bd),ym(bd),'kd')
    plot(x,y,'k-',xm(ba),ym(ba),'b.',xm(bb),ym(bb),'b.',xm(bc),ym(bc),'b.',xm(bd),ym(bd),'b.');
    hold on;
    % mesh(xout,yout,zeros(size(xout)),zeros(size(xout)));
    % mesh(u,v,zeros(size(u)),ones(size(u)));
    % colormap([.8 .8 .8;1 0 0])
    plot(xout,yout,'.b');
    plot(u,v,'or');
    hold off
    xlabel('position x [mm]')
    ylabel('position y [mm]')
    axis equal
    title(sprintf('%s dia %2.1f gap %2.1f thick %2.1f dist %2.1f\n C_b=%2.1fpF K_x=%2.1fmm K_y=%2.1fmm P_{300mA}=%2.1fdBm',geometry,bdia,bg,bt,bcs,Cb*1e12,-Kx,Ky,log10(Pb*1000)*10))
end




function ll=l(a,b,c)
ll=linspace(a,b,c+1);
ll=ll(1:c);
