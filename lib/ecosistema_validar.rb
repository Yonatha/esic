class EcosistemaValidar

  def self.cnpj(cnpj=nil)
    return false if cnpj.nil?

    winvalidos = %w{11111111111111 22222222222222 33333333333333 44444444444444 55555555555555 66666666666666 77777777777777 88888888888888 99999999999999 00000000000000}
    wvalor = cnpj.scan /[0-9]/
    if wvalor.length == 14
      unless winvalidos.member?(wvalor.join)
        wvalor = wvalor.collect {|x| x.to_i}
        wsoma = wvalor[0]*5+wvalor[1]*4+wvalor[2]*3+wvalor[3]*2+wvalor[4]*9+wvalor[5]*8+wvalor[6]*7+wvalor[7]*6+wvalor[8]*5+wvalor[9]*4+wvalor[10]*3+wvalor[11]*2
        wsoma = wsoma - (11*(wsoma/11))
        wresult1 = (wsoma==0 || wsoma==1) ? 0 : 11 - wsoma
        if wresult1 == wvalor[12]
          wsoma = wvalor[0]*6+wvalor[1]*5+wvalor[2]*4+wvalor[3]*3+wvalor[4]*2+wvalor[5]*9+wvalor[6]*8+wvalor[7]*7+wvalor[8]*6+wvalor[9]*5+wvalor[10]*4+wvalor[11]*3+wvalor[12]*2
          wsoma = wsoma - (11*(wsoma/11))
          wresult2 = (wsoma == 0 || wsoma == 1) ? 0 : 11 - wsoma
          return true if wresult2 == wvalor[13] # CNPJ validado
        end
      end
    end
    return false # CNPJ invalidado
  end

  # TODO implementar a validação desse método
  def self.cpf
    # ...
  end

end
