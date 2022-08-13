Eyediagram:
clc;
closeall;
clearall;

%Generate 400 random bits
data = sign(randn(1,400)); 
%Define the symbol period
T = 64; 
Td = 32;
%Generate impulse train
dataup=upsample(data, T); 

%Return to zero polar signal
yrz=conv(dataup,[zeros(1,T/4) ones(1,T/2) zeros(1,T/4)]); 
yrz=yrz(1:end-T+1);

%Non-return to zero polar signal
ynrz=conv(dataup, ones(1,T));
ynrz=ynrz(1:end-T+1);

%half sinusoid polar signal
ysine=conv(dataup, sin(pi*[0:T-1]/T)); 
ysine=ysine(1:end-T+1);

% generating RC pulse train and rolloff factor = 0.5
yrcos=conv(dataup, rcosfir(0.5, Td, T,1,'normal')); 
yrcos=yrcos(2*Td*T:end-2*Td*T+1); 

eye1=eyediagram(yrz,T,T,T/2);title('RZ eye-diagram');grid('on');ylim([-1.5,1.5]);xlim([-Td-2,Td+2])
eye2=eyediagram(ynrz,T,T,T/2);title('NRZ eye-diagram');grid('on');ylim([-1.5,1.5]);xlim([-Td-2,Td+2])
eye3=eyediagram(ysine,T,T,T/2);title('Half-sine eye-diagram');grid('on');ylim([-1.5,1.5]);xlim([-Td-2,Td+2])
eye4=eyediagram(yrcos,2*T,T); title('Raised-cosine eye-diagram');grid('on');ylim([-1.5,1.5]);xlim([-Td-2,Td+2])
