function systemParam = initAwgn(systemParamIn)
%Acabar de perfilarlo 

% Keep existing system parameters 
% Guardamos la entrada de la funcion en la variable local asi no se 
% pierden los valores existentes de la variable
systemParam = systemParamIn;
%% Define new system parameters
%Defino esta variable para tener un booleano de inicializacion y 
%desactivarlo cuando la entrada de parametros no sea correcta.

if strcmp(systemParam.awgn.EbNoVec,'none')==false
    systemParam.awgn.enabled = true;

        % En en linkSimulator esta inicializada esta variable:
        % systemParam.awgn.EbNo % Eb/No in dB or no noise {-10,...,15,'none'}
        %
        % En el initAwgn lo unico que realizamos (hasta el momento) es verificar
        % que se cumplen los requisitos del linkSimulator

        % ESTO LO REALIZARÉ SÓLO PARA LOS CASOS PERMITIDOS EN EL linkSimulator

        if (systemParam.awgn.EbNo>=-10) && (systemParam.awgn.EbNo<=15)
                disp('El parametro EbNo cumple los requisitos');
        elseif systemParam.awgn.EbNo == 'none'
              systemParam.awgn.enabled=false; % deshabilitar si Ebno es igual a 'none'
        elseif systemParam.mapping.enabled == 'false'
              systemParam.awgn.enabled=false; % deshabilitar si mapping no está habilitado
        else
              systemParam.awgn.enabled=false;
        end     
    
else 
    systemParam.awgn.enabled = false;
   % systemParam.awgn.EbNoVec=ones(1,10);
    
end
%% Initialize system
 

%% Show new parameters
if systemParam.awgn.enabled
    disp('-- Awgn configuration ----------------------------------------------')
    disp(['Awgn Type : ' num2str(systemParam.awgn.EbNo)]);
elseif systemParam.awgn.enabled==false
    systemPara.awgn.enabled=false;
else
        error('The introduced type is not correct, please, insert it again');
    
end

end