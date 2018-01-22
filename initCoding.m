function systemParam = initCoding(systemParamIn)

%% Keep existing system parameters 
% Guardamos la entrada de la funcion en la variable local asi no se 
% pierden los valores existentes de la variable
systemParam = systemParamIn;
%% Define new system parameters
systemParam.coding.enabled = true;
%% Initialize system
% Coding type {'fast','slowWeak','slowStrong','none'}
if strcmp(systemParam.coding.type,'slowWeak')
    
        systemParam.coding.constraintLength = 5;
        systemParam.coding.generator = [33 37];
        systemParam.coding.feedback = 37;
        systemParam.coding.k = 1;
        systemParam.coding.n = 2;
        
elseif strcmp(systemParam.coding.type,'slowStrong')
    
        systemParam.coding.constraintLength = 7 ;
        systemParam.coding.generator = [171 133];%[37 33];
        systemParam.coding.feedback = []; %37;
        systemParam.coding.k = 1;
        systemParam.coding.n = 2;
              
elseif strcmp(systemParam.coding.type,'fast')
    
        systemParam.coding.constraintLength = [5 4];%4];
        systemParam.coding.generator = [23 35 0;0 5 13];%[19 29 5 ; 29 5 11];%[37 33];
        systemParam.coding.feedback = []; %37;
        systemParam.coding.k = 2;
        systemParam.coding.n = 3;
            
elseif strcmp(systemParam.coding.type,'none')
        
        systemParam.coding.enabled = false;
        systemParam.coding.constraintLength = 0;
        systemParam.coding.generator = [];%[37 33];
        systemParam.coding.feedback = []; %37;
else 
        disp("ERROR");
end            

%Comprobamos si el sistema tiene feedback
if(~strcmp(systemParam.coding.type,'none'))
    if(isempty(systemParam.coding.feedback))
        systemParam.coding.trellis = poly2trellis(systemParam.coding.constraintLength,systemParam.coding.generator);
    else 
        systemParam.coding.trellis = poly2trellis(systemParam.coding.constraintLength,systemParam.coding.generator,systemParam.coding.feedback);
    end
          
        systemParam.coding.spect = distspec(systemParam.coding.trellis); % Duda !! Hemos usado el caso basico -> ok
        systemParam.coding.iscatastrophic = iscatastrophic(systemParam.coding.trellis);
        %systemParam.coding.zeroTail = systemParam.coding.constraintLength-1; % Duda !!
        %systemParam.coding.traceBackLength = 6*length(systemParam.coding.zeroTail);
        systemParam.coding.traceBackLength = 5*min(systemParam.coding.constraintLength);
        systemParam.coding.zeroTail = systemParam.coding.k*systemParam.coding.traceBackLength;
        systemParam.coding.rate = systemParam.coding.k/systemParam.coding.n; 
        systemParam.coding.rateEffective = systemParam.nDataBits/(systemParam.coding.n*(((systemParam.nDataBits+systemParam.coding.zeroTail)/systemParam.coding.k)+(min(systemParam.coding.constraintLength)-1))); % formula effective rate diapositiva 4
        
        systemParam.coding.encoderOutLength = (systemParam.nDataBits + systemParam.coding.zeroTail)/systemParam.coding.rate; %pendiente; 

else 
    systemParam.coding.encoderOutLength = systemParam.nDataBits;
%% Show new parameters
if systemParam.coding.enabled
    disp('-- Coding configuration ----------------------------------------------')
    disp(['Coding Type : ' num2str(systemParam.coding.type)]);
else
        error('The introduced type is not correct, please, insert it again');
    
end

end

