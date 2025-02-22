class ChangeDescriptionTypeInStepsAndFlows < ActiveRecord::Migration[6.0]
  def change
    change_column :steps, :description, :text
    change_column :flows, :description, :text
  end
end
