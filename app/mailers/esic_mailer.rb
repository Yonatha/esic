class EsicMailer < ApplicationMailer

  default from: "you-email@gmail.com"

  def enviar_codigo_ativacao(destinatario, codigo)

    @codigo = codigo


    ap 'Enviando Email'
    mail(to: destinatario,
         subject: 'e-SIC - Código de Ativação da Conta')
         # template_path: 'enviar_codigo_ativacao',
         # template_name: 'another')

    ap '- Email enviado'
  end


  def notificar_cidadao(destinatario, protocolo)

    @protocolo = protocolo

    mail(to: destinatario,
         subject: "e-SIC - Solicitação de Informação Protocolo Nº #{@protocolo}")
  end
end
