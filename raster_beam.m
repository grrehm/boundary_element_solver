function B=raster_beam(B,extent,spacing)
if exist('extent','var')
    if length(extent)==4
        xmin=extent(1);
        xmax=extent(2);
        ymin=extent(3);
        ymax=extent(4);
    else
        xmin=-extent(1);
        xmax=extent(1);
        ymin=-extent(1);
        ymax=extent(1);
    end
else
        xmin=-5;
        xmax=5;
        ymin=-5;
        ymax=5;
end
if ~exist('spacing','var')
    spacing=1;
end
[B.xb,B.yb]=meshgrid(xmin:spacing:xmax,ymin:spacing:ymax);
[xl,yl]=size(B.xb);
for yi=1:yl
    for xi=1:xl
        % calculate charge distribution on boundary from 'beam position'
        charge=(-log(sqrt((B.xb(xi,yi)-B.xm).^2+(B.yb(xi,yi)-B.ym).^2)))*B.invG;
        B.totalcharge(xi,yi)=sum(B.sl.*charge);
        B.a(xi,yi)=sum(B.sl(B.ai).*charge(B.ai));
        B.b(xi,yi)=sum(B.sl(B.bi).*charge(B.bi));
        B.c(xi,yi)=sum(B.sl(B.ci).*charge(B.ci));
        B.d(xi,yi)=sum(B.sl(B.di).*charge(B.di));
    end
end