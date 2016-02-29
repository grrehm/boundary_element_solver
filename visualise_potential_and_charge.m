function visualise_potential_and_charge(B)
h=figure(1);
scatter(B.xm,B.ym,5,ones(length(B.xm),1),'filled');axis equal
hold on;
if isfield(B,'ai')
    plot(B.xm(B.ai),B.ym(B.ai),'kd',...
        B.xm(B.bi),B.ym(B.bi),'kd',...
        B.xm(B.ci),B.ym(B.ci),'kd',...
        B.xm(B.di),B.ym(B.di),'kd');
end
title('point somewhere with the mouse/crosshair and click')
drawnow
hold off
while true
    figure(h)
    try
        [x0,y0]=ginput(1);
    catch
        break
    end
    % calculate charge distribution on boundary from 'beam position'
    charge=(-log(sqrt((x0-B.xm).^2+(y0-B.ym).^2)))*B.invG;
    scatter(B.xm,B.ym,5,charge/max(charge),'filled');axis equal
    hold on;
    if isfield(B,'ai')
        plot(B.xm(B.ai),B.ym(B.ai),'kd',...
            B.xm(B.bi),B.ym(B.bi),'kd',...
            B.xm(B.ci),B.ym(B.ci),'kd',...
            B.xm(B.di),B.ym(B.di),'kd');
    end
    caxis([0 1])
    plot(x0,y0,'o')
    xlabel('position x [mm]')
    ylabel('position y [mm]')
    title('close figure to exit visualisation')
    %now calculate the potential over the cross section
    x=linspace(min(B.xg),max(B.xg),50);
    y=linspace(min(B.yg),max(B.yg),50);
    Gx=zeros(length(x),length(y));
    for xi=1:length(x)
        for yi=1:length(y)
            gg=0;
            for j=1:length(B.xm)
                gg=gg-log(sqrt((B.xm(j)-x(xi))^2+(B.ym(j)-y(yi))^2))*B.sl(j)*charge(j);
            end
            
            if (x(xi)==x0)&&(y(yi)==y0)
                Gx(xi,yi)=gg;
            else
                Gx(xi,yi)=gg+log(sqrt((x0-x(xi))^2+(y0-y(yi))^2));
            end
        end
    end
    contour(x,y,Gx.',25)
    hold off
end