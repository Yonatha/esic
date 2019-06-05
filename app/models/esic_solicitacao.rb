class EsicSolicitacao < ApplicationRecord
  self.table_name = "esic_solicitacao"

  belongs_to :user, :foreign_key => 'usuario_id'



  ABERTA = 0
  RESPONDIDA = 1
  CANCELADA_PELO_CIDADAO = 2


  def orgao_solicitante_humanize

    orgao_destinatario = []
    orgao_destinatario[1] = 'Prefeitura Municipal de Orobó'
    orgao_destinatario[2] = 'Câmara Municipal de Orobó'
    orgao_destinatario[3] = 'Fundo Municipal de Saúde de Orobó'
    orgao_destinatario[4] = 'Fundo Municipal de Assistência Social de Orobó'
    orgao_destinatario[5] = 'Instituto de Previdência de Orobó'

    return orgao_destinatario[self.orgao_destinatario_id]

  end


  def status_humanize

    status = []
    status[0] = 'Aberto'
    status[1] = (self.status == 1 && self.resposta_visualizada == 1 ? 'Cidadão visualizou' : 'Atendido')
    status[2] = 'Cancelado pelo Cidadão'

    return status[self.status]

  end

end