clc;
closeall;
clearall;


n = 4; % Number of bits i.e., 4-bit PCM 
L = 2^n; % Number of levels
numSamples = 12; % Twelve samples in one period

% Sampling Operation
x=0:2*pi/numSamples:4*pi;              
s=8*sin(x);
subplot(3,1,1);
plot(s);
title('Analog Signal');
ylabel('Amplitude');
xlabel('Time');
subplot(3,1,2);
stem(s);
gridon;  
title('Sampled Sinal');  
ylabel('Amplitude');  
xlabel('Time');

%  Quantization Process
vmax=8;
vmin=-vmax;
delta=(vmax-vmin)/L;
part=vmin:delta:vmax;                             
code=vmin-(delta/2):delta:vmax+(delta/2);        % Contain Quantized values 
[ind,q]=quantiz(s,part,code);                     % Quantization process
% ind contain index number and q contain quantized  values
l1=length(ind);
l2=length(q);

for i=1:l1
if(ind(i)~=0)                    % To make index as binary decimal so started from 0 to N
ind(i)=ind(i)-1;
end
    i=i+1;
end

for i=1:l2
if(q(i)==vmin-(delta/2))           % To make quantize value inbetween the levels
q(i)=vmin+(delta/2);
end
end
subplot(3,1,3);
stem(q);grid on;                               % Display the Quantize values
title('Quantized Signal');
ylabel('Amplitude');
xlabel('Time');

%  Encoding Process
figure
code=dec2bin(ind);             % Cnvert the decimal to binary
k=1;
for i=1:l1
for j=1:n
coded(k)=str2num(code(i,j));            % convert code matrix to a coded row vector
        j=j+1;
        k=k+1;
end
    i=i+1;
end
subplot(2,1,1); grid on;
stairs(coded);                                 % Display the encoded signal
axis([0 100 -2 3]);  title('Encoded Signal');
ylabel('Amplitude');
xlabel('Time');

%   Demodulation Of PCM signal

qunt=reshape(coded,n,length(coded)/n);
index=bin2dec(num2str(qunt'));                   % Getback the index in decimal form
q=delta*index+vmin+(delta/2);                       % getback Quantized values
subplot(2,1,2); grid on;
plot(q);                                        % Plot Demodulated signal
title('Demodulated Signal');
ylabel('Amplitude');
xlabel('Time');