function Pb=sensitivity_analysis(B,I,bw,NF,f_RF,sigma_z)
% function sensitivity_analysis(B,[I],[bw],[NF])
% 
% Input:  B = a structure with geometry defined and calculated induced
% charge and scale factors determined
%         I = optional beam current in A, default 300mA
%         bw= optional bandwidth in Hz, default 1MHz
%         NF= optional Noise Figure of receiver, default 20dB
%         sigma_z= bunch length in s, default 17ps
%
% calculates button capacitance, power on one button, noise power in
% bandwidth, and intrinsic resolution.
if ~exist('I','var')
    I=0.3;
end
if ~exist('bw','var')
    bw=1e6;
end
if ~exist('NF','var')
    NF=20;
end
if ~exist('sigma_z','var')
    sigma_z=17e-12;
end
if ~exist('f_RF','var')
    f_RF=500e6;
end

fprintf('assumed beam current %3.1f mA\n',I*1000);

fprintf('fraction of wall current on button A within rastered area\n   MIN %3.3f  CENTRED %3.3f  MAX %3.3f\n',...
    min(min(B.a)),B.a(B.cyi,B.cxi),max(max(B.a)))

% calculate button capacitance (cylindrical capacitor)
epsilon0=8.85*1e-12;     % Vacuum permittivity
rb=(B.bdia/2)*1e-3;     % button radius
Cb=((2*pi*epsilon0*B.bt*1e-3)/(log((rb+B.bg*1e-3)/rb)));
fprintf('button capacitance %3.2f pF\n',Cb*1e12)

% calculate power from button
omega=2*pi*f_RF;	%RF frequency (Hz)
omega1=1/(50*Cb);
omega2=3e8/(2*rb);
% average power from button into 50 Ohms formula (A.8) in http://www.lnf.infn.it/acceleratori/dafne/NOTEDAFNE/CD/CD-6.pdf
% DAPHNE TECHNICAL NOTE CD-6, "DA?NE BROAD-BAND BUTTON ELECTRODES", F. Marcellini, M. Serio, M. Zobov
%
Pb=0.5*(I.^2)*50*B.a(B.cyi,B.cxi)^2*(omega1/omega2)^2*((omega/omega1).^2)./(1+((omega/omega1).^2));

fprintf('power from one button with beam at centre: %4.1f uW  or %3.1f dBm   \n',Pb*1e6,10*log10(Pb*1000));

k=1.38e-23; %J/K Bolzman's constant
% noise power of receiver with given bandwidth bw and noise figure NF
Pn=k*290*10^(NF/10)*bw;
fprintf('noise power of receiver with noisefigure of %2.1f dB within bandwidth of %7.1f Hz : %3.1f dBm   \n',NF,bw,10*log10(Pn*1000));

% there is some variance in the factor to be applied to the noise to signal ratio: Everybody agrees the resolution scales with scale factor kx/ky 
% and with square root of noise to signal power. I argue in a four button geometry we have 4 noise contributions from four buttons which will add 
% up to four times the noise power, so the noise magnitude will be sqrt(4)=2 times higher, while the signal magnitudes will be added together.
sigmax=abs(B.kx)*sqrt(4*Pn)./(4*sqrt(Pb));
sigmay=abs(B.ky)*sqrt(4*Pn)./(4*sqrt(Pb));
fprintf('estimated resolution X/Y %3.2g um / %3.2g um\n',sigmax*1000,sigmay*1000);

% an estimate of the loss factor from the above DAPHNE paper, formula (12)
kl=50*B.a(B.cyi,B.cxi)^2*(omega1/omega2)^2/(pi*sigma_z)*(sqrt(pi)/2-pi/2*omega1*sigma_z/3e8*exp((omega1*sigma_z/3e8)^2)*(1-erf(omega1*sigma_z/3e8)));
fprintf('loss factor estimate for four buttons: %4.1f mV/pC \n',4*kl*1e-9);

