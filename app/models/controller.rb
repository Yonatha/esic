class Controller < ApplicationRecord
  has_many :action

  # Lista os arquivos de Controllers localizados em app/controller
  def self.read_controllers_file_system
    controllers = []
    cs = Dir.entries("#{Rails.root}/app/controllers/")
    for ctrl in cs
      # ctrl = ctrl.sub(/([a-z])/) {|match| match.upcase}
      # ctrl = ctrl.sub(/_([a-z])/) {|match| match.upcase.sub(/_/, '')}
      if ctrl.include? '.rb'
        ctrl = ctrl.sub(/.rb/, '')
        controllers << ctrl
      end
    end
    return controllers
  end

  def self.check(arg)

    controller = Controller.where("name = '#{arg[:name]}' and status = 1").first

    if controller.present?
      return controller
    else
      return self.register(arg)
    end
  end

  def self.register(arg)
    controller = Controller.new
    controller.name = arg[:name]
    controller.status = 1
    if controller.save!
      return controller
    end
  end

end
