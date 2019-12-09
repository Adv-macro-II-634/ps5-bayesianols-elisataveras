%we have a distribution for the coefficient of education
function [parNew,a] = MHstepOLS2(Par,S,X,Y,Veduc,E)
% drawing the value of the parameters from the normal distriution
Par1 = mvnrnd(Par,S,1)'; % drawing from normal distribution
[N,K]  = size(X);
%generate the two likelihood functions 
LikeOrig=(-(N/2)*log(2*pi)-(N/2)*log(Par(K+1))-(1/(2*Par(K+1)))*((Y-X*Par(1:K))'*(Y-X*Par(1:K))));
LikeNew=(-(N/2)*log(2*pi)-(N/2)*log(Par1(K+1))-(1/(2*Par1(K+1)))*((Y-X*Par1(1:K))'*(Y-X*Par1(1:K))));
LikeEOrig=(-(1/2)*log(2*pi)-(1/2)*log(Veduc)-(1/(2*Veduc))*((Par(2)-E)'*(Par(2)-E)));
LikeENew=(-(1/2)*log(2*pi)-(1/2)*log(Veduc)-(1/(2*Veduc))*((Par1(2)-E)'*(Par1(2)-E)));
accprob = LikeNew -LikeOrig+ (LikeENew-LikeEOrig); % acceptance probability
u = log(rand); % uniform random number
if u <= accprob % if accepted
parNew = Par1; % new point is the candidate
a = 1; % note the acceptance
else % if rejected
parNew = Par; % new point is the same as the old one
a = 0; % note the rejection
end
