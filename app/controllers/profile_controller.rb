class ProfileController < ApplicationController

  def index

    if session[:user]['perfil'] == 'Administrador'
      @profiles = Profile.where('status = 1')

      @controllers = Controller.where('status = 1')

      @dicionario = {
          'index' => 'Listar',
          'edit' => 'Editar',
          'show' => 'Exibir',
          'delete' => 'Excluir',
          'update' => 'Alterar',
          'create' => 'Novo'
      }

      respond_to do |format|
        format.html
        format.xml {render :xml => {:actions => @actions, :controllers => @controllers}}
      end
    else
      respond_to do |format|
        format.html {redirect_to '/', notice: 'Você não possui permissão para acessar esse recurso.'}
        format.json {head :no_content}
      end
    end
  end

  def update
  end

  def show
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

end
