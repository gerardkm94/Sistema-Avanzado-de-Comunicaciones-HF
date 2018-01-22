clear all;
clc;
close all;

% %randomPos = randi([1,2000000],1,2000000);
% randomPos = randperm(2000000,2000000);
% 
% % REPITE O NO
% 
% n=length(randomPos);
% 
% k=1;
% 
% while k<=n
% 
%     [elemento, repitencia]=find(randomPos==randomPos(k));
% 
%     fprintf('El elemento %3d se repite %3d veces\n',randomPos(k),length(repitencia));
% 
%     randomPos(repitencia)=[];
% 
%     n=length(randomPos);
% 
% end


aux = 0;
for j=1:1:10 % Introducimos las rafagas
            lengthRafaga = randi([0,100000],1) % Las rafagas tendran longitudes aleatorias entre 0 y 100000 bits.
            
            % Siempre habrán 9 rafagas, la logitud de las cuales sera
            % entre 0 y 100.000 bits. ¿Porque? la longitud de los bits
            % interleaved siempre sera de 2.000.012 bits, esta cadena de
            % datos la dividiré entre 10 (cada trozo de 200.000bits),
            % entonces cada rafaga ira dentro de cada trozo de info, que
            % para protejer frente a solape entre rafagas ponemos como
            % maximo una longitud de rafaga de 100.000bits, donde sus
            % posiciones iniciales seran aleatorias entre la mitad y el
            % final de cada trozo.
                   
            %randomPosR = round(100000*rand+100000*(j)); % Posicion aleatoria que iniciara la rafaga
            %randomPosR= round(100000*rand+100000*j+100000*aux);
            randomPosR = 0+200*aux; % Cada inicio de paquete
            disp(['Rafaga num ',num2str(j)]);
            disp(['     - Posicion: ',num2str(randomPosR)]);
            disp(['     - Lenght: ',num2str(lengthRafaga)]);
            aux=aux+1;
end