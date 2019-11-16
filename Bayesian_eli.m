clear
close all

% add Card's data

card = readtable ( 'C:\Users\elisa\Documents\GitHub\ps5-bayesianols-elisataveras\card.csv' ) ;

% run OLS

fitlm([card.educ card.exper card.smsa card.black card.south],card.lwage)
