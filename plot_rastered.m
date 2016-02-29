function plot_rastered(B)
figure(2)
plot(B.xg,B.yg,'k-',B.xm(B.ai),B.ym(B.ai),'b.',B.xm(B.bi),B.ym(B.bi),'b.',B.xm(B.ci),B.ym(B.ci),'b.',B.xm(B.di),B.ym(B.di),'b.');
hold on;
mesh(B.xb,B.yb,zeros(size(B.xb)),zeros(size(B.yb)));
mesh(B.x,B.y,zeros(size(B.x)),ones(size(B.y)));
colormap([.8 .8 .8;1 0 0])
hold off
axis equal
xlabel('position x [mm]')
ylabel('position y [mm]')
title(sprintf('horizontal scale factor %2.1f mm, vertical scale factor %2.1f mm',B.kx,B.ky)) 
