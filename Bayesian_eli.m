clear
close all

% add Card's data

card = readtable ( 'C:\Users\elisa\Documents\GitHub\ps5-bayesianols-elisataveras\card.csv' ) ;

% run OLS

fitlm([card.educ card.exper card.smsa card.black card.south],card.lwage)

% generate variables:
X=[ones(3010,1) card.educ card.exper card.smsa card.black card.south];

%saving the parameters and they std

b=[4.9133 ;0.073807 ;0.039313 ;0.16474 ;-0.18822 ;-0.12905 ];
rmse=0.377 ;
K=6;
N=3010;
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
proportion=0.0010; %to target acceptance rate
%define the sigma matrix for the likelihood function
S= proportion*[[bsxfun(@times,Var,eye(k)) zeros(k,1)];[zeros(1,k) (rmse^2)]];

Par=[b;rmse^2];

Y=card.lwage;

%PARAMETERS 
nsamp  = 1000;     
parMatrix    = zeros(7,nsamp); 
burnin = 1000; % number of burn-in iterations
lag = 1; % iterations between successive samples
%store acceptance rate 
acc = [0 0]; % vector to track the acceptance rate

%FIRST, THE BURNIN TO FIGURE THE ACCEPTANCE RATE TO HIT THE IDEAL VALUE  
for i  = 1:burnin                        
    [B,a] = MHstepOLS(Par,S,X,Y); 
    acc   = acc + [a 1];          
end

%get the acceptance rate: 
    acc(1)/acc(2)   

    
%DO THE ACTUAL SAMPLE     
% acceptance rate of 0.22 with r=0.0015; I will use this one then 

%PARAMETERS 
nsamp  = 1000000;     
parMatrix    = zeros(nsamp,7); 
burnin = 1000; % number of burn-in iterations
lag = 1; % iterations between successive samples
%store acceptance rate 
acc = [0 0]; % vector to track the acceptance rate

for i = 1:nsamp
    for j=1:lag
        [Beta,a] = MHstepOLS(Par,S,X,Y);
        acc = acc + [a 1];
    end
    parMatrix(i,:) = Beta';
end

    acc(1)/acc(2) 

% histograms
histogram(parMatrix(:,1),'Normalization','probability');

% the second version  






