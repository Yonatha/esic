# -*- encoding : utf-8 -*-

namespace :esic do


  task :teste => :environment do
    
  end

  task :instalar => :environment do

    # Cria o banco de dados
    Rake::Task["db:create"].invoke

    # Executa os migrations
    Rake::Task["db:migrate"].invoke
    
    # Cadastra perfis principais
    Rake::Task["esic:criar_perfil"].invoke

    # Cadastra usuário administrador
    Rake::Task["esic:criar_usuario_adminitrador"].invoke

  end

  task :teste => :environment do
    recursos = Controller.includes(:action).references(:action)
    recursos.each do |controller|
      p controller.name
      controller.action.each do |action|
        p action.name
      end
    end
  end

  # Criando perfil
  task :criar_perfil => :environment do

    name = 'Administrador'
    profile = Profile.new
    profile.name = name
    profile.save
    p "Perfil #{profile.name} criado!"

    name = 'Normal'
    profile = Profile.new
    profile.name = name
    profile.save
    p "Perfil #{profile.name} criado!"
  end

  task :autenticar_usuario => :environment do

    login = 'yonatha.almeida'
    password = '123'

    user = User.where("login = '#{login}' and password = '#{User.encripitar_senha(password)}'").first

    unless user.nil?
      p 'Correto'
      ap user
    else
      p 'Incorreto'
    end

  end


  # Criar usuário
  task :criar_usuario_adminitrador => :environment do

    user = User.new
    user.login = 'admin'
    user.nome = 'Administrador'
    user.email = 'yonathalmeida@gmail.com'
    user.password = User.encripitar_senha('123456')
    user.profile_id = Profile.where("name = 'Administrador'").first.id
    user.status = 1
    user.save!
    " - Usuário #{user.login} criado."

    modulo = Modulo.new
    modulo.users_id = user.id
    modulo.modulo_nome = 'e-SIC'
    modulo.uri = 'esic'
    modulo.status = 1
    modulo.save
    p " - Módulo #{modulo.modulo_nome} associado ao usuário #{user.login}"

  end


  # Associando usuário a um perfil
  task :create_user_profile => :environment do

    user = User.find(1)
    profile = Profile.find(1)
    user_profile = UserProfile.new
    user_profile.users_id = user.id
    user_profile.profiles_id = profile.id
    user_profile.save
    p "Registro #{user.login} vinculado ao perfil #{profile.name}"
  end

  # Cria permissão de perfil a controller e action
  task :criar_permissao => :environment do

    # perfis_do_usuario = UserProfile.new
    # perfis_do_usuario.users_id = 1
    # perfis_do_usuario.profiles_id = 1
    # perfis_do_usuario.save

    user = User.find(1)
    profile = Profile.find(1)
    @permission = Permission.new
    @permission.controllers_id = 1
    @permission.actions_id = 7
    @permission.profiles_id = profile.id
    @permission.status = 1
    @permission.save
    p "Permissão ao us-uário #{user.login} concedida ao perfil #{profile.name}"
  end

  task :verificar_permissao => :environment do

    user = User.find(1)

    action = 'index'
    controller = 'user'

    @permissions = Permission.includes({:user_profile => :user}, {:action => :controller}).where("users.id = #{user.id} and actions.name = '#{action}' and controllers.name = '#{controller}'").references(:action, :controllers, :user_profile, :user, :profile).first

    if @permissions
      abort('Aceito')
    else
      abort('Acesso negado')
    end


  end

  task :cadastrar_patrimonios => :environment do


    p1 = Patrimonio.new
    p1.nome = 'Notebook'
    p1.save

    p1 = Patrimonio.new
    p1.nome = 'Mesa'
    p1.save


  end

  task :enviando_codigo_ativacao => :environment do

    EsicMailer.enviar_codigo_ativacao('yonathalmeida@gmail.om', User.gerar_codigo_ativacao)

  end

  task :atualizar_recursos => :environment do


    recursos = []
    cs = Dir.entries("#{Rails.root}/app/controllers/")
    for ctrl in cs
      if ctrl.include? '.rb'
        ctrl = ctrl.sub(/.rb/, '').split('_')
        controller_class = ''
        ctrl.each do |x|
          controller_class << x.capitalize
        end

        recursos << {
            :controller => controller_class.downcase.gsub('controller', ''),
            :actions => Object.const_get(controller_class).action_methods - ApplicationController.action_methods
        }
      end
    end

    recursos.each do |recurso|
      @controller = Controller.where("name = '#{recurso[:controller]}'").first

      if !@controller.present?
        @controller = Controller.new
        @controller.name = recurso[:controller]
        @controller.status = 1
        @controller.save
      end

      recurso[:actions].each do |action|
        @action = Action.where("name = '#{action}' and controller_id = #{@controller.id}").first

        if !@action.present?
          @action = Action.new
          @action.name = action
          @action.controller_id = @controller.id
          @action.status = 1
          @action.save!
        end
      end
    end
  end
end
