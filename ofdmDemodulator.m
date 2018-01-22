function [rxSymbols,HEstimated] = ofdmDemodulator(systemParam,rxOfdmSymbols,indexPilotSc_f)

%% PASOS TEORICOS:

% 1 - Cogemos el vector de datos que contenga los Cps y los simbolos OFDM y
% tenemos que hacer un reshape para poder coger la matriz y quitarle los
% prefijos ciclicos.

% 2 - Una vez quitados los prefijos cíclicos tenemos que hacer la fft de la
% matriz para tenerla en frecuencia.


% Creamos el vector de datos que va a rellenar toda la matriz OFDM
    %Sdatos = [txSymbols];
% Igualamos la respuesta impulsional a 0 porque va ligada con el canal

% 1 -
HEstimated=0;
%%    
%Convertimos txOfdmSybols en una matriz para poder extraer facilmente el prefijo ciclico
S = reshape(rxOfdmSymbols,[systemParam.ofdm.nCp + systemParam.ofdm.nFft, ceil(systemParam.ofdm.modulatorOutnOfdmSymbols)]);

%Extraemos prefijo cíclico 
Ssincp=S(systemParam.ofdm.nCp+1:end,:);

%Aplicamos la FFT para volver al dominio frecuencial 
Sfft = fft(Ssincp,systemParam.ofdm.nFft);

%Aqui ecualizamos, ya que es la matriz completa con los pilotos tambien que
%es lo que nos interesa
[HEstimated, rxSymbols] = equalizer(systemParam,Sfft,indexPilotSc_f);
%Actualizamos los valores de la matriz SFFT ya ecualizados
Sfft=reshape(rxSymbols,systemParam.ofdm.nFft,ceil(systemParam.ofdm.modulatorOutnOfdmSymbols));
%Creamos la matriz que guardará solamente los simbolos útiles
Sofdm_nFft = zeros(systemParam.ofdm.nDataSc,ceil(systemParam.ofdm.modulatorOutnOfdmSymbols));

%Pasamos los valores de la derecha a la izquierda 
j=systemParam.ofdm.nFft;
    for i=((systemParam.ofdm.nDataSc/2)):-1:1 % La continua la dejaremos al principio de la matriz
       Sofdm_nFft(i,:)=Sfft(j,:);
        j=j-1;
    end

 j=1;
    for i=(((systemParam.ofdm.nDataSc)/2)):systemParam.ofdm.nDataSc-1 % La continua la dejaremos al principio de la matriz
        Sofdm_nFft(i+1,:)=Sfft(j+1,:);
        j=j+1;
    end
    
    %% Debemos sacar el Tail del vector


    
vector_datos = Sofdm_nFft(:);

rxSymbols = ones(1,length(vector_datos)-systemParam.ofdm.oneTail); 
for i=1:length(rxSymbols)
    rxSymbols(i)=vector_datos(i);
end  
rxSymbols=rxSymbols';
end


%% FEINES PENDENTS: 1) DEMAPER Y OFDMDEMOD per comprobar el funcionament 2) INTRODUIR SOROLL AMB EL CANAL AWGN AMB CONFIGURACIO BASICA OFDM 3) AFEGIR MULTIPATH + CONVOLUCIO 4) EQ
