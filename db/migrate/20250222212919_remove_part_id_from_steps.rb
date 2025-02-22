class RemovePartIdFromSteps < ActiveRecord::Migration[6.1]
  def change
    remove_column :steps, :part_id, :integer
  end
end
