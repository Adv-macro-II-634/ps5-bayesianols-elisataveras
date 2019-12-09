function [parMatrix,a] = MHstepOLS(Par,S,X,Y)
% drawing the value of the parameters from the normal distriution
Par1 = mvnrnd(Par,S,1)'; % drawing from normal distribution
[N,K]  = size(X);
%generate the two likelihood functions 
LikeOrig=(-(N/2)*log(2*pi)-(N/2)*log(Par(K+1))-(1/(2*Par(K+1)))*((Y-X*Par(1:K))'*(Y-X*Par(1:K))));
LikeNew=(-(N/2)*log(2*pi)-(N/2)*log(Par1(K+1))-(1/(2*Par1(K+1)))*((Y-X*Par1(1:K))'*(Y-X*Par1(1:K))));
accprob = LikeNew -LikeOrig; % acceptance probability
u = log(rand); % uniform random number
if u <= accprob % if accepted
parMatrix = Par1; % new point is the candidate
a = 1; % note the acceptance
else % if rejected
parMatrix = Par; % new point is the same as the old one
a = 0; % note the rejection
end
