function B=calculate_induced_charge(B)
% function B=calculate_induced_charge(B)
% Input:  B = a structure defining a vessel geometry
% Output: B = the same structure with the following added
%          .invG Induced Charge Matrix
%          .xm   horizontal centres of elements
%          .ym   vertical centres of elements
%          .sl   lengths of elements
%         
%
% Note:   This calculation depends only on geometry and discretisation, it
% knows nothing about the buttons or the beam positions.
%
% For background see:
% Sensitivity calculation of beam position monitor using boundary element method
% Tsumoru Shintake, Masaki Tejima, Hitoshi Ishii, Jun-ichi Kishiro
% DOI: 10.1016/0168-9002(87)90496-7
% 
% or
%
% http://www.lnf.infn.it/acceleratori/dafne/NOTEDAFNE/CD/CD-10.pdf
% DAPHNE TECHNICAL NOTE CD-10, 
% "ANALYSIS OF THE DA?NE BEAM POSITION MONITOR WITH A BOUNDARY ELEMENT METHOD
% A. Stella


if length(B.xg)~=length(B.yg)
    error('xg and yg need to be same length!')
else
    n=length(B.xg)-1;
end
%calculate positions of centres of elements
B.xm=(B.xg(1:n)+B.xg(2:n+1))/2;
B.ym=(B.yg(1:n)+B.yg(2:n+1))/2;

G=zeros(n,n);
for j=1:n
    %calculate length of element
    B.sl(j)=sqrt((B.xg(j+1)-B.xg(j))^2+(B.yg(j+1)-B.yg(j))^2);
    % here comes the essence: this calculates the charge induced between
    % elements. For details look at paper.
    for i=1:n
        if i==j
            G(i,j)=2*B.sl(j)*(1-log(B.sl(j)));
        else
            G(i,j)=-log(sqrt((B.xm(j)-B.xm(i))^2+(B.ym(j)-B.ym(i))^2))*B.sl(j);
        end
    end
end
B.invG=inv(G).';
