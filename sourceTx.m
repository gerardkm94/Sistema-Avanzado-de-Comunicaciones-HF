function txBits = sourceTx(systemParam)

%Funcion que genera numeros aleatorios
%txBits = randi([0,1],1,systemParam.nDataBits);

%Establecemos la cadena a mano para poder comprobar la efectividad sin que
%nos varie la fuente en cada ejecucion de codigo y asi poder comparar
%resultados

txBits = [1	1	0	1	1	0	0	1	1	1	0	1	1	0	1	0	0	1	1	1	1	0	1	1	1	1	1	0	1	0	1	0	0	0	0	1	1	0	1	0	0	0	1	1	0	0	0	1	1	1	0	1	1	0	0	0	1	0	1	0	1	0	1	1	1	1	1	0	0	0	1	0	1	0	1	0	0	0	1	0	0	1	1	1	1	0	1	1	0	1	0	0	1	1	1	0	1	0	0	0	0	1	0	1	0	1	0	1	1	1	0	0	0	1	0	1	1	1	0	0	0	1	0	1	1	1	0	0	0	1	0	1	0	0	0	0	1	1	1	0	1	1	0	1	0	0	0	0	0	0	0	0	1	1	0	0	0	1	0	0	1	0	0	0	0	0	1	1	1	0	0	0	1	0	0	0	1	1	1	0	1	0	1	0	1	0	0	1	1	0	1	1	0	0	0	0	1	1	1	1	1	0	1	1	0	1	1	1	1	1	0	0	0	0	1	0	0	0	0	0	0	1	0	0	1	1	0	0	0	0	1	0	1	1	0	0	0	0	0	1	0	0	1	0	1	1	0	1	0	0	1	1	1	0	0	1	1	0	0	1	0	1	1	1	0	0	0	1	0	1	0	1	0	1	1	1	1	0	1	0	0	1	1	0	1	1	1	1	1	1	0	0	1	0	0	0	1	1	1	0	0	1	0	0	1	0	1	1	1	0	1	1	1	1	1	0	0	1	0	0	0	0	1	1	0	0	1	0	1	1	0	0	0	1	0	0	0	0	0	0	1	1	0	1	0	0	1	1	0	1	0	1	1	1	1	1	0	0	1	0	0	1	1	1	0	0	0	1	0	1	1	0	0	0	0	0	1	0	0	1	0	0	1	0	1	1	1	0	1	0	1	1	1	0	1	0	0	0	0	0	0	0	1	0	1	1	1	0	0	0	1	1	0	1	1	1	1	0	0	1	1	0	0	0	0	0	0	1	0	1	1	1	1	1	0	1	0	1	1	0	0	0	1	1	0	1	1	0	1	0	1	0	0	0	0	1	0	1	0	0	0	1	0	0	0	1	0	1	0	1	0	1	0	0	0	1	1	1	0	1	1	1	1	1	0	1	0	0	1	0	0	1	1	0	1	0	1	1	0	1	1	1	1	0	0	0	1	1	0	1	1	1	1	1	1	1	0	0	0	0	0	0	0	1	1	1	1	1	0	0	1	0	1	1	1	0	0	1	1	1	0	0	1	0	0	1	0	0	1	0	1	0	1	1	0	0	0	0	0	0	1	0	1	0	1	0	1	1	0	0	1	1	0	1	0	1	1	0	1	1	1	1	1	0	0	0	1	1	1	0	1	0	0	0	1	0	0	0	0	0	1	1	1	1	1	1	1	1	0	1	1	1	1	0	1	0	0	1	1	1	1	1	0	1	0	1	1	1	1	1	1	1	1	1	0	0	1	0	1	0	1	1	0	1	0	0	0	0	0	0	0	0	0	1	0	1	1	0	1	0	0	0	1	1	0	0	1	1	0	0	1	0	0	0	0	1	1	0	1	1	1	0	1	1	1	1	1	1	0	0	0	0	1	0	0	0	0	1	0	1	1	1	0	0	0	0	1	0	1	0	1	1	1	1	0	0	0	1	1	0	0	0	0	1	0	0	0	1	1	0	1	0	1	1	1	0	1	0	0	0	1	0	0	0	0	0	1	0	0	0	0	0	1	0	0	0	0	0	1	1	1	0	0	1	1	1	0	1	0	0	1	0	0	1	1	1	1	1	1	0	1	1	0	0	1	0	1	1	0	0	1	0	1	1	1	0	0	0	1	1	1	0	1	0	0	1	0	1	1	1	1	0	1	1	1	0	0	0	1	1	1	0	0	0	1	0	0	1	0	1	0	0	1	0	0	0	1	0	0	0	0	1	0	1	1	0	1	1	0	1	0	1	0	0	1	0	1	0	0	0	1	0	0	1	0	0	1	1	0	0	0	0	0	1	1	1	0	1	0	0	0	0	0	0	0	0	0	0	1	1	1	0	0	0	1	1	1	0	0	1	1	0	0	0	0	1	0	1	0	1	0	0	0	1	1	0	1	0	1	1	1	0	0	0	0	0	1	1	0	0	0	0	0	0	1	1	1	0	0	1	1	1	1	0	1	0	0	0	1	0	0	1	1	1	1	0	1	1	1	0	1	1	0	1	0	1	0	0	0	0	0	1	1	1	0	1	1	1	0	0	1	0	0	1	1	1	1	0	0	1	0	1	1	1	1	1	1	0	0	1];



% if strcmp(systemParam.mapping.type, 'bpsk')
% % Para bpsk de 0 a 1
%        txBits = randi([0,1],1,systemParam.nDataBits);
% elseif strcmp(systemParam.mapping.type, 'qpsk')
% % Para qpsk de 0 a 3
%        txBits = randi([0,3],1,systemParam.nDataBits);
% elseif strcmp(systemParam.mapping.type, 'qam16')
% % Para qam16 de 0 a 15
%        txBits = randi([0,15],1,systemParam.nDataBits);
% elseif strcmp(systemParam.mapping.type, 'qam64')
% % Para qam64 de 0 a 63
%        txBits = randi([0,63],1,systemParam.nDataBits);
% else 
%     disp('Modulacion introducida no valida');    

end