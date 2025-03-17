class CreateInspection < ActiveRecord::Migration[7.1]
  def change
    create_table :inspections do |t|
      t.string :image, null: true
      t.string :description, null: false
      t.references :user, null: false, foreign_key: true
      t.references :flow, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true

      t.timestamps
    end
  end
end
