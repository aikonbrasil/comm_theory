iterat = 100;
SNR_vec =-100:30;
BER_vec = [];

mu = 4;
numsymb = 2000;

for SNR = SNR_vec
    suma = 0;
    for ii = 1:iterat
        
        % Defining the channel
        H = [10 2; 30 1 ; 1 40];
        
        pseudo_inv = inv(H' * H) * H';
        
        % Defining the simbol to be transmitted
        s = randi(2^mu, [numsymb, 1])-1;
        
        % QAM MAP Symbols (With Unit Energy --> each Symbol)
        d = qammod(s, 2^mu, 0, 'gray');
        d = d / sqrt(2/3 * (2^mu - 1));
        
        % Reshape to be input of MIMO system
        x = reshape(d,2,numsymb/2);
        
        % Defining the Gaussian Noise
        %SNR_linear = 10^(-SNR/10);
        %n = sqrt(SNR_linear)*randn(3,1);
        
        n = awgn(zeros(3,numsymb/2),SNR);
        
        % Receiving signal
        y = H*x+n;
        
        % ZF receiver
        x_zf = pseudo_inv * y;
        
        % QAM Demodulate
        x_zf = x_zf * sqrt(2/3 * (2^mu - 1));
        s_zf= qamdemod(x_zf, 2^mu, 0, 'gray');
        
        % Counting errors
        s_zf = reshape(s_zf,numsymb,1);
        suma = suma+sum(s_zf ~= s);
        
    end
    
    BER = suma/(numsymb*iterat);
    BER_vec = [BER_vec BER];
    
end

semilogy(SNR_vec,BER_vec,'k')
grid on