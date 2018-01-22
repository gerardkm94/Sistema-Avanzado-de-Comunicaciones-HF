function s = demapper(systemParam,rxBitsEncoded)%demapper(systemParam,txBitsEncodedInterleaved)
 %   s = demodulate(systemParam.mapping.demapper,txBitsEncodedInterleaved);
    s = demodulate(systemParam.mapping.demapper,rxBitsEncoded);
 end