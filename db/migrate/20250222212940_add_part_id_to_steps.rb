class AddPartIdToSteps < ActiveRecord::Migration[6.1]
  def change
    add_column :steps, :part_id, :bigint
    add_foreign_key :steps, :parts, column: :part_id
  end
end
