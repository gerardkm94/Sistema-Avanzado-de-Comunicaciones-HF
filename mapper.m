function s = mapper(systemParam,txBitsEncoded)
  
if systemParam.mapping.enabled==false
    s = txBitsEncoded;
else 
    s = modulate(systemParam.mapping.mapper,txBitsEncoded);    
end

end