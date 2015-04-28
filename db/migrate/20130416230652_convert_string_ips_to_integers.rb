class ConvertStringIpsToIntegers < ActiveRecord::Migration

  def up
    #current_sign_in_ip
    add_column :users, :current_sign_in_ip_temp, :integer
    execute <<-SQL
      update users set current_sign_in_ip_temp = current_sign_in_ip
    SQL
    remove_column :users, :current_sign_in_ip
    rename_column :users, :current_sign_in_ip_temp, :current_sign_in_ip
    #last_sign_in

    add_column :users, :last_sign_in_ip_temp, :integer
    execute <<-SQL
      update users set last_sign_in_ip_temp = last_sign_in_ip
    SQL
    remove_column :users, :last_sign_in_ip
    rename_column :users, :last_sign_in_ip_temp, :last_sign_in_ip
  end

  def down
    #current_sign_in_ip
    add_column :users, :current_sign_in_ip_temp, :string
    execute <<-SQL
      update users set current_sign_in_ip_temp = current_sign_in_ip
    SQL
    remove_column :users, :current_sign_in_ip
    rename_column :users, :current_sign_in_ip_temp, :current_sign_in_ip
    #last_sign_in
    add_column :users, :last_sign_in_ip_temp, :string
    execute <<-SQL
      update users set last_sign_in_ip_temp = last_sign_in_ip
    SQL
    remove_column :users, :last_sign_in_ip
    rename_column :users, :last_sign_in_ip_temp, :last_sign_in_ip
  end
end
