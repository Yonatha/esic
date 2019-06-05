class MudarColunaRelacionadaAoControllerEmAction < ActiveRecord::Migration[5.0]
  def change
    rename_column :actions, :controllers_id, :controller_id
  end
end
