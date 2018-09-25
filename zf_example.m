iterat = 100000;
SNR_vec =0:10;
BER_vec = [];

for SNR = SNR_vec
    suma = 0;
    for ii = 1:iterat
        
        % Defining the channel
        H = [1 2; 3 1 ; 1 4];
        
        pseudo_inv = inv(H' * H) * H';
        
        % Defining the simbol to be transmitted
        x_ini = [1 ; -1];
        x = x_ini./sqrt(x_ini'*x_ini);
        
        % Defining the Gaussian Noise
        SNR_linear = 10^(-SNR/10);
        n = sqrt(SNR_linear)*randn(3,1);
        
        % Receiving signal
        y = H*x+n;
        
        % ZF receiver
        x_hat = pseudo_inv * y;
        
        
        % Hard Decision
        x_detected = 2*(x_hat>0)-1;

        evaluation = abs(x_ini-x_detected);
        errors_x = evaluation > 0;
        erros = sum(errors_x);
        suma = suma+erros;
    end
    
    BER = suma/(2*iterat);
    BER_vec = [BER_vec BER];
    
end

semilogy(SNR_vec,BER_vec)
grid on