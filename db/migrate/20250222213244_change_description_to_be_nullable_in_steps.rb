class ChangeDescriptionToBeNullableInSteps < ActiveRecord::Migration[6.1]
  def change
    change_column_null :steps, :description, true
  end
end
