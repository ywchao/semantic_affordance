function [U, V, RMSE, time, numIters] = kpmf_gd_ywc(R, mask, D, K_u_inv, K_v_inv, sigma_r, ...
    eta, R2, mask2, init, epsilon, maxIters, minIters, verbose)
%
% Author: Tinghui Zhou, Hanhuai Shan
%
% KPMF with gradient descent
%
% N:        num of rows in R
% M:        num of cols in R
% D:        latent dimensions
% 
% Input:
%   R:          N*M, matrix for training
%   mask:       N*M, indicator matrix, 1 indicates a valid entry
%   D:          latent dimensions
%   K_u_inv:    N*N, precision matrix on rows
%   K_v_inv:    M*M, precision matrix on columns
%   sigma_r:    scaler, variance for the univariate Gaussian to generate each entry
%               in R
%   eta:        scaler, learning rate
%   R2:         N*M, validate matrix
%   mask2:      N*M, indicator matrix for the validation set
%
% Output:
%   U:          N*D, latent matrix on rows
%   V:          M*D, latent matrix on columns
%   RMSE:       scaler, RMSE on validation set
%   time:       running time
%----------------------------------------------------------------------

if ~exist('verbose','var')
    verbose = true;
end

if ~exist('epsilon','var')
    epsilon = 0.00001;
end

if ~exist('maxIters','var')
    maxIters = 200;
end

if ~exist('minIters','var')
    minIters = 5;
end

tic;

N = size(R, 1);     % #rows
M = size(R, 2);     % #columns

denomCompU = K_u_inv + K_u_inv';
denomCompV = K_v_inv + K_v_inv';

%**************************************************************************

% Initialize U and V

if isempty(init)
    Rsvd=R.*mask+sum(sum(R.*mask))/sum(sum(mask))*(1-mask);
    [U,S,V]=svds(Rsvd,D);
    U=U*sqrt(S);
    V=V*sqrt(S);
else
    U = init.U_init;
    V = init.V_init;
end

%**************************************************************************

numIters = 0;
% epsilon=0.00001;
% max and min number of iterations
% maxIters=200;
% minIters=50;

while(numIters<maxIters)
    
    % Gradient descent on U
    U_new = zeros(N, D);    
    UV=U*V';  
    pDeriv=eye(N);
    for d=1:D
        firstTerm=sum((R-UV).*(-ones(N,1)*V(:,d)').*mask,2);
        secTerm=0.5*pDeriv'*denomCompU*(U(:,d))*sigma_r^2;
        U_new(:,d)=U(:,d)-eta*(firstTerm+secTerm);
    end
    
    U=U_new;
    
    % Gradient descent on V;
     V_new = zeros(M, D);    
     UV=U*V';
     pDeriv=eye(M);
     for d=1:D
         firstTerm=sum((R-UV).*(-U(:,d)*ones(1,M).*mask),1);
         secTerm=0.5*pDeriv'*denomCompV*V(:,d)*sigma_r^2;
         V_new(:,d)=V(:,d)-eta*(firstTerm'+secTerm);
     end

    % Update U and V
    U = U_new;
    V = V_new;
    numIters = numIters + 1;
    
    % Calculate the objective function with current U and V
    tmpMat = mask.*((R - U*V').^2);
    err = 0.5 * sum(tmpMat(:)) / (sigma_r^2);
    for d = 1 : D
        err = err + 0.5 * ((U(:,d))'*K_u_inv*(U(:,d)) + (V(:,d))'*K_v_inv*(V(:,d)));%* sigma_r^2; % FIXME: sigma_r
    end
    E(numIters) = err;
    
    n = sum(mask2(:));
    tmpMat = mask2.*((R2 - U*V').^2);
    RMSE(numIters) = sqrt(sum(tmpMat(:))/n);
    
    % R_raw = U*V';
    % R_out = R_raw;
    % R_out(R_out >= 0) = 1;
    % R_out(R_out < 0)  = -1;
    %
    % pred_raw = R_raw(b,:);
    % pred_out = R_out(b,:);
    % 
    % % compute accuracy
    % rmse_t = sqrt(sum((pred_raw - gt(b,:)).^2,2)/numel(pred_raw));
    % acc = sum(pred_out ==gt(b,:))/numel(pred_out);
    
    if verbose
        % disp(['iter' ,int2str(numIters),', err=',num2str(err), ', rmse=', num2str(RMSE(numIters))]);
        disp(['iter' ,num2str(numIters,'%04d'),', err=',num2str(err,'%10.4f'), ', rmse=', num2str(RMSE(numIters),'%15.13f')]);
        % disp(['iter' ,num2str(numIters,'%04d'),', err=',num2str(err,'%10.4f'), ', rmse=', num2str(RMSE(numIters),'%15.13f'), ...
        %     ', rmse_t=', num2str(rmse_t,'%10.4f'), ', acc=', num2str(acc,'%6.4f')]);
    end

    if (numIters > minIters  && (RMSE(numIters-1) - RMSE(numIters))/RMSE(numIters-1)<epsilon )
        break;
    end

end

time=toc;
