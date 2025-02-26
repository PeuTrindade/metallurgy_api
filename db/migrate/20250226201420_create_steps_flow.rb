class CreateStepsFlow < ActiveRecord::Migration[6.1]
  def change
    create_table :steps_flows do |t|
      t.string :name, null: false
      t.text :description
      t.bigint :user_id, null: false
      t.bigint :flow_id, null: false

      t.timestamps
    end

    add_foreign_key :steps_flows, :users, column: :user_id
    add_foreign_key :steps_flows, :flows, column: :flow_id
    add_index :steps_flows, :user_id
    add_index :steps_flows, :flow_id
  end
end
