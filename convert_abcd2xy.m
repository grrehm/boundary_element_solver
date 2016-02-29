function B=convert_abcd2xy(B);
% function B=convert_abcd2xy_log(B);
% Input:  B = a structure with induced charge invG and button indices
%             ai,bi,ci,di 
% Output: B = the same structure with the following added
%          .x/.y   horizontal/vertical position reading of BPM
%          .q      quadupole moment

% standard calculation of differences over sum
B.s=B.a+B.b+B.c+B.d;
B.x=(-B.a+B.b+B.c-B.d)./B.s;
B.y=(B.a+B.b-B.c-B.d)./B.s;
B.q=(B.a+B.c-B.b-B.d)./B.s;

