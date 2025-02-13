class AddFlowToPartsAndSteps < ActiveRecord::Migration[7.0]
  def change
    add_column :parts, :flow_id, :bigint, null: false
    add_foreign_key :parts, :flows

    add_column :steps, :flow_id, :bigint, null: false
    add_foreign_key :steps, :flows
  end
end
