class FieldsNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :fullName, :string, null: false
    change_column :users, :email, :string, null: false
    change_column :users, :password, :string, null: false
    change_column :users, :cnpj, :bigint, null: false
  end
end
