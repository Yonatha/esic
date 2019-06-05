class Permission < ApplicationRecord
  belongs_to :controller, :foreign_key => 'controllers_id'
  belongs_to :action, :foreign_key => 'actions_id'
  belongs_to :user_profile, :foreign_key => 'profiles_id'


  # Verifica se o controller possui um determinada action
  def self.verifica_controller_action(controllers_lista, controller_id, action_name)
    lista_acoes = []
    controllers_lista.each do |controller|
      controller.action.each do |action|
        lista_acoes.push({:controller => controller.id, :action => action.name})
      end
    end

    possui = false
    lista_acoes.each do |x|
      if x[:controller] == controller_id and x[:action] == action_name
        possui = true
      end
    end

    return possui
  end

  # Verifica se o perfil possui permissão para um controller
  # @param  arg{} perfil_id Chave primária do perifl
  # @param arg{} arg action_name Nome da ação testada
  # @param arg{} controller_id Chave primária do controller testado
  # @return boolean
  def self.verifica_permission_profile_action(arg = {})

    sql = "SELECT
          permissions.profiles_id AS profile_id,
          actions.name            AS action_name,
          controllers.id          AS controller_id,
          permissions.status      AS status
        FROM permissions
          JOIN controllers ON controllers.id = permissions.controllers_id
          JOIN actions ON actions.controller_id = controllers.id
          where profiles_id = #{arg[:perfil_id]} and action_name = '#{arg[:action_name]}' and controller_id = #{arg[:controller_id]}
        GROUP BY action_name;"

    permission = ActiveRecord::Base.connection.execute(sql)

    if permission.size == 0
      return false
    else
      return true
    end
  end

end
