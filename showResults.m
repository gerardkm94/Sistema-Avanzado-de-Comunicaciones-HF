
if systemParam.mapping.enabled == true
    %scatterplot(systemParam.mapping.mapper.constellation);
    scatterplot(systemParam.mapping.mapper.constellation,1,0,'x');
    grid on
    title(['Constellation (' systemParam.mapping.type ' type)']);xlabel('I');ylabel('Q');
end

if systemParam.multipath.enabled == true
   
    t = (0:1:length(systemParam.multipath.h)-1);
    figure
    % acabar de mirar el resultado de estos plots.
    subplot(2,1,1);stem((t/systemParam.ofdm.samplingFrequency)/1000,cat(2,abs(systemParam.multipath.h)),'o');
    title('Multipath channel response');xlabel('time[s]');ylabel('|h|²');
    subplot(2,1,2);plot(abs(systemParam.multipath.H));
    xlabel('frez[Hz]');ylabel('|H|²');
         
end

    
% elseif systemParam.results.berSimulated == true % calculo del BER
%     
%     % coded - only bpsk or qpsk
%     if systemParam.results.berCodedAwgn == true
%         if strcmp(systemParam.mapping.type,'bpsk')
%             BER = berawgn(systemParam.awgnChannel.EbNo, systemParam.mapping.type,2,'nondiff');  
%             seminology(BER);
%         elseif strcmp(systemParam.mapping.type,'qpsk')
%             BER = berawgn(systemParam.awgnChannel.EbNo, systemParam.mapping.type,systemParam.mapping.k^2,'nondiff');  
%             seminology(BER);    
%         end
%         
%     % uncoded
%     elseif systemParam.results.berUncodedAwgn == true
%         BER = berawgn(systemParam.awgnChannel.EbNo, systemParam.mapping.type,systemParam.mapping.k^2,'nondiff');  
%         seminology(BER);
%     end
% end



%Pintamos el BER ideal y el Simulado para el tipo de simulación que toque:
figure
semilogy(systemParam.awgn.EbNoVec,[systemParam.results.berSimulated],'g');
hold on
semilogy(systemParam.awgn.EbNoVec,[systemParam.results.berTeorico],'r');
legend('Simulado','Uncoded AWGN')
grid on
title('Bit Error Rate');xlabel('Eb/N0 (dB)');ylabel('BER');
hold off

scatterplot(simbolos_recibidos,1,0,'x');
grid on
title(['Received symbols (' systemParam.mapping.type ' type)']);xlabel('I');ylabel('Q');


% figure
% scatterplot(rxSymbols,1,0,'x');
% grid on
% title(['Received symbols (' systemParam.mapping.type ' type)']);xlabel('I');ylabel('Q');

%PSD

% Potencia= txOfdmSymbols.^2/length(txOfdmSymbols);
% HPSD = dspdata.psd(fftshift(abs(fft(Potencia(1:length(Potencia))))),'CenterDc',length(Potencia)/2);
% figure 
% plot(HPSD)
  
