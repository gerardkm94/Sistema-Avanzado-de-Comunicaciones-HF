%% CLEAN
close all;
clear;
clc;

%% SYSTEM PARAMETERS
systemParam.nDataBits           = 1e6;          % Number of tansmitted bits
systemParam.coding.type         = 'fast';       % Coding type {'fast','slowWeak','slowStrong','none'}
systemParam.interleaving.type   = 'none';       % Interleaving type {'deep','shallow','none'}
systemParam.mapping.type        = 'qpsk';       % Mapping type {'bpsk','qpsk','qam16','qam64','none'}
systemParam.ofdm.type           = 'generic';	% OFDM type {'generic','static-1','static-2','none'}
systemParam.equalization.type   = 'zf';         % Equalization type {'zf','none'}
systemParam.multipath.type      = 'static-1';	% Multipath type {'static-1','static-2','none'}
systemParam.awgn.EbNo           = 10;           % Eb/No in dB or no noise {-10,...,15,'none'}
systemParam.results.enabled     = true;         % Results enabled {true,false}

%% SYSTEM INITIALIZATION
systemParam = initGroup(systemParam);
%systemParam = initCoding(systemParam);
%systemParam = initInterleaving(systemParam);
systemParam = initMapping(systemParam);
systemParam = initOfdm(systemParam);
%systemParam = initEqualization(systemParam);
systemParam = initMultipath(systemParam);
%systemParam = initAwgn(systemParam);

%% TRANSMITTER
disp('-- Link simulation --------------------------------------------------');
disp('Transmitter ...');
txBits = sourceTx(systemParam);                                         % Data generator
txBitsEncoded = encoder(systemParam,txBits);                            % Encoder
%txBitsEncodedInterleaved = interleaver(systemParam,txBitsEncoded);      % Interleaver
txSymbols = mapper(systemParam,txBitsEncoded);%txBitsEncodedInterleaved);               % Symbol mapper
txOfdmSymbols = ofdmModulator(systemParam,txSymbols);                   % OFDM modulator

%% MULTIPATH FADING CHANNEL
disp('Multipath fading channel ...');
rxMultipath = multipathChannel(systemParam,txOfdmSymbols);              % Multipath fading channel

%% AWGN CHANNEL
disp('AWGN channel ...');
rxOfdmSymbols = awgnChannel(systemParam,rxMultipath);                   % AWGN channel

%% RECEIVER -> La EQ se realiza en el ofdmDemodulatorllamando a la funcion equialization.m
disp('Receiver ...');
[rxSymbols,HEstimated] = ofdmDemodulator(systemParam,rxOfdmSymbols);    % OFDM demodulator with channel equalization
rxBitsEncodedInterleaved = demapper(systemParam,rxSymbols);             % Symbol demapper
%rxBitsEncoded = deinterleaver(systemParam,rxBitsEncodedInterleaved);    % Deinterleaver
%rxBits = decoder(systemParam,rxBitsEncoded);                            % Decoder

%% SYSTEM RESULTS
showresulrs(systemParam);