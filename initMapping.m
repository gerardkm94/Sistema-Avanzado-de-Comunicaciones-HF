function systemParam = initMapping(systemParamIn)

%% Keep existing system parameters 
% Guardamos la entrada de la funcion en la variable local asi no se 
% pierden los valores existentes de la variable
systemParam = systemParamIn;
%% Define new system parameters
%Defino esta variable para tener un booleano de inicializacion y 
%desactivarlo cuando la entrada de parametros no sea correcta.
systemParam.mapping.enabled = true;
%% Initialize system
% Mapping type {'bpsk','qpsk','qam16','qam64','none'}


if strcmp(systemParam.mapping.type,'bpsk')
   
    systemParam.mapping.enabled=true; 
    systemParam.mapping.k = 1; 
    systemParam.mapping.mapper = modem.pskmod(2);
    systemParam.mapping.demapper = modem.pskdemod(2);

    %constellation(dibujo_const);
    if mod(systemParam.nDataBits, systemParam.mapping.k) ~=0 
        systemParam.mapping.zeroTail = zeros(1,systemParam.mapping.k - mod(systemParam.nDataBits, systemParam.mapping.k));
    else
        systemParam.mapping.zeroTail = [];
    end
    
    systemParam.mapping.constellation = systemParam.mapping.mapper.Constellation; 
    systemParam.mapping.averagePower = sum(abs(systemParam.mapping.mapper.Constellation)) / length(systemParam.mapping.constellation);
    systemParam.mapping.mapperOutLength = systemParam.nDataBits; 

elseif strcmp(systemParam.mapping.type,'qpsk')
    
    systemParam.mapping.enabled=true;    
    systemParam.mapping.k = 2;
    systemParam.mapping.mapper = modem.qammod(systemParam.mapping.k^2); %??
    systemParam.mapping.demapper = modem.qamdemod(systemParam.mapping.k^2);
    %dibujo_const = comm.QPSKModulator;
    %systemParam.mapping.constellation = constellation(dibujo_const);
    %constellation(dibujo_const);

    if mod(systemParam.nDataBits, systemParam.mapping.k) ~=0 
        systemParam.mapping.zeroTail = zeros(1,systemParam.mapping.k - mod(systemParam.nDataBits, systemParam.mapping.k));
    else
        systemParam.mapping.zeroTail = [];
    end
    
    systemParam.mapping.constellation = systemParam.mapping.mapper.Constellation; 
    systemParam.mapping.averagePower = sum(abs(systemParam.mapping.mapper.Constellation)) / length(systemParam.mapping.constellation);
    systemParam.mapping.mapperOutLength = systemParam.nDataBits; 
    
elseif strcmp(systemParam.mapping.type,'qam16')
    
    systemParam.mapping.enabled=true; 
    systemParam.mapping.k = 4; %16 symbols
    systemParam.mapping.mapper = modem.qammod(systemParam.mapping.k^2); %??
    systemParam.mapping.demapper = modem.qamdemod(systemParam.mapping.k^2);
    %dibujo_const = comm.RectangularQAMModulator('ModulationOrder',16);
    %systemParam.mapping.constellation = constellation(dibujo_const);
    %constellation(dibujo_const);

    if mod(systemParam.nDataBits, systemParam.mapping.k) ~=0 
        systemParam.mapping.zeroTail = zeros(1,systemParam.mapping.k - mod(systemParam.nDataBits, systemParam.mapping.k));
    else
        systemParam.mapping.zeroTail = [];
    end
    
    systemParam.mapping.constellation = systemParam.mapping.mapper.Constellation; 
    systemParam.mapping.averagePower = sum(abs(systemParam.mapping.mapper.Constellation)) / length(systemParam.mapping.constellation);
    systemParam.mapping.mapperOutLength = systemParam.nDataBits; 
elseif strcmp(systemParam.mapping.type,'qam64')
        
    systemParam.mapping.enabled=true;
    systemParam.mapping.k = 8; %64 symbols
    systemParam.mapping.mapper = modem.qammod(systemParam.mapping.k^2); %??
    systemParam.mapping.demapper = modem.qamdemod(systemParam.mapping.k^2);
    %dibujo_const = comm.RectangularQAMModulator('ModulationOrder',64);
    %systemParam.mapping.constellation = constellation(dibujo_const);
    %constellation(dibujo_const);
    if mod(systemParam.nDataBits, systemParam.mapping.k) ~=0 
        systemParam.mapping.zeroTail = zeros(1,systemParam.mapping.k - mod(systemParam.nDataBits, systemParam.mapping.k));
    else
        systemParam.mapping.zeroTail = [];
    end
    
    systemParam.mapping.constellation = systemParam.mapping.mapper.Constellation; 
    systemParam.mapping.averagePower = sum(abs(systemParam.mapping.mapper.Constellation)) / length(systemParam.mapping.constellation);
    systemParam.mapping.mapperOutLength = systemParam.nDataBits; 
    
    
elseif strcmp(systemParam.mapping.type,'none')

    systemParam.mapping.k = 0; 
    systemParam.mapping.enabled=false;
    
else
      %systemParam.mapping.enabled=false;
end

%if systemParam.mapping.type == 'qpsk' % && systemParam.mapping.type ~= 'none'- inicializar todos los parametros inclusive para 'none'
    
   % systemParam.mapping.mapper = modem.qammod(systemParam.mapping.k^2); %??
   % systemParam.mapping.demapper = modem.qamdemod(systemParam.mapping.k^2);
%end

        %systemParam.mapping.constellation = systemParam.mapping.mapper.Constellation; 
%systemParam.mapping.averagePower = sum(abs(systemParam.mapping.mapper.Constellation))/systemParam.mapping.mapper.M;
        %systemParam.mapping.averagePower = sum(abs(systemParam.mapping.mapper.Constellation)) / length(systemParam.mapping.constellation);
%systemParam.mapping.zeroTail = '';

%Con QPSK a nuestra manera 
%systemParam.mapping.mapperOutLength = systemParam.nDataBits/systemParam.mapping.k; 

%De manera generica
        %systemParam.mapping.mapperOutLength = systemParam.nDataBits; 


%% Show new parameters
if systemParam.mapping.enabled
    disp('-- Mapping configuration ----------------------------------------------')
    disp(['Mapping Type : ' num2str(systemParam.mapping.type)]);
    disp(['Average power : ' num2str(systemParam.mapping.averagePower)]);
    disp(['Tailing bits : ' num2str(systemParam.mapping.zeroTail)]);
    disp(['Mapper length : ' num2str(systemParam.mapping.mapperOutLength)]);
elseif strcmp(systemParam.mapping.type,'none')
    
        systemParam.mapping.enabled=false;

else 
        error('The introduced type is not correct, please, insert it again');
    
end
