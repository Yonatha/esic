module ApplicationHelper
  def flash_message
    messages = ""

    @mensagem = nil
    @tipo = nil

    [:notice, :info, :warning, :error].each {|type|
      if flash[type]
        @mensagem = flash[type]
        @tipo = type
      end
    }
    unless @tipo.nil?
      render partial: '/layouts/flash_messages', mensagem: @mensagem, type: @tipo
    end
  end

  def administrador?
    if session[:user]['perfil']['name'] == 'Administrador'
      return true
    else
      return false
    end
  end
end