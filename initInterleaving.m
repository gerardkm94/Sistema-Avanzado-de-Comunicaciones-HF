function systemParam = initInterleaving(systemParamIn)

%% Keep existing system parameters 
% Guardamos la entrada de la funcion en la variable local asi no se 
% pierden los valores existentes de la variable
systemParam = systemParamIn;
%% Define new system parameters
%Defino esta variable para tener un booleano de inicializacion y 
%desactivarlo cuando la entrada de parametros no sea correcta.
systemParam.interleaving.enabled = true;
%% Initialize system
% Interleaving type {'Deep','Shallow','None'}

if strcmp(systemParam.interleaving.type,'deep')
        systemParam.interleaving.nRows = 6;
        systemParam.interleaving.slope = 1; 
        systemParam.interleaving.delay = (systemParam.interleaving.nRows*(systemParam.interleaving.nRows-1)*systemParam.interleaving.slope);
elseif strcmp(systemParam.interleaving.type,'shallow')
        systemParam.interleaving.nRows = 4;
        systemParam.interleaving.slope = 1;
        systemParam.interleaving.delay = (systemParam.interleaving.nRows*(systemParam.interleaving.nRows-1)*systemParam.interleaving.slope);
       %La comento pruebas
       %systemParam.interleaving.delay = (systemParam.interleaving.nRows*(systemParam.interleaving.nRows-systemParam.interleaving.slope));

elseif strcmp(systemParam.interleaving.type,'none')
        systemParam.interleaving.nRows = 0;
        systemParam.interleaving.slope = 0;
        systemParam.interleaving.delay = 0;
        systemParam.interleaving.interleaverOutLength = 0;
        systemParam.interleaving.enabled=false;
else
      print("Elige un caso util");
end            
%% Show new parameters
if systemParam.interleaving.enabled
    disp('-- Interleaving configuration ----------------------------------------------')
    disp(['Interleaving Type : ' num2str(systemParam.interleaving.type)]);
else
        disp('Interleaved not activated');
    
end