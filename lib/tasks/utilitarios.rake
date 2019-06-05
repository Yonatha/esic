# -*- encoding : utf-8 -*-
require "prawn"
require "awesome_print"

namespace :utilitarios do

  # Criando usuário
  task :create_user => :environment do

    @user = User.new
    @user.login = 'yonatha.almeida'
    @user.nome = 'Yonatha Almeida'
    @user.email = 'yonathalmeida@gmail.com'
    @user.password =  User.encripitar_senha('123')
    @user.save
    p "Registro #{@user.login} criado"
  end

  # Criando perfil
  task :create_profile => :environment do

    name = 'Administrador'
    @profile = Profile.new
    @profile.name = name
    @profile.save
    p "Perfil #{@profile.name} criado!"

    name = 'Normal'
    @profile = Profile.new
    @profile.name = name
    @profile.save
    p "Perfil #{@profile.name} criado!"
  end

  # Associando usuário a um perfil
  task :create_user_profile => :environment do

    @user = User.find(1)
    @profile = Profile.find(1)
    @user_profile = UserProfile.new
    @user_profile.users_id = @user.id
    @user_profile.profiles_id = @profile.id
    @user_profile.save
    p "Registro #{@user.login} vinculado ao perfil #{@profile.name}"
  end

  # Cria permissão de perfil a controller e action
  task :criar_permissao => :environment do

    # perfis_do_usuario = UserProfile.new
    # perfis_do_usuario.users_id = 1
    # perfis_do_usuario.profiles_id = 1
    # perfis_do_usuario.save

    @user = User.find(1)
    @profile = Profile.find(1)
    @permission = Permission.new
    @permission.controllers_id = 1
    @permission.actions_id = 7
    @permission.profiles_id = @profile.id
    @permission.status = 1
    @permission.save
    p "Permissão ao us-uário #{@user.login} concedida ao perfil #{@profile.name}"
  end

  task :verificar_permissao => :environment do

    @user = User.find(1)

    action = 'index'
    controller = 'user'

    @permissions = Permission.includes({:user_profile => :user}, {:action => :controller}).where("users.id = #{@user.id} and actions.name = '#{action}' and controllers.name = '#{controller}'").references(:action, :controllers, :user_profile, :user, :profile).first

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


  # Gera documentos de pdf de exemplo para um determinado condominio
  task :gerar_pdf_de_exemplo => :environment do


    @condominio = Condominio.find(3)

    exercicios = [
        2017 => (1...5).to_a,
        # 2016 => (1...13).to_a,
        # 2015 => (1...13).to_a,
        # 2014 => (1...13).to_a,
        # 2013 => (1...13).to_a,
    ]

    p "Massa de dados de exemplo para o o condominio #{@condominio.nome} - CNPJ: #{@condominio.cnpj}"
    exercicios.each do |exercicio|
      exercicio.each do |periodo|
        ano = periodo[0]
        meses = periodo[1]


        caminho = "#{Rails.root}/public/uploads/condominio/#{@condominio.cnpj}/"
        Dir.mkdir(caminho) unless File.exists?(caminho)

        caminho << "#{ano}/"
        Dir.mkdir(caminho) unless File.exists?(caminho)

        meses.each do |mes|

          conteudo = "#{@condominio.nome} - Exercício: #{mes}/#{ano}"

          # Gera o arquivo físico
          p "Gerando arquivo de exemplo para o período #{conteudo}"
          Prawn::Document.generate("#{caminho}/#{mes}.pdf") do
            text conteudo
          end

          # Persiste as informações do arquivo associadas ao condominio
          ca = CondominioArquivo.new
          ca.periodo_inicial = "#{ano}-#{mes}-01"
          ca.periodo_final = "#{ano}-#{mes}-28"
          ca.receita = 1
          ca.despesa = 2
          ca.saldo = 3
          ca.condominio_id = @condominio.id
          ca.save
        end
      end
    end
    p 'Tarefa executada com sucesso.'
  end


end
