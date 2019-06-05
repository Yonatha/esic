class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :verificar_autenticado

  # skip_before_action :verificar_credenciais, :only => [:logout]
  before_action :atualizar_recursos
  # before_action :verificar_permissao
  # skip_before_action :verificar_permissao, :only => [:dashboard]

  def verificar_autenticado

    if params[:controller] != 'users' && params[:action] != 'cadastrar'

    end


      if action_name == 'login'
        autenticar_usuario
      end

      if action_name == 'logout'
        session.delete(:user)

        # Se o usuário não estiver logado, então redireciona para a tela de login
      elsif session[:user].nil?
        respond_to do |format|

          if params[:action] == 'login'
            format.html {redirect_to '/', notice: "Nome de usuário ou senha inválida"}
          else
            format.html {render '/users/login'}
          end
        end

        # Se o usuário estiver logado
      elsif !session[:user].nil?

        # E se a id do usuário for nula
        # TODO Revisar essa parte para não precisar setar se é como string ou como chave
        if session[:user]["id"].nil?
          usuario_atual = session[:user][:id]
        elsif session[:user][:id].nil?
          usuario_atual = session[:user]["id"]
        end

        # Se o perfil do usuário for diferente de Administrador e o nome do controlador que tiver acessando for diferente
        # de condominio
        if session[:user]["perfil"] != 'Administrador' && controller_name != 'condominios'

          # Abre o dashboard
          return dashboard_system_index_path
        else

          if Modulo.where("users_id = #{usuario_atual} and modulo_nome = '#{controller_name.singularize}'").size == 0
            if session[:user]["perfil"] != 'Administrador' && session[:user].nil?
              respond_to do |format|
                format.html {render :template => "users/login"}
              end
            end
          end
        end
      end


  end

  def atualizar_recursos

    @controller = Controller.where("name = '#{params[:controller]}' and status = 1").first

    if !@controller.present?
      @controller = Controller.new
      @controller.name = params[:controller]
      @controller.status = 1
      @controller.save!
    end

    @action = Action.where("name = '#{params[:action]}' and controller_id = #{@controller.id} and status = 1").first

    if !@action.present? && @controller.present?
      @action = Action.new
      @action.name = params[:action]
      @action.controller_id = @controller.id
      @action.status = 1
      @action.save
    end
  end

  def verificar_permissao

    sql = "SELECT *
    FROM permissions
      JOIN controllers ON controllers.id = permissions.controllers_id
      JOIN actions ON actions.controller_id = controllers.id
    WHERE actions.name = '#{action_name}' AND controllers.name = '#{controller_name}' and permissions.profiles_id = #{session[:user]["perfil"].id} and permissions.status = 1"

    @permissions = ActiveRecord::Base.connection.execute(sql)

    if @permissions.size == 0
      respond_to do |format|
        flash[:warning] = "Acesso negado ao recurso solciitado."
        format.html { redirect_to "/" }
      end
    end

  end

  def verificar_permissao2


    @controller = Controller.where("name = '#{controller_name}'").first
    @action = Action.where("name = '#{action_name}' and controller_id = #{@controller.id}").first

    @permissions = Permission.where("profiles_id = #{session[:user]["perfil_id"]} and actions_id = #{@action.id} and controllers_id = '#{@controller.id}'").first

    abort @permissions.inspect
    if !@permissions
      respond_to do |format|
        flash[:warning] = "Acesso negado ao recurso solciitado."
        format.html {redirect_to "/"}
      end
    end

  end


  private
  def autenticar_usuario

    unless params[:login].nil? && params[:password].nil? || params[:password].blank? || params[:login].blank?
      @user = User.where("login = '#{params[:login].downcase}' and password = '#{User.encripitar_senha(params[:password])}' and status = 1").first
      unless @user.nil?
        session[:user] = {
            :id => @user.id,
            :login => @user.login,
            :nome => @user.nome,
            :email => @user.email,
            :perfil => @user.profile.name,
            :perfil => @user.profile
        }

        ap 'Correto'

        # Módulos do usuário
        modulos = Modulo.where("users_id = #{@user.id}")



        if session[:user][:perfil].name == 'Administrador'
          respond_to do |format|
            format.html {redirect_to '/', notice: "Seja Bem Vindo  #{@user.login}"}
          end
        else


          # binding.pry
          respond_to do |format|
            format.html {redirect_to '/esic/', notice: "Seja Bem Vindo  #{@user.login}"}
          end
        end
      end
    end
  end
end
