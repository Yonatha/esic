class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verificar_autenticado, only: [:cadastrar, :registrar_usuario, :ativar_usuario, :enviar_codigo_ativacao]

  layout "login", :only => :login

  # GET /users
  # GET /users.json
  def index


    unless session[:user].nil?
      if session[:user]['perfil'] == 'Administrador'
        @users = User.all
      else
        respond_to do |format|
          flash[:warning] ='Você não possui permissão para acessar esse recurso.'
          format.html {redirect_to '/'}
        end
      end
    else
      respond_to do |format|
        format.html {redirect_to '/'}
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    if session[:user]['perfil'] == 'Administrador'
      @user = User.new
    else
      respond_to do |format|
        flash[:notice] = 'Você não possui permissão para acessar esse recurso.'
        format.html {redirect_to '/'}
        format.json {head :no_content}
      end
    end

  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create

    if session[:user]['perfil'] == 'Administrador'
      @user = User.new
      @user.nome = params[:user][:nome]
      @user.login = params[:user][:login]
      @user.email = params[:user][:email]
      @user.profile_id = params[:user][:profile_id]

      respond_to do |format|
        if @user.save

          # Vincula perfis aos usuário
          # vincular_user_profiles

          # Vincula os módulos e dominios ao usuário
          vincular_modulos_ao_usuario

          flash[:notice] = 'Usuário criado com sucesso.'
          format.html {redirect_to '/users'}
          format.json {render :show, status: :created, location: @user}
        else
          format.html {render :new}
          format.json {render json: @user.errors, status: :unprocessable_entity}
        end
      end
    else
      respond_to do |format|
        flash[:warning] = 'Você não possui permissão para acessar esse recurso.'
        format.html {redirect_to '/'}
        format.json {head :no_content}
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

    if session[:user]['perfil'] == 'Administrador'
      respond_to do |format|
        @user.nome = params[:user][:nome]
        @user.login = params[:user][:login]
        @user.email = params[:user][:email]
        @user.profile_id = params[:user][:profile_id]

        @user.password = User.encripitar_senha(params[:user][:password])
        @user.telefone = params[:user][:telefone]

        # Vincula perfis aos usuário
        # vincular_user_profiles

        # Vincula os módulos e dominios ao usuário
        vincular_modulos_ao_usuario

        if @user.save
          flash[:notice] = 'Usuário atualizado com sucesso.'
          format.html {redirect_to '/users/'}
          format.json {render :show, status: :ok, location: @user}
        else
          format.html {render :edit}
          format.json {render json: @user.errors, status: :unprocessable_entity}
        end
      end
    else
      respond_to do |format|
        flash[:warning] = 'Você não possui permissão para acessar esse recurso.'
        format.html {redirect_to '/'}
        format.json {head :no_content}
      end
    end
    # vincular_user_profiles
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy


    if session[:user]['perfil'] == 'Administrador'
      @user.destroy
      respond_to do |format|
        flash[:warning] = 'usuário excluído com sucesso'
        format.html {redirect_to users_url}
        format.json {head :no_content}
      end
    else
      respond_to do |format|
        flash[:warning] = 'Você não possui permissão para acessar esse recurso.'
        format.html {redirect_to '/'}
        format.json {head :no_content}
      end
    end
  end

  def login
    
    respond_to do |format|
      if session[:user].nil?
        format.html {render :login}
      else
        format.html {render 'system/dashboard', :layout => 'dashboard'}
      end
    end
  end

  def logout
    # session[:user].clear
    session.delete(:user)
    respond_to do |format|
      format.html {redirect_to '/'}
    end
  end


  # URL para cadastro de usuário público
  def cadastrar

    if session[:user].present?
      respond_to do |format|
        format.html {redirect_to '/login'}
      end
    else
      respond_to do |format|
        format.html {render :cadastro, :layout => 'orobo_esic'}
      end
    end


  end

  def registrar_usuario

    usuario = User.new
    usuario.nome = params[:nome]
    usuario.email = params[:email]
    usuario.login = params[:email]
    usuario.password = User.encripitar_senha(params[:password])
    usuario.status = 0 # Desabilitado
    usuario.codigo_ativacao = User.gerar_codigo_ativacao
    usuario.profile_id = 2 # Normal
    usuario.save!

    esic_detalhes = EsicUsuarioDetalhe.new
    esic_detalhes.cpf = params[:cpf]
    esic_detalhes.rg = params[:rg]
    esic_detalhes.data_nascimento = params[:data_nascimento]
    esic_detalhes.tipo_pessoa = params[:tipo_pessoa]
    esic_detalhes.usuario_id = usuario.id
    esic_detalhes.save!

    EsicMailer.enviar_codigo_ativacao(usuario.email, usuario.codigo_ativacao).deliver

    respond_to do |format|
      format.html {redirect_to '/users/cadastrar?etapa=ativar', :layout => 'orobo_esic'}
    end

  end


  def enviar_codigo_ativacao

    unless params[:email].nil?

      @user = User.where("email = '#{params[:email]}'").first
      if !@user.nil?

        @user.codigo_ativacao = User.gerar_codigo_ativacao
        @user.save!

        EsicMailer.enviar_codigo_ativacao(@user.email, @user.codigo_ativacao).deliver

        respond_to do |format|
          format.html {redirect_to '/users/cadastrar?etapa=ativar', :layout => 'orobo_esic'}
        end
      else
        respond_to do |format|
          format.html {redirect_to '/users/cadastrar?etapa=erro', :layout => 'orobo_esic'}
        end
      end
    end
  end


  # Ativa o usuário baseado no codigo de ativação informado pelom usuárioN
  def ativar_usuario

    unless params[:codigo_ativacao].nil?

      @user = User.where("status = 0 and codigo_ativacao = #{params[:codigo_ativacao]}").first
      if !@user.nil?

        @user.status = 1
        @user.codigo_ativacao = nil
        @user.save!

        respond_to do |format|
          format.html {redirect_to '/users/cadastrar?etapa=sucesso', :layout => 'orobo_esic'}
        end
      else
        respond_to do |format|
          format.html {redirect_to '/users/cadastrar?etapa=erro', :layout => 'orobo_esic'}
        end
      end
    end

  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Associa profiles ao usuário
  def vincular_user_profiles
    UserProfile.where("users_id = #{@user.id}").delete_all
    params[:profiles].each do |profiles|
      user_profile = UserProfile.new
      user_profile.users_id = @user.id
      user_profile.profiles_id = profiles.to_i
      user_profile.save!
    end
  end

  def vincular_modulos_ao_usuario

    # Remover
    Modulo.where("users_id = #{@user.id}").delete_all

    unless params[:modulo][:modulo] == 0
      # Atualiza
      modulo = Modulo.new
      modulo.modulo_nome = params[:modulo][:modulo]
      modulo.dominio = params[:modulo][:dominio]
      modulo.users_id = @user.id
      modulo.status = 1
      modulo.save
    end

  end
end
