function B=convert_abcd2xy_log(B);
% function B=convert_abcd2xy_log(B);
% Input:  B = a structure with induced charge invG and button indices
%             ai,bi,ci,di 
% Output: B = the same structure with the following added
%          .x/.y   horizontal/vertical position reading of BPM
%          .q      quadupole moment

B.s=B.a+B.b+B.c+B.d;
B.x=(log(B.a)-log(B.c)-log(B.b)+log(B.d))./B.s;
B.y=(log(B.a)-log(B.c)+log(B.b)-log(B.d))./B.s;
B.q=(B.a+B.c-B.b-B.d)./B.s;


