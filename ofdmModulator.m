function [txOfdmSymbols,indexPilotSc_f] = ofdmModulator(systemParam,txSymbols)

    % Creamos el vector de datos que va a rellenar toda la matriz OFDM
    %Sdatos = [txSymbols];
    % Creamos el vector tail con el numero de tails correspondiente para
    % rellenar toda la matriz al completo.
    % Nota: En caso de que oneTail = 0; el codigo no peta. Sigue
    % concadenando.
    tail = ones(1,systemParam.ofdm.oneTail);
    
    % Creamos el vector completo de datos con el tail, concadenando ambos
    % vectores
    %Sonetail = horzcat(txSymbols',tail);
    Sonetail = horzcat(txSymbols,tail);
    Sonetail = Sonetail';

    %% Introducimos la información en la matriz
    
    % Tenemos que hacer un resize del senyal codificado e introducirlo en
    % la matriz Sofdm que hemos creado (reshape, coger las x primeras
    % muestras y poner todo el vector de datos por columnas)
    % Creamos la matriz solo con el vector de datos
    Sreshape = reshape(Sonetail,[systemParam.ofdm.nDataSc, ceil(systemParam.ofdm.modulatorOutnOfdmSymbols)]);
    % Sreshape = reshape(Sonetail,[systemParam.ofdm.nFft+systemParam.ofdm.nCp, ceil(systemParam.ofdm.modulatorOutnOfdmSymbols)]);

    % Cremos la matriz OFDM preparandola  para introducir los distintos
    % elementos (pilotos y continua)
    %% SEGUNDO INTRODUCIMOS LOS PILOTOS
    Sofdm(systemParam.ofdm.indexDataSc,:) = Sreshape;
    % Aqu� tenemos que llenar los pilotos en la matriz a partir de una
    % matriz externa llamada insertPilots
    %Asi es como lo teniamos: 
    Sofdm(systemParam.ofdm.indexPilotSc, :) = 1; 
    %Sofdm=insertPilots(systemParam);
    
    %% TERCERO ORGANIZAMOS LA MATRIZ EN MODO MATLAB
    % Inicializamos matriz de dimension nFFT a 0   
    Sofdm_nFft = zeros(systemParam.ofdm.nFft,ceil(systemParam.ofdm.modulatorOutnOfdmSymbols));
    indice_pilotos_grande= zeros(systemParam.ofdm.nFft,ceil(systemParam.ofdm.modulatorOutnOfdmSymbols));
    % Recolocamos la informacion de la matriz en orden estilo Matlab
    
    % Parte inicial de la matriz
    j=1;
    for i=((systemParam.ofdm.nSc+1)/2):systemParam.ofdm.nSc % La continua la dejaremos al principio de la matriz
        Sofdm_nFft(j,:)=Sofdm(i,:);
       
        if Sofdm(i,:)==1
            indice_pilotos_grande(j,:)=1;
        end
         j=j+1;
    end
    
    % Parte final de la matriz
    
    j=systemParam.ofdm.nFft;
    for i=(((systemParam.ofdm.nSc+1)/2)-1):-1:1 % La continua la dejaremos al principio de la matriz
        Sofdm_nFft(j,:)=Sofdm(i,:);
        if Sofdm(i,:)==1
            indice_pilotos_grande(j,:)=1;
        end        
        j=j-1;
    end
    %Variable auxiliar para guardar los indices de los pilotos
    indice_pilotos_grande=indice_pilotos_grande(:);
    j=1;
    for i=1:length(indice_pilotos_grande)
        if indice_pilotos_grande(i)==1
            systemParam.ofdm.indexPilotSc_f(j)=i;
            j=j+1;
        end
    end
            
    indexPilotSc_f=systemParam.ofdm.indexPilotSc_f;
    % IFFT    
    
    Sifft = ifft(Sofdm_nFft,systemParam.ofdm.nFft);
    
    
    %% Prefijo ciclico
   
    % Opcion "a saco" 
    % 1) Creo y inicializo la matriz de prefijo ciclico asignando 
    % la ultima parte de la matriz del numero de filas = nFft-nCp y columnas =
    % modulatorOutSymbols
     
    % Sintaxi -> filas max matriz - prejijoC + 1(para compensar):hasta el
    % final, [Columnas] todas +1(para compensar)
    Scp = Sifft((systemParam.ofdm.nFft-systemParam.ofdm.nCp+1):systemParam.ofdm.nFft,1:systemParam.ofdm.modulatorOutnOfdmSymbols+1);
    
    % 2) Uso la siguiente herramienta para concatenar las matrices:  
    %   mat(2:3,[1 3])   % Submatriz formada por los elementos que están en "todas" las filas que
    %   hay entre la segunda y la tercera y en las columnas primera y tercera
    
    % Concatenar matriz
    S = [Scp;Sifft];     %[X;Y] -> X encima de Y
    txOfdmSymbols = S(:); 
end

