clear
close all

% add Card's data

card = readtable ( 'C:\Users\elisa\Documents\GitHub\ps5-bayesianols-elisataveras\card.csv' ) ;

% run OLS

fitlm([card.educ card.exper card.smsa card.black card.south],card.lwage)

% generate variables:
X=[ones(3010,1) card.educ card.exper card.smsa card.black card.south];

%saving the parameters and they std
K=6;
N=3010;
b=[4.9133 ;0.073807 ;0.039313 ;0.16474 ;-0.18822 ;-0.12905 ];

%variance matrix 

std0=0.063121 ;
std1=0.0035336 ;
std2=0.0021955 ;
std3=0.015692 ;
std4=0.017768 ;
std5=0.015229 ;

st=[std0; std1;std2 ;std3;std4;std5];


Var=(st.^2) ;

% 2) Doing the M-H to the model 
%First using the flat distribution

% Experimenting with the variance: use standard deviation proportional to the standard errors
proportion=0.0015; %to target acceptance rate
%define the sigma matrix for the likelihood function
S= proportion*[[bsxfun(@times,Var,eye(K)) zeros(K,1)];[zeros(1,K) (rmse^2)]];

Par=[b;rmse^2];

Y=card.lwage;

%PARAMETERS   
burnin = 1000; % number of burn-in iterations
%store acceptance rate 
acc0 = [0 0]; % vector to track the acceptance rate
%FIRST, THE BURNIN TO FIGURE THE ACCEPTANCE RATE TO HIT THE IDEAL VALUE  
for i  = 1:burnin                        
    [B,a] = MHstepOLS(Par,S,X,Y); 
    acc0   = acc0 + [a 1];          
end

%get the acceptance rate: 
    acc0(1)/acc0(2)   
%DO THE ACTUAL SAMPLE     
% acceptance rate of 0.22 with r=0.0015; I will use this one then 

%PARAMETERS 
lag=1;
nsamp  = 1000000;     
parMatrix    = zeros(nsamp,7); 
%store acceptance rate 
acc1 = [0 0]; % vector to track the acceptance rate
for i = 1:nsamp
    for j=1:lag
        [Par,a] = MHstepOLS(Par,S,X,Y);
        acc1 = acc1 + [a 1];
    end
    parMatrix(i,:) = Par';
end

[[mean(parMatrix(:,1));mean(parMatrix(:,2));mean(parMatrix(:,3));...
    mean(parMatrix(:,4));mean(parMatrix(:,5));mean(parMatrix(:,6));mean(parMatrix(:,7))]
    [var(parMatrix(:,1));var(parMatrix(:,2));var(parMatrix(:,3));...
    var(parMatrix(:,4));var(parMatrix(:,5));var(parMatrix(:,6));var(parMatrix(:,7))]]

% histograms
histogram(parMatrix(:,1),'Normalization','probability')
title('Histogram Constant');
histogram(parMatrix(:,2),'Normalization','probability')
title('Histogram Coefficient Education');
histogram(parMatrix(:,3),'Normalization','probability')
title('Histogram Coefficient Experience');
histogram(parMatrix(:,4),'Normalization','probability')
title('Histogram Coefficient smsa');
histogram(parMatrix(:,5),'Normalization','probability')
title('Histogram Coefficient Black');
histogram(parMatrix(:,6),'Normalization','probability')
title('Histogram Coefficient South');
histogram(parMatrix(:,7),'Normalization','probability')
title('Histogram Coefficient Root Mean Squared Error');


% the second version considering the numbers that we are given:
Veduc=(0.06-0.035)^2/4;
E=0.06;

%PARAMETERS 
lag=1;
nsamp  = 1000000;     
parMatrix    = zeros(nsamp,7); 
%store acceptance rate 
acc2 = [0 0]; % vector to track the acceptance rate
for i = 1:nsamp
    for j=1:lag
        [Par,a] = MHstepOLS2(Par,S,X,Y,Veduc,E);
        acc2 = acc2 + [a 1];
    end
    parMatrix(i,:) = Par';
end

% histograms
histogram(parMatrix(:,1),'Normalization','probability')
title('Histogram Constant');
histogram(parMatrix(:,2),'Normalization','probability')
title('Histogram Coefficient Education');
histogram(parMatrix(:,3),'Normalization','probability')
title('Histogram Coefficient Experience');
histogram(parMatrix(:,4),'Normalization','probability')
title('Histogram Coefficient smsa');
histogram(parMatrix(:,5),'Normalization','probability')
title('Histogram Coefficient Black');
histogram(parMatrix(:,6),'Normalization','probability')
title('Histogram Coefficient South');
histogram(parMatrix(:,7),'Normalization','probability')
title('Histogram Coefficient Root Mean Squared Error');






