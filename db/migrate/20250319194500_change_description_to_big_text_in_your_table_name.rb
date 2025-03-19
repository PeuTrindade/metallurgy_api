class ChangeDescriptionToBigTextInYourTableName < ActiveRecord::Migration[6.0]  # ou a versão do seu Rails
  def change
    change_column :inspections, :description, :text
  end
end
