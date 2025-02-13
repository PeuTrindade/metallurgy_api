class Parts < ActiveRecord::Migration[7.1]
  def change
    create_table :parts do |t|
      t.string :name
      t.string :tag
      t.string :hiringCompany
      t.string :image
      t.bigint :user_id, null: false
      t.foreign_key :users 

      t.timestamps
    end
  end
end