function rxBitsError = manualError(systemParamIn,txBitsEncodedInterleaved,Numero_errores,rafaga)
%% Keep existing system parameters 
% Guardamos la entrada de la funcion en la variable local asi no se 
% pierden los valores existentes de la variable
systemParam = systemParamIn;

disp(['Error Type : ' num2str(systemParam.error.type)]);

%% Define new system parameters
if strcmp(systemParam.error.type,'aleatorio')  
    % 1. Diferentes números de bits erróneos distribuidos aleatoriamente
    systemParam.error.numError = Numero_errores;% Numero de errores introducidos
    disp(['Num of errors : ' num2str(systemParam.error.numError)]);
elseif strcmp(systemParam.error.type,'rafaga')
    % 2. Ráfaga de bits erróneos seguidos de diferentes longitudes
    systemParam.error.numError = Numero_errores;
    systemParam.error.numRafaga= 10; % Numero de rafagas
    disp(['Num of rafagas : ' num2str(systemParam.error.numRafaga)]);
else
    disp('..None error mode..');
end
%% Initialize system

if strcmp(systemParam.interleaving.type,'none')
    if strcmp(systemParam.error.type,'aleatorio')
    %  SIN INTERLEAVER
        randomPos = randperm(length(txBitsEncodedInterleaved),systemParam.error.numError); %genera un numero aleatorio SIN REPETICION (será la posicion a alterrar el valor)   
        disp(['Posiciones del error : ' num2str(randomPos)]);
        for i=1:1:systemParam.error.numError
            value = txBitsEncodedInterleaved(randomPos(i));
            if value == 0
                txBitsEncodedInterleaved(randomPos(i))=1; % Si es un 0 le ponemos 1
            elseif value == 1
                txBitsEncodedInterleaved(randomPos(i))=0; % Si es un 1 le ponemos 0
            else 
                txBitsEncodedInterleaved(randomPos(i))=txBitsEncodedInterleaved(randomPos(i)); % Lo dejamos igual
            end
        end
        rxBitsError = txBitsEncodedInterleaved;
    elseif strcmp(systemParam.error.type,'rafaga')
    %  SIN INTERLEAVER
            aux = 0;
            systemParam.error.bitsErroneos = 0;
        for j=1:1:systemParam.error.numRafaga % Introducimos las rafagas
            %------LONGITUD RAFAGA ------%
            systemParam.error.lengthRafaga = randi([0,maximumLenghtRafaga],1); % Las rafagas tendran longitudes aleatorias entre 0 y maximumLenghtRafaga bits.
            %----------------------------%
            bitsErroneos = systemParam.error.lengthRafaga;
            % Siempre habrán 10 rafagas, la logitud de las cuales sera
            % entre 0 y 100.000 bits. ¿Porque? la longitud de los bits
            % interleaved siempre sera de 2.000.012 bits, esta cadena de
            % datos la dividiré entre 10 (cada trozo de 200.000bits),
            % entonces cada rafaga ira dentro de cada trozo de info, que
            % para protejer frente a solape entre rafagas ponemos como
            % maximo una longitud de rafaga de 100.000bits, donde sus
            % posiciones iniciales seran aleatorias entre la mitad y el
            % final de cada trozo.
            
            %------------- calculo posicion inicial rafaga --------------%
            % ALEATORIA
            %randomPosR = round(100000*rand+100000*j+100000*aux); % Posicion aleatoria que iniciara la rafaga
            % Forzada
            randomPosR = 1+(200000*aux); %inicio de cada paquete            
       
            aux = aux +1;
            disp(['Rafaga num ',num2str(j)]);
            disp(['     - Posicion: ',num2str(randomPosR)]);
            disp(['     - Lenght: ',num2str(systemParam.error.lengthRafaga)]);
            
            for k=1:1:systemParam.error.lengthRafaga % Introducimos las secuencias de bits erroneos

                value = txBitsEncodedInterleaved(randomPosR);
                if value == 0
                    txBitsEncodedInterleaved(randomPosR)=1; % Si es un 0 le ponemos 1
                elseif value == 1
                    txBitsEncodedInterleaved(randomPosR)=0; % Si es un 1 le ponemos 0
                else 
                    txBitsEncodedInterleaved(randomPosR)=txBitsEncodedInterleaved(randomPosR); % Lo dejamos igual
                end
                randomPosR = randomPosR+1; % Incremento a la siguiente posicion
            end
            systemParam.error.bitsErroneos = systemParam.error.bitsErroneos + bitsErroneos;
        end
        rxBitsError = txBitsEncodedInterleaved;
        disp(['Bits erroneos ',num2str(systemParam.error.bitsErroneos)]);
    else 
    end

