class CreateFlows < ActiveRecord::Migration[7.1]
  def change
    create_table :flows do |t|
      t.string :name
      t.string :description
      t.bigint :user_id, null: false
      t.foreign_key :users

      t.timestamps
    end
  end
end
