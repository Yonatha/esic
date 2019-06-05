class EsicController < ApplicationController

  skip_before_action :verificar_autenticado, only: [:index]

  layout "orobo_esic"

  include ApplicationHelper

  def index
    respond_to do |format|
      if !administrador?
        format.html {render :index}
      else
        format.html {render 'adm_index'}
      end
    end
  end

  def show
  end

  # Criar Solicitação de informação
  def solicitar

    solicitacao = EsicSolicitacao.new
    solicitacao.usuario_id = session[:user]["id"]
    solicitacao.tipo_solicitacao_id = params[:tipo_solicitacao_id]
    solicitacao.orgao_destinatario_id = params[:orgao_destinatario_id]
    solicitacao.descricao = params[:descricao]
    solicitacao.status = 0
    solicitacao.resposta_recebimento = 0
    solicitacao.resposta_arquivo = nil
    solicitacao.resposta_visualizada = 0
    solicitacao.resposta_data = nil
    solicitacao.abertura_data = DateTime.now
    solicitacao.protocolo = "#{params[:orgao_destinatario_id].rjust(4, '0')}.#{DateTime.now.year.to_s}.#{session[:user]["id"]}"
    solicitacao.save

    respond_to do |format|
      flash[:notice] = "Solicitação realizada com sucesso. Número do protocolo é: #{solicitacao.protocolo}"
      format.html {redirect_to '/esic/'}
    end

  end

  def responder

    @solicitacao = EsicSolicitacao.find(params[:solicitacao_id])

    if params[:arquivo]
      @solicitacao.resposta_arquivo = self.salvar_arquivo
      @solicitacao.status = EsicSolicitacao::RESPONDIDA
      @solicitacao.	resposta_data = DateTime.now
      if @solicitacao.save
        EsicMailer.notificar_cidadao(@solicitacao.user.email, @solicitacao.protocolo).deliver
        respond_to do |format|
          flash[:notice] = "Solicitação de Informação #{@solicitacao.protocolo} respondida. Uma email foi enviado para o cidadão."
          format.html {redirect_to '/esic/'}
        end
      end

    else
      respond_to do |format|
        format.html {render :adm_responder}
      end
    end
  end

  def salvar_arquivo

    arquivo = params[:arquivo]
    caminho = "public/uploads/esic/respostas/"

    arquivo_extensao = arquivo.original_filename.split('.')[-1]
    arquivo_nome = "#{@solicitacao.protocolo}.#{arquivo_extensao}"

    # caminho = File.join(Rails.root, caminho, arquivo.original_filename)
    caminho = File.join(Rails.root, caminho, arquivo_nome)
    File.open(caminho, "wb") do |f|
      f.write(arquivo.read)
    end

    return arquivo_nome
  end

  def visualizar_resposta

    @solicitacao = EsicSolicitacao.find(params[:solicitacao_id])

    if @solicitacao.resposta_arquivo.present?

      caminho = "#{Rails.root}/public/uploads/esic/respostas/#{@solicitacao.resposta_arquivo}"

      if File.file?(caminho)
        send_file caminho,
                  # :type => "pdf",
                  :file_name => @solicitacao.resposta_arquivo,
                  :disposition => 'inline',
                  :stream => false

        if session[:user]['id'] == @solicitacao.usuario_id
          @solicitacao.resposta_visualizada = 1
          @solicitacao.save
        end
      else
        respond_to do |format|
          format.html {render "erro", :layout => false}
        end
      end
    end
  end

  def cancelar_solicitacao

    unless params[:solicitacao_id].blank?
      @solicitacao = EsicSolicitacao.find(params[:solicitacao_id])

      if @solicitacao
        @solicitacao.status = EsicSolicitacao::CANCELADA_PELO_CIDADAO
        @solicitacao.save
        respond_to do |format|
          flash[:notice] = "Solicitação de informação cancelada com sucesso."
          format.html {redirect_to '/esic/'}
        end
      end
    end
  end


end  