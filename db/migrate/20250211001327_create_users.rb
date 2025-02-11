class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :fullName
      t.integer :cnpj
      t.string :email
      t.string :image
      t.integer :cityId
      t.integer :stateId
      t.string :address
      t.string :password
      t.string :zipcode

      t.timestamps
    end
  end
end
