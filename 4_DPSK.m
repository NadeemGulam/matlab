clc;
clearall;
closeall;

% Input data
N = 1e6; % number of bits or symbols
EbN0dB = 0:2:16; % multiple Eb/N0 values
M = 2; % DPSK constellation

% Constellation 2-DPSK
refArray = [ 1.0000 + 0.0000i 0.0000 + 1.0000i -1.0000 + 0.0000i -0.0000 - 1.0000i];

symErrSimulated = zeros(1,length(EbN0dB));
k = log2(M); % number of bits per symbol
EsN0dB = EbN0dB + 10*log10(k);

%—Generating a uniformly distributed random numbers in the set [0,1,2,..,2M-1]
data = 2*ceil(M.*rand(N,1))-1;

%—generating differential modulated symbols
% phi[k] = phi[k-1] + Dphi[k]
data_diff = filter(1,[1 -1],data); % start with 0 phase
s = refArray(mod(data_diff,2*M)+1);

%—Place holder for Symbol Error values for each Es/N0 for particular M value–
index =1;

for x = EsN0dB,
%——————————————-
%Channel Noise for various Es/N0
%——————————————-
%Adding noise with variance according to the required Es/N0
noiseVariance = 1/(10.^(x/10));%Standard deviation for AWGN Noise
noiseSigma = sqrt(noiseVariance/2);
%Creating a complex noise for adding with M-PSK modulated signal
%Noise is complex since M-PSK is in complex representation
noise = noiseSigma*(randn(1,N)+1i*randn(1,N));
received = s + noise; % additive white gaussian noise

%————-I-Q Branching—————
% non-coherent demodulation
estPhase = angle(received);
% Dphi[k] = phi[k] – phi[k-1]
est_diffPhase = filter([1 -1],1,estPhase)*M/pi;

%—DecisionMaker-Compute—————
y = mod(2*floor(est_diffPhase/2)+1,2*M); % quantizing

%————–Symbol Error Rate Calculation——————————-
symErrSimulated(1,index) = sum(y~=data')/(N*k);
index=index+1;
end

%—– Compute Theoretical Symbol Error Rates ———————
%EsN0lin = 10.^(EsN0dB/10);
EbN0lin = 10.^(EbN0dB/10);
% Binary DPSK
symErrTheory = 0.5*exp(-EbN0lin);

��Plottingcommands��
figure;
semilogy(EbN0dB,symErrTheory,'b','LineWidth',1.5);hold on;
semilogy(EbN0dB,symErrSimulated,'r*','LineWidth',1.5);hold on;
legend({'Theory','Simulated'})
gridon;
xlabel('Eb/N0(dB)');
ylabel('Bit Error Rate (Pb)');
title('Simulation BER vs. Theoretical BER for Binary DPSK');