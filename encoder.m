function txBitsEncoded = encoder(systemParam,txBits)

%Añadimos el tail necesario para que salga el codificador
tail = zeros(1,systemParam.coding.zeroTail);
txBits = horzcat(txBits,tail);

txBitsEncoded = convenc(txBits,systemParam.coding.trellis);
systemParam.coding.encoderOutLength = length(txBitsEncoded);

% Entrada + tail (convertido a trellis válido)


%     sizetxBits=length(txBits);
%     txBitsEncoded=zeros(sizetxBits/2,1);
%     contador = 1;
%     for i=1:2:sizetxBits
%         
%         if txBits(i)==0 && txBits(i+1)==0
%             
%            txBitsEncoded(contador)=0;
%             
%         elseif txBits(i)==0 && txBits(i+1)==1
%             
%            txBitsEncoded(contador)=1;
%             
%         elseif txBits(i)==1 && txBits(i+1)==0
%             
%             txBitsEncoded(contador)=2;
%             
%         elseif txBits(i)==1 && txBits(i+1)==1
%             
%             txBitsEncoded(contador)=3;
%             
%             
%         end
%        contador = contador +1;
%     end
end
