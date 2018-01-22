%% CLEAN
close all;
clear;
clc;
 
%% SYSTEM PARAMETERS
systemParam.nDataBits           = 1000;          % Number of tansmitted bits
systemParam.coding.type         = 'slowWeak';   % Coding type {'fast','slowWeak','slowStrong','none'}
systemParam.interleaving.type   = 'shallow';    % Interleaving type {'deep','shallow','none'}
systemParam.results.enabled     = true;         % Results enabled {true,false}
porcentaje_errores              = 5;  %Expresar el porcentaje de errores que se quiere en el codigo de 0 a 100
rafaga                          ='si'; %Indicar si se quiere que el porcentaje sea repartido en rafagas o no
numero_rafagas                  =1;     %Number of bursts, must be consistent with the error rate

%% SYSTEM INITIALIZATION
systemParam = initGroup(systemParam);
systemParam = initCoding(systemParam);
systemParam = initInterleaving(systemParam);

%% TRANSMITTER
disp('-- Link simulation --------------------------------------------------');
disp('Transmitter ...');
% GENERACION DE DATOS FIJA PARA 1000 BITS CON EL OBJETIVO DE PROBAR EL
% SISTEMA SOBRE LA MISMA FUENTE Y EVALUAR SU MEJORIA
txBits = sourceTx(systemParam);
% CODIFICACION
txBitsEncoded = encoder(systemParam,txBits);
% Interleaver
txBitsEncodedInterleaved = interleaver(systemParam,txBitsEncoded);         
%% RECEIVER
disp('Receiver ...');

% Por si tenemos anulado el interleaver
if strcmp(systemParam.interleaving.type,'none')
    % Decoding
    %GENERACION DE ERRORES SIN INTERLEAVER (Simulacion de canal)
    rxBitsError = error_generator(systemParam,txBitsEncodedInterleaved,porcentaje_errores,rafaga,numero_rafagas);
    %DECODIFICACION 
    rxBitsDecoded= decoder(systemParam,rxBitsError);
elseif strcmp(systemParam.interleaving.type,'deep')||strcmp(systemParam.interleaving.type,'shallow')
    % Deinterleaving
    %GENERACION DE ERRORES CON INTERLEAVER (Simulacion de canal)
    txBitsEncodedInterleaved = error_generator(systemParam,txBitsEncodedInterleaved,porcentaje_errores,rafaga,numero_rafagas);
    %DEINTERLEAVER
    rxBitsEncodedDeinterleaved = deinterleaver(systemParam,txBitsEncodedInterleaved);
    % DECODIFIACIÓN
    rxBitsDecoded= decoder(systemParam,rxBitsEncodedDeinterleaved);
end

%% BER computation
disp('BER ...');
systemParam.results.berSimulated = sum(xor(txBits,rxBitsDecoded)) / length(txBits);
BER = systemParam.results.berSimulated;
disp(BER);