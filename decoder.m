function rxBits = decoder(systemParam,rxBitsEncoded) 

%DECODIFICADOR VITERBI CON EL TRELLIS CALCULADO
rxBits2 = vitdec(rxBitsEncoded,systemParam.coding.trellis,systemParam.coding.traceBackLength,'cont','hard');
%almacenamos los valores obtenidos en la decodificacion en una variable
%auxiliar
for i=systemParam.coding.zeroTail+1:(length(rxBits2))
     rxBitssup(i-systemParam.coding.zeroTail)=rxBits2(i);
end

rxBits = rxBitssup;

end
