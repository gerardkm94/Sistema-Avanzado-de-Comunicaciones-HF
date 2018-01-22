function systemParam = initMultipath(systemParamIn)

%% Keep existing system parameters 
% Guardamos la entrada de la funcion en la variable local asi no se 
% pierden los valores existentes de la variable
systemParam = systemParamIn;
%% Define new system parameters

systemParam.multipath.tapAmplitude = [0.8, 0.2]; 
systemParam.multipath.tapDelay = [0, 4];
systemParam.multipath.Tm = 1; % [ms]
%Delta
% systemParam.multipath.tapAmplitude = [1]; 
% systemParam.multipath.tapDelay = [0];
% systemParam.multipath.Tm = 1; % [ms]

% Creo el .tapPhase aqui porque así lo marca el pdf referente al initMultipath 
systemParam.multipath.tapPhase = zeros(1,0);

%% Initialize system
% Multipath type {'static-1','static-2','none'}

if strcmp(systemParam.multipath.type, 'none')~=1 && systemParam.ofdm.enabled == true
    systemParam.multipath.enabled = true;
else
    systemParam.multipath.enabled = false;

end

if strcmp(systemParam.multipath.type,'static-1')
    systemParam.multipath.nTaps = 2;
    % Revisar normalizacion de la amplitud
    systemParam.multipath.tapNormalizedAmplitude = (1/sqrt(2))* systemParam.multipath.tapAmplitude;
   % systemParam.multipath.tapNormalizedAmplitude =systemParam.multipath.tapAmplitude;

    systemParam.multipath.tapNormalizedDelay = ceil(systemParam.multipath.tapDelay);
    systemParam.multipath.tapPhase = [0, pi/4];
    %systemParam.multipath.tapPhase = [0];
%     %% Prueba BER delta
%     systemParam.multipath.nTaps = 1;
%     systemParam.multipath.tapNormalizedAmplitude = 1;
%     systemParam.multipath.tapNormalizedDelay = 0;
%     systemParam.multipath.tapPhase = 0;
    
    %% Calculo de la respuesta impulsional
    
    
    % La longitud de la respuesta impulsional debe tener en cuenta Tmuestreo (1/fm).
    % Antes teniamos puesta la amplitud sin normalizar
    systemParam.multipath.h = systemParam.multipath.tapNormalizedAmplitude.*exp(1i.*systemParam.multipath.tapPhase); 
    
    % Longitud de muestras del canal
    %helem = ceil(max(systemParam.multipath.tapNormalizedDelay)/(1/systemParam.ofdm.samplingFrequency))+1;
    %systemParam.multipath.h(systemParam.multipath.tapNormalizedDelay*(systemParam.ofdm.samplingFrequency)+1)= systemParam.multipath.tapAmplitude.*exp(1i.*systemParam.multipath.tapPhase);
    systemParam.multipath.H = ifft(systemParam.multipath.h,systemParam.ofdm.nFft); % Nfft

    %ploteamos respuesta temporal
    %t = (-4:1:length(systemParam.multipath.h)-1);
%     t = (-3:1:length(systemParam.multipath.h)-1);
%     figure
%     stem(t/systemParam.ofdm.samplingFrequency,cat(2,zeros(1,3),abs(systemParam.multipath.h)),'o');
%     title('Multipath channel response');
     figure
     plot(abs(systemParam.multipath.H))
elseif strcmp(systemParam.multipath.type,'static-2')
        disp('1');
else
      systemParam.multipath.enabled=false;
end            


%%systemParam.multipath.nTaps = 2;
%%systemParam.multipath.tapNormalizedAmplitude = (1/sqrt(2))* systemParam.multipath.tapAmplitude;
%%systemParam.multipath.tapNormalizedDelay = round(systemParam.multipath.tapDelay);
%%systemParam.multipath.tapPhase = [0,pi/4];

%% Nota de matlab que me he pasado x el forro:
% longitud del vector h-> longitud prefijo ciclico (long h(t)) = ceil (longitud ifft(OFDM)/(Tsymbol/Tguarda));
%% Apuntes 
% La longitud de la respuesta impulsional debe tener en cuenta Tmuestreo (1/fm).




%% Show new parameters
if systemParam.multipath.enabled == true
    disp('-- Multipath configuration ----------------------------------------------')
    disp(['Multipath Type : ' num2str(systemParam.multipath.type)]);
elseif systemParam.multipath.enabled == false
          systemParam.multipath.enabled=false;
else 
        error('The introduced type is not correct, please, insert it again');
end 
end