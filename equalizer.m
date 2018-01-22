function [HEstimated,rxSymbols] = equalizer(systemParam,Sfft,indexPilotSc_f)

  %Matriz estimada del canal, del mismo tamaño que la matriz de salida ya
  %que posteriormente deben convolucionarse y deben tener el mismo tamaño
  if systemParam.equalization.enabled==true
      HEstimated = zeros (systemParam.ofdm.nFft,ceil(systemParam.ofdm.modulatorOutnOfdmSymbols));
      %TODO OKA
      %Añadimos pilotos
      %HEstimated (systemParam.ofdm.indexPi lotSc,:) = Sfft(systemParam.ofdm.indexPilotSc,:);
      %Tenemos que hacerle saber donde estan los pilotos en el modo matlab!
      Sfft2=Sfft(:);  
      interpolacion = interp1(indexPilotSc_f,Sfft2(indexPilotSc_f,:),1:1:(systemParam.ofdm.nFft*ceil(systemParam.ofdm.modulatorOutnOfdmSymbols)),'linear', 'extrap');

      HEstimated = interpolacion;

      %En el caso de que fuera tiempo 
      %rxSymbolspruebba=Sfft2'.*HEstimated;

      for i=1:length(HEstimated)
          volatil(i)=Sfft2(i)/HEstimated(i);
      end 
      rxSymbols=volatil;
  
  else 
      rxSymbols=Sfft(:);
      HEstimated=0;
  end
end      
