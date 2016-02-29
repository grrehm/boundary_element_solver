function B=find_button_indices(B)
% function B=find_button_indices(B)
% Input:  B = a structure with geometry element centres xm,ym defined
%             also need button diameter bdia and centre separation bcs
% Output: B = the same structure with the following added
%          .ai   indices of elements on button A
%          .bi   indices of elements on button B
%          .ci   indices of elements on button C
%          .di   indices of elements on button D
n=length(B.xm);

% old method only worked on flat top and bottom
%bx1=B.bcs/2-B.bdia/2;
%bx2=B.bcs/2+B.bdia/2;
%B.ai=find(and((B.xm(1:round(n/2))>-bx2),(B.xm(1:round(n/2))<-bx1)));
%B.bi=find(and((B.xm(1:round(n/2))>bx1),(B.xm(1:round(n/2))<bx2)));
%B.ci=find(and((B.xm(round(n/2):n)>bx1),(B.xm(round(n/2):n)<bx2)))+round(n/2)-1;
%B.di=find(and((B.xm(round(n/2):n)>-bx2),(B.xm(round(n/2):n)<-bx1)))+round(n/2)-1;

% new method find index of element closest to centre of button first

[m,aci]=min(abs(B.xm(1:end/2)+B.bcs/2));
[m,bci]=min(abs(B.xm(1:end/2)-B.bcs/2));
[m,cci]=min(abs(B.xm(end/2:end)-B.bcs/2));
[m,dci]=min(abs(B.xm(end/2:end)+B.bcs/2));

% then finds all the elements whose centres are within a button radius
% NOTE this will fail if the button radius is larger than the height of the
% vessel!
B.ai=find(((B.xm-B.xm(aci)).^2+(B.ym-B.ym(aci)).^2)<(B.bdia/2)^2);
B.bi=find(((B.xm-B.xm(bci)).^2+(B.ym-B.ym(bci)).^2)<(B.bdia/2)^2);
B.ci=find(((B.xm-B.xm(cci+end/2)).^2+(B.ym-B.ym(cci+end/2)).^2)<(B.bdia/2)^2);
B.di=find(((B.xm-B.xm(dci+end/2)).^2+(B.ym-B.ym(dci+end/2)).^2)<(B.bdia/2)^2);



