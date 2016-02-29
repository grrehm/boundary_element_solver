function line=l(startpos,endpos,points)
% function line=l(startpos,endpos,points)
%
% this is like 'linspace' just that it drops the last point
% the intention is that you can then do 'adjecent' ranges without
% duplicating points
% inputs:
% startpos  first point on line
% endpos    last point on line (will be dropped)
% points    number of points on line
line=linspace(startpos,endpos,points+1);
line=line(1:points);