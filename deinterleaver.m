function rxBitsEncoded = deinterleaver(systemParam,rxBitsEncodedInterleaved)

rxBitsEncoded2 = convdeintrlv(rxBitsEncodedInterleaved,systemParam.interleaving.nRows,systemParam.interleaving.slope);

rxBitsEncoded(1,:)=rxBitsEncoded2(systemParam.interleaving.delay+1:length(rxBitsEncoded2));

%Antes usabamos este método pero simplificamos con la linea de arriba
%for i=1:(length(rxBitsEncoded2)-length(tail))
%   rxBitsEncoded(i)=rxBitsEncoded2(i+length(tail));
%end
%rxBitsEncoded = rxBitsEncoded2;



end