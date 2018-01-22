%% CLEAN
close all;
clear;
clc;
 
%% SYSTEM PARAMETERS
systemParam.nDataBits           = 1e6;          % Number of tansmitted bits
systemParam.coding.type         = 'slowStrong';       % Coding type {'fast','slowWeak','slowStrong','none'}
systemParam.interleaving.type   = 'shallow';       % Interleaving type {'deep','shallow','none'}
systemParam.mapping.type        = 'qpsk';       % Mapping type {'bpsk','qpsk','qam16','qam64','none'}
systemParam.ofdm.type           = 'generic';	% OFDM type {'generic','static-1','static-2','none'}
systemParam.equalization.type   = 'none';         % Equalization type {'zf','none'}
systemParam.multipath.type      = 'none';	% Multipath type {'static-1','static-2','none'}
systemParam.awgn.EbNoVec        = (-6:2:10);     % Eb/No vector in dB {(-10:15),'none'}
systemParam.awgn.EbNo           = 10;  
systemParam.results.enabled     = true;         % Results enabled {true,false}

%% SYSTEM INITIALIZATION
systemParam = initGroup(systemParam);
systemParam = initCoding(systemParam);
systemParam = initInterleaving(systemParam);
systemParam = initMapping(systemParam);
systemParam = initOfdm(systemParam);
systemParam = initEqualization(systemParam);
systemParam = initMultipath(systemParam);

%% TRANSMITTER
simbolos_recibidos=0;
disp('-- Link simulation --------------------------------------------------');
disp('Transmitter ...');
txBits = sourceTx(systemParam);                                             % Data generator
txBitsEncoded = encoder(systemParam,txBits);                                % Encoder
txBitsEncodedInterleaved = interleaver(systemParam,txBitsEncoded);         % Interleaver
rxBitsEncodedDeinterleaved = deinterleaver(systemParam,txBitsEncodedInterleaved);
rxBitsDecoded= decoder(systemParam,rxBitsEncodedDeinterleaved);
%txSymbols = mapper(systemParam,txBitsEncoded);                              % Symbol mapper
txSymbols = mapper(systemParam,txBitsEncodedInterleaved);                              % Symbol mapper
[txOfdmSymbols,indexPilotSc_f] = ofdmModulator(systemParam,txSymbols);                       % OFDM modulator

%% MULTIPATH FADING CHANNEL
disp('Multipath fading channel ...');
rxMultipath = multipathChannel(systemParam,txOfdmSymbols);                 % Multipath fading channel

%% AWGN CHANNEL + RECEIVER
for EbNoIndex = 1:length(systemParam.awgn.EbNoVec)
    % AWGN channel
    systemParam.awgn.EbNo = systemParam.awgn.EbNoVec(EbNoIndex); 
  
    % Get Eb/No
    systemParam = initAwgn(systemParam);
    disp('AWGN channel ...');
%    rxOfdmSymbols = awgnChannel(systemParam,txOfdmSymbols);                   % AWGN channel
    rxOfdmSymbols = awgnChannel(systemParam,rxMultipath);                   % AWGN channel

    % Receiver
    disp('Receiver ...');
    [rxSymbols,HEstimated] = ofdmDemodulator(systemParam,rxOfdmSymbols,indexPilotSc_f);    % OFDM demodulator with channel equalization
    rxBitsEncodedInterleaved = demapper(systemParam,rxSymbols);             % Symbol demapper
    %Realizamos el de interleaving
    rxBitsEncoded = deinterleaver(systemParam,rxBitsEncodedInterleaved);
    %Realizamos el decoding
    rxBits= decoder(systemParam,rxBitsEncoded);
    
   
    %% BER computation
%    systemParam.results.berSimulated(EbNoIndex) = sum(xor(txBitsEncoded,rxBitsEncodedInterleaved')) / length(txBitsEncoded);
%    systemParam.results.berSimulated(EbNoIndex) = sum(xor(abs(txSymbols'),abs(rxSymbols)))/ length(txSymbols');
    systemParam.results.berSimulated(EbNoIndex) = sum(xor(txBits,rxBitsEncodedInterleaved')) / length(txBits);
    %disp(sum(xor(txBits,rxBitsEncodedInterleaved')) / length(txBits));
    
    
    % BER teorico
    if strcmp(systemParam.mapping.type,'bpsk')
      % Esta es solo systemParam.results.berTeorico(EbNoIndex) = berawgn(systemParam.awgn.EbNo,'psk',2,'nondiff');
      systemParam.results.berTeorico(EbNoIndex) = berawgn(systemParam.awgn.EbNoVec(EbNoIndex),'psk',2,'nondiff');
    elseif strcmp(systemParam.mapping.type,'qpsk')
      systemParam.results.berTeorico(EbNoIndex) = berawgn(systemParam.awgn.EbNoVec(EbNoIndex),'psk',2^systemParam.mapping.k,'diff');
       %systemParam.results.berTeorico(EbNoIndex) = berawgn(1,'psk',2^systemParam.mapping.k,'nondiff');
    elseif strcmp(systemParam.mapping.type,'qam16') || strcmp(systemParam.mapping.type,'qam64')
       systemParam.results.berTeorico(EbNoIndex) = berawgn(systemParam.awgn.EbNoVec(EbNoIndex),'qam',2^systemParam.mapping.k,'nondiff');
    else
        disp('Error en el tipo de modulación.');
    end

simbolos_recibidos=rxSymbols;


end

% for EbNoIndex = 1:length(systemParam.awgn.EbNoVec)
%     if EbNoIndex == length(systemParam.awgn.EbNoVec)
%         systemParam.results.berSimulated(EbNoIndex)=systemParam.results.berSimulated(EbNoIndex);
%     else        
%     systemParam.results.berSimulated(EbNoIndex)= systemParam.results.berSimulated(EbNoIndex+1);%+((systemParam.results.berSimulated(EbNoIndex+1)-systemParam.results.berSimulated(EbNoIndex)));
%     end
% end
%% SYSTEM RESULTS
showResults();