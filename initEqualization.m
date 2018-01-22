function systemParam = initEqualization(systemParamIn)

%% Keep existing system parameters 
% Guardamos la entrada de la funcion en la variable local asi no se 
% pierden los valores existentes de la variable
systemParam = systemParamIn;
%% Define new system parameters
%Defino esta variable para tener un booleano de inicializacion y 
%desactivarlo cuando la enintrada de parametros no sea correcta.

% if systemParam.equalization.type ~= 'none'
%     systemParam.equalization.enabled = true;
% end

%% Initialize system
% EQ type {'zf','none'}

if strcmp(systemParam.equalization.type,'zf')
    systemParam.equalization.enabled = true;
elseif strcmp(systemParam.equalization.type,'none')
    systemParam.equalization.enabled = false;

else
      systemParam.equalization.enabled=false;
end            
%% Show new parameters
if systemParam.equalization.enabled
    disp('-- Equalization configuration ----------------------------------------------')
    disp(['EQ Type : ' num2str(systemParam.equalization.type)]);
elseif systemParam.equalization.enabled==false
          systemParam.equalization.enabled=false;
else
        error('The introduced EQ type is not correct, please, insert it again');
    
end
