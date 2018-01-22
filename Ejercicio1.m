% Considerar sistema formado por: CODER + INTERLEAVER + MAPPER

% MAX BIT RATE que se puede conseguir considerando:
% - Desactivar multipath
% - Ancho de banda de transmision: 3 KHz
% - SNR maxima esperada: 3dB
% - BER maximo admisible: 1e-3 (simulated)

% INDICAR
% - Codificador convolucional: tipo
% - Interleaver convolucional: tipo
% - Mapper: tipo
% - Prestaciones: nDataBits, EbNo, SNR, Achieved bit rate, BER (teorico), BER
% - conseguido (simulated).
 
%% DEFINICION DE PARAMETROS
systemParam.nDataBits           = 1e6;           % nDataBits
systemParam.coding.type         = 'slowStrong';  % Codificador convolucional: tipo {'fast','slowWeak','slowStrong','none'}
systemParam.interleaving.type   = 'shallow';     % Interleaver convolucional: tipo {'deep','shallow','none'}
systemParam.mapping.type        = 'qpsk';        % Mapper: tipo {'bpsk','qpsk','qam16','qam64','none'}
systemParam.ofdm.type           = 'generic';	% OFDM type {'generic','static-1','static-2','none'}
systemParam.awgn.EbNoVec        = (-6:2:10);     % Eb/No vector in dB {(-10:15),'none'}
systemParam.awgn.EbNo           = 10;  
systemParam.results.enabled     = true;         % Results enabled {true,false}

systemParam = initCoding(systemParam);
systemParam = initInterleaving(systemParam);
systemParam = initMapping(systemParam);
systemParam = initOfdm(systemParam);

%% TRANSMISOR
disp('-- Link simulation --------------------------------------------------');
disp('Transmitter ...');
txBits = sourceTx(systemParam);                                             % Data generator
txBitsEncoded = encoder(systemParam,txBits);                                % Encoder
txBitsEncodedInterleaved = interleaver(systemParam,txBitsEncoded);         % Interleaver
txSymbols = mapper(systemParam,txBitsEncodedInterleaved);                              % Symbol mapper

%% AWGN CHANNEL + RECEIVER

% disp('-- Link simulation --------------------------------------------------');
% disp('Receiver ...');
% rxBitsEncodedInterleaved = demapper(systemParam,txSymbols);             % Symbol demapper
% rxBitsEncodedDeinterleaved = deinterleaver(systemParam,rxBitsEncodedInterleaved);
% rxBits = decoder(systemParam,rxBitsEncodedDeinterleaved);

%% AWGN CHANNEL + RECEIVER
for EbNoIndex = 1:length(systemParam.awgn.EbNoVec)
    % AWGN channel
    systemParam.awgn.EbNo = systemParam.awgn.EbNoVec(EbNoIndex); 
  
    % Get Eb/No
    systemParam = initAwgn(systemParam);
    disp('AWGN channel ...');
%    rxOfdmSymbols = awgnChannel(systemParam,txOfdmSymbols);                   % AWGN channel
    rxOfdmSymbols = awgnChannel(systemParam,txSymbols);                   % AWGN channel

    rxBitsEncodedInterleaved = demapper(systemParam,rxOfdmSymbols);             % Symbol demapper
    rxBitsEncodedDeinterleaved = deinterleaver(systemParam,rxBitsEncodedInterleaved);
    rxBits = decoder(systemParam,rxBitsEncodedDeinterleaved);
  
%     % Receiver
%     disp('Receiver ...');
%     rxBitsEncodedInterleaved = demapper(systemParam,rxOfdmSymbols);             % Symbol demapper
%     %Realizamos el de interleaving
%     rxBitsEncoded = deinterleaver(systemParam,rxBitsEncodedInterleaved);
%     %Realizamos el decoding
%     rxBits= decoder(systemParam,rxBitsEncoded);
   
    %% BER computation
    systemParam.results.berSimulated(EbNoIndex) = sum(xor(txBits,rxBitsEncodedInterleaved')) / length(txBits);
    %disp(sum(xor(txBits,rxBitsEncodedInterleaved')) / length(txBits));    
    
    % BER teorico
    if strcmp(systemParam.mapping.type,'bpsk')
      systemParam.results.berTeorico(EbNoIndex) = berawgn(systemParam.awgn.EbNoVec(EbNoIndex),'psk',2,'nondiff');
    elseif strcmp(systemParam.mapping.type,'qpsk')
      systemParam.results.berTeorico(EbNoIndex) = berawgn(systemParam.awgn.EbNoVec(EbNoIndex),'psk',2^systemParam.mapping.k,'diff');
    elseif strcmp(systemParam.mapping.type,'qam16') || strcmp(systemParam.mapping.type,'qam64')
       systemParam.results.berTeorico(EbNoIndex) = berawgn(systemParam.awgn.EbNoVec(EbNoIndex),'qam',2^systemParam.mapping.k,'nondiff');
    else
        disp('Error en el tipo de modulación.');
    end

simbolos_recibidos=rxSymbols;


end

%% SYSTEM RESULTS
showResults();
