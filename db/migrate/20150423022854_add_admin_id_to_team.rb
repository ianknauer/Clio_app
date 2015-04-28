class AddAdminIdToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :admin_id, :int
  end
end