elseif strcmp(systemParam.interleaving.type,'deep')||strcmp(systemParam.interleaving.type,'shallow')
    if strcmp(systemParam.error.type,'aleatorio')       
    %  CON INTERLEAVER
        randomPos = randperm(length(txBitsEncodedInterleaved),systemParam.error.numError);%genera un numero aleatorio (será la posicion a alterrar el valor)              
        for i=1:1:systemParam.error.numError
            value = txBitsEncodedInterleaved(randomPos(i));
            if value == 0
                txBitsEncodedInterleaved(randomPos(i))=1; % Si es un 0 le ponemos 1
            elseif value == 1
                txBitsEncodedInterleaved(randomPos(i))=0; % Si es un 1 le ponemos 0
            else 
                txBitsEncodedInterleaved(randomPos(i))=txBitsEncodedInterleaved(randomPos(i)); % Lo dejamos igual
            end
        end
        rxBitsError = txBitsEncodedInterleaved;
    elseif strcmp(systemParam.error.type,'rafaga')
    %  CON INTERLEAVER
            aux = 0;
            systemParam.error.bitsErroneos = 0;
            
        for j=1:1:systemParam.error.numRafaga % Introducimos las rafagas
            systemParam.error.lengthRafaga = randi([0,maximumLenghtRafaga],1); % Las rafagas tendran longitudes aleatorias entre 0 y maximumLenghtRafaga bits.
            bitsErroneos = systemParam.error.lengthRafaga;
            % Siempre habrán 10 rafagas, la logitud de las cuales sera
            % entre 0 y 100.000 bits. ¿Porque? la longitud de los bits
            % interleaved siempre sera de 2.000.012 bits, esta cadena de
            % datos la dividiré entre 10 (cada trozo de 200.000bits),
            % entonces cada rafaga ira dentro de cada trozo de info, que
            % para protejer frente a solape entre rafagas ponemos como
            % maximo una longitud de rafaga de 100.000bits, donde sus
            % posiciones iniciales seran aleatorias entre la mitad y el
            % final de cada trozo.
            
            %------------- calculo posicion inicial rafaga --------------%
            % ALEATORIA
            %randomPosR = round(100000*rand+100000*j+100000*aux); % Posicion aleatoria que iniciara la rafaga
            % Forzada
            randomPosR = 1+(200000*aux); %inicio de cada paquete
            
            aux = aux +1;
            disp(['Rafaga num ',num2str(j)]);
            disp(['     - Posicion: ',num2str(randomPosR)]);
            disp(['     - Lenght: ',num2str(systemParam.error.lengthRafaga)]);
            
            for k=1:1:systemParam.error.lengthRafaga-1 % Introducimos las secuencias de bits erroneos

                value = txBitsEncodedInterleaved(randomPosR);
                if value == 0
                    txBitsEncodedInterleaved(randomPosR)=1; % Si es un 0 le ponemos 1
                elseif value == 1
                    txBitsEncodedInterleaved(randomPosR)=0; % Si es un 1 le ponemos 0
                else 
                    txBitsEncodedInterleaved(randomPosR)=txBitsEncodedInterleaved(randomPosR); % Lo dejamos igual
                end
                randomPosR = randomPosR+1; % Incremento a la siguiente posicion
            end
            systemParam.error.bitsErroneos = systemParam.error.bitsErroneos + bitsErroneos;
        end
        rxBitsError = txBitsEncodedInterleaved;
        disp(['Bits erroneos ',num2str(systemParam.error.bitsErroneos)]);
    else
        rxBitsError = txBitsEncodedInterleaved;
    end
    
end
   
%% Show new parameters
if systemParam.coding.enabled
    disp('-- Error configuration ----------------------------------------------')
    disp(['Error Type : ' num2str(systemParam.coding.type)]);
else
        error('The introduced type is not correct, please, insert it again');
    
end

end