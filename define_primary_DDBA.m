function B=define_primary_BPM
% function B=define_primary_BPM
% Output B = structure with the following
%            .xg/.yg vessel geometry coordinate pairs
%            .bdia button diameter
%            .bcs  button centre separation
%            .bg   button gap
%            .bt   button thickness
% all dimensions in mm


%bpm in primary 70 wide 22 high RIGHT!
w=40;h=20;
r=h/2;
s=(w-h)/2;
B.xg=[-s-r*sin(l(0,pi,90)) l(-s,s,270) s+r*sin(l(0,pi,90)) l(s,-s,270) -s];
B.yg=[-r*cos(l(0,pi,90)) l(r,r,270) r*cos(l(0,pi,90)) l(-r,-r,270) -r];
% PMB button
%diameter
B.bdia=6;
%centre separations
B.bcs=12;
%thickness
B.bt=4;
%gap
B.bg=0.3;
