class Action < ApplicationRecord

  belongs_to :controller

  def self.check(arg)

    action = Action.where("name = '#{arg[:name]}' and controller_id = #{arg[:controller_id]} and status = 1").first

    if action.present?
      return action
    else
      return self.register(arg)
    end
  end

  def self.register(arg)
      action = Action.new
      action.name = arg[:name]
      action.controller_id = arg[:controller_id]
      action.status = 1
      if action.save!
        return action
      end
  end

end
