function B=define_circular_BPM
%%circular for transfer paths
radius=30;
B.xg=radius*cos(linspace(0,2*pi,361));
B.yg=radius*sin(linspace(0,2*pi,361));
%diameter
B.bdia=10;
%thickness
B.bt=3;
%gap
B.bg=0.5;
angle=45;
buttonspan=round(B.bdia/(radius*2*pi)*360);
B.bi=(angle-buttonspan:angle+buttonspan);
B.ai=(180-buttonspan-angle:180+buttonspan-angle);
B.di=(angle+180-buttonspan:angle+180+buttonspan);
B.ci=(360-buttonspan-angle:360+buttonspan-angle);
