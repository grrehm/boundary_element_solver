function B=define_arc_BPM
% function B=define_arc_BPM
% Output B = structure with the following
%            .xg/.yg vessel geometry coordinate pairs
%            .bdia button diameter
%            .bcs  button centre separation
%            .bg   button gap
%            .bt   button thickness
% all dimensions in mm

B.xg=[l(-48,-48,22) l(-48,-16,160) l(-16,16,161) l(16,41,160)   l(41,41,22)];
B.yg=[l(0,4.5,22)   l(4.5,19,160)  l(19,19,161)  l(19,7.25,160) l(7.25,0,22)];
B.xg=[B.xg 41 fliplr(B.xg)];
B.yg=[B.yg 0 -fliplr(B.yg)];
% PMB button
%diameter
B.bdia=10.7;
%centre separations
B.bcs=17;
%thickness
B.bt=3.3;
%gap
B.bg=0.3;
