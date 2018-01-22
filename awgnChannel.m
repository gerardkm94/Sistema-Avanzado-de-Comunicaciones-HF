function rxOfdmSymbols = awgnChannel(systemParam,rxMultipath)


%% Esta función de delimita a añadir ruido gausiano a los datos Rx que han 
% pasado previamente por el el multipath fadding channel. Para ello en el
% initAwgn creo las variables .EsNo (para calcular la SNR) y .SNR.

% Cojo el help: % https://es.mathworks.com/help/comm/ug/awgn-channel.html
% Extraigo la relación de Eb/No con Es/No y despues calculo la SNR(dB)
% para usar la función awgn(x,SNR) y añadirle ruido blanco gausiano a
% nuestra señal compleja:
% 1) Es/N0 (dB)=Eb/N0 (dB)+10log10(k) -> number of information bits per symbol (k)
% 2) Es/N0 (dB)=10log10(Tsym/Tsamp)+SNR? (dB)   for complex input signal
% Tsym is the signal's symbol period and Tsamp is the signal's sampling period.
if systemParam.awgn.enabled==true
    EsNo =  systemParam.awgn.EbNo+10*log10(systemParam.mapping.k);
    %SNR = EsNo - 10*log10(systemParam.ofdm.symbolTime/(1/systemParam.ofdm.samplingFrequency));

    SNR = EsNo - 10*log10(systemParam.ofdm.oversamplingFactor);
    disp('Oversampligfactor:');disp(systemParam.ofdm.oversamplingFactor);
    disp('EsNo:');disp(EsNo);
    disp('SNR:');disp( SNR);
    %SNR = systemParam.awgn.EbNo  + 10*log10(systemParam.mapping.k) - 10*log10(systemParam.ofdm.oversamplingFactor);
    rxOfdmSymbols = awgn (rxMultipath,SNR,'measured');
   %rxOfdmSymbols = awgn (rxMultipath,SNR,'measured');
    %rxOfdmSymbols = rxMultipath;
    % Coger el ruido y sumarlo a la salida (el ruido creado por un randn)
    % rxOfdmSymbols = rxMultipath + systemParam.awgn.SNR; 
else 
    rxOfdmSymbols=rxMultipath;
end