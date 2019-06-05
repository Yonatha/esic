class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all
    @controllers = Controller.includes(:action).references(:action)
    @dicionario = {
        'index' => 'Listar',
        'edit' => 'Editar',
        'show' => 'Exibir',
        'delete' => 'Excluir',
        'destroy' => 'Excluir',
        'update' => 'Salvar alterações',
        'create' => 'Criar',
        'new' => 'Novo',
        'dashboard' => 'Dashboard',
        'users' => 'Usuários',
        'system' => 'Sistema',
        'profiles' => 'Perfil',
        'update_resources' => 'Atualizar Recursos',
        'carregar_dominos' => 'Carregar Domínios',
        'salvar_arquivo' => 'Salvar Arquivo',
        'assistente' => 'Assistente de envio de arquivo',
        'preview' => 'Pré-visualizar arquivo',
        'salvar_permissao' => 'Gerenciar Permissões',

    }

    respond_to do |format|
      format.html
    end
  end

  def salvar_permissao

    unless params[:permission].nil?

      profile_id = params[:profile_id]

      # Limpa para poder atualizar
      Permission.where("profiles_id = #{profile_id}").destroy_all

      params[:permission].each do |permission|
        controller_id = permission.split(',')[0].to_i
        action_id = permission.split(',')[1].to_i

        p = Permission.new
        p.controllers_id = controller_id
        p.actions_id = action_id
        p.profiles_id = profile_id
        p.status = 1
        p.save!
      end
    end
    flash[:success] = 'Operação realizada com sucesso.'
    respond_to do |format|
        format.html {redirect_to '/profiles/'}
      end
  end


  # GET /profiles/1
  # GET /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html {redirect_to @profile, notice: 'Profile was successfully created.'}
        format.json {render :show, status: :created, location: @profile}
      else
        format.html {render :new}
        format.json {render json: @profile.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html {redirect_to @profile, notice: 'Profile was successfully updated.'}
        format.json {render :show, status: :ok, location: @profile}
      else
        format.html {render :edit}
        format.json {render json: @profile.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html {redirect_to profiles_url, notice: 'Profile was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  def update_resources
    controllers = Controller.read_controllers_file_system
    controllers_processados = []
    controller = nil
    controllers.each do |c|
      controller_name = c.gsub "_controller", ""
      unless controller_name == 'application'
        controller_class = (c.capitalize.gsub '_controller', 'Controller').gsub('.rb', '')
        controller_class.constantize.action_methods.each do |action_name|
          unless controllers_processados.include? controller_name
            controllers_processados.push controller_name
            controller = Controller.check({:name => controller_name})
            unless controller.present?
              p "Controller '#{controller_name}' registrado"
            end

          end
          unless action_name == 'check_permission'
            a = Action.check({:name => action_name, :controller_id => controller.id})
            unless a.present?
              p "Action '#{action_name}' registrada"
            end
          end
        end
      end
    end
    render :json => {'msg' => 'Atualizar novamente.'}
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit(:name, :description, :status)
  end
end
