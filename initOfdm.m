function systemParam = initOfdm(systemParamIn)

%% Keep existing system parameters 
% Guardamos la entrada de la funcion en la variable local asi no se 
% pierden los valores existentes de la variable
systemParam = systemParamIn;

%% Define new system parameters 1 : Definimos las variables que no dependen del tipo de ofdm

% systemParam.ofdm.ofdmGuardTime = 1; % Tiempo de guarda [s]
% systemParam.ofdm.subcarrierSpacing = 1; %(Ira en funcion del canal) Espacio entre subportadoras -> Lo usaremos para saber el tiempo util de simbolo -> tuti = 1/Af :Af es el espaciado entre subportadoras
% systemParam.ofdm.nConsecutiveDataSc = 7; % numero de portadoras de datos consecutivas
% systemParam.ofdm.nPilotSc = 2; % numero de pilotos

 systemParam.ofdm.subcarrierSpacing = 1; %Espaciado entre portadoras
 systemParam.ofdm.ofdmGuardTime = 1; 
 systemParam.ofdm.nConsecutiveDataSc = 7; %n portadoras de datos consecutivas. 
 systemParam.ofdm.nPilotSc = 2; %n pilotos  


if strcmp(systemParam.ofdm.type,'generic')==1 && (systemParam.mapping.enabled == true)
    systemParam.ofdm.enabled=true;
    %% Initialize system    
    systemParam.ofdm.nDataSc = (systemParam.ofdm.nConsecutiveDataSc*(systemParam.ofdm.nPilotSc-1))-1;% 6; % number of data subcarriers
    systemParam.ofdm.nDc = 1; % number of DC subcarriers
    systemParam.ofdm.nSc = systemParam.ofdm.nDataSc + systemParam.ofdm.nDc + systemParam.ofdm.nPilotSc;% total number of subcarriers
    % Hay que crear una condicion para que cumpla Nyquist (el doble de nSc) y potencia de 2
    systemParam.ofdm.nFft = 32; % 2*systemParam.ofdm.nSc; % Multiplo de dos por el algoritmo % Si hago oversampling Nfft= 2 Nsc -> IFFT/FFT size>=nSc 
    systemParam.ofdm.indexPilotSc_f=2;
    systemParam.ofdm.symbolTime = 1/systemParam.ofdm.subcarrierSpacing; % Tiempo de simbolo [s] -> Tiempo �til de s�mbolo
    systemParam.ofdm.samplingFrequency = systemParam.ofdm.nFft/systemParam.ofdm.symbolTime; %Frecuencia de muestreo // Nfft va a ser el n muestras de toda nuestra ventana de la se�a, entonces lo dividimos por tiempo de simbolo y tenemos la fm.
    systemParam.ofdm.oversamplingFactor = systemParam.ofdm.nFft/systemParam.ofdm.nSc; % Factor de sobremuestreo para evitar grandes filtrados enconversiones A/D. Teoria-> Factor sampling = Nfft/Nsc
    systemParam.ofdm.ofdmGuardTime = (1/4)*systemParam.ofdm.symbolTime; % (Debe ser superior al Delay Spread del canal-> f(DelaySpread) Recalcular Tiempo de guarda [s]
    %systemParam.ofdm.nCp = 4;%systemParam.ofdm.ofdmGuardTime*systemParam.ofdm.samplingFrequency;%9;% número de muestras del prefijo cíclico
    systemParam.ofdm.nCp = ceil(systemParam.ofdm.ofdmGuardTime*systemParam.ofdm.samplingFrequency);
    systemParam.ofdm.modulatorOutnOfdmSymbols = (systemParam.nDataBits)/systemParam.ofdm.nDataSc; % datos de entrada entre subcarriers de datos
    %systemParam.ofdm.modulatorOutnOfdmSymbols = (systemParam.nDataBits/systemParam.mapping.k)/systemParam.ofdm.nDataSc; Para cuando haya codificacion
    systemParam.ofdm.modulatorOutLength = systemParam.ofdm.nSc * systemParam.ofdm.modulatorOutnOfdmSymbols; % number of output samples
    systemParam.ofdm.oneTail = systemParam.ofdm.nDataSc-mod(systemParam.mapping.mapperOutLength,systemParam.ofdm.nDataSc); % numero de muestras para llenar la matriz de simbolos OFDM
    
    %% Inicializamos vector para indexPilots
        % Creamos el vector
    systemParam.ofdm.indexPilotSc = 1:1:systemParam.ofdm.nPilotSc;
        % Ponemosel valor del �ndice
    for i=1:(systemParam.ofdm.nPilotSc-1)
        if i==1
            systemParam.ofdm.indexPilotSc(i)=1;
        else
            systemParam.ofdm.indexPilotSc(i)=systemParam.ofdm.indexPilotSc(i-1)+systemParam.ofdm.nConsecutiveDataSc+1;
        end
    end
    systemParam.ofdm.indexPilotSc(systemParam.ofdm.nPilotSc)=systemParam.ofdm.nSc; % vector indicating the indices of the pilot subarriers
    
    
    %% Inicializamos vector para Data
    
    dataVector = zeros(1,systemParam.ofdm.nSc);
    dataVector((systemParam.ofdm.nSc+1)/2)=2;
    
    for j=1:systemParam.ofdm.nPilotSc
        dataVector(systemParam.ofdm.indexPilotSc(j))=1;
    end    
    
    
    systemParam.ofdm.indexDataSc = zeros(1,systemParam.ofdm.nDataSc);
    t=1;
    for k=1:systemParam.ofdm.nSc
        if dataVector(k)==1 || dataVector(k)==2
            k=k+1;
        else
            systemParam.ofdm.indexDataSc(t)=k; % vector indicating the indices of the data subarriers
            t=t+1;
            k=k+1;
        end
    end
    
    %% Ponemos la se�al en modo matlab: Desplazamos Nfft muestras la se�al que este por debajo de la continua
    
    % Centramos la continua en 0 en los vectores de indices de data y pilotos
    %systemParam.ofdm.indexDataSc =systemParam.ofdm.indexDataSc-(systemParam.ofdm.nSc+1)/2;
    %systemParam.ofdm.nPilotSc=systemParam.ofdm.nPilotSc-(systemParam.ofdm.nSc+1)/2;
    
elseif strcmp(systemParam.ofdm.type,'none')==1 
    systemParam.ofdm.enabled=false;
    
else
    booleano=false;
end

%% Show new parameters
if systemParam.ofdm.enabled
    disp('--ofdm configuration ----------------------------------------------')
    disp(['ofdm Type : ' num2str(systemParam.ofdm.type)]);
    disp(['Cyclic prefix : ' num2str((systemParam.ofdm.nCp/systemParam.ofdm.modulatorOutnOfdmSymbols)*1000) '(' num2str(systemParam.ofdm.nCp) 'samples)' ]);
    disp(['OFDM symbol : ' num2str((systemParam.ofdm.modulatorOutnOfdmSymbols/systemParam.ofdm.samplingFrequency)*1000) '(' num2str(systemParam.ofdm.modulatorOutnOfdmSymbols) 'samples)']);
    disp(['Num. subcarriers : ' num2str(systemParam.ofdm.type)]);

elseif booleano==false
            error('The introduced type is not correct, please, insert it again');
else
    systemParam.ofdm.enabled=false;
    
end