function rxMultipath = multipathChannel(systemParam,txOfdmSymbols)
% Es el resultado de la convolución entre nuestro  señal OFDM de la salida
% de nuestro modulador OFDM con la respuesta impulsional del canal h(t),
% generada y inicializada en initMultipath.
if systemParam.multipath.enabled == true
    rxMultipath_extended = conv(txOfdmSymbols,systemParam.multipath.h);
    rxMultipath = ones(1,length(txOfdmSymbols));

% Al realizar la convolución, la longitud del resultante es M+L-1. Donde M 
% es la longitud de txOfdmSymbols y L de systemParam.multipath.h.
% Debemos recortar las L-1 Muestras de la cola del vector resultante.

    for i=1:length(rxMultipath)
        rxMultipath(i)=rxMultipath_extended(i);
    end

    else
        rxMultipath = txOfdmSymbols;
end

end