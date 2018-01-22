function txBitsEncodedInterleaved = interleaver(systemParam,txBitsEncoded)

    if strcmp(systemParam.interleaving.type,'deep')||strcmp(systemParam.interleaving.type,'shallow')
        %Añadimos el tail para limpiar memoria
        tail = zeros(1,systemParam.interleaving.delay); 

        txBitsEncodedInterleaved = convintrlv(horzcat(txBitsEncoded,tail),systemParam.interleaving.nRows,systemParam.interleaving.slope);
        systemParam.interleaving.interleaverOutLength = length(txBitsEncodedInterleaved);

    elseif strcmp(systemParam.interleaving.type,'none')
        txBitsEncodedInterleaved =txBitsEncoded;
    end
end