class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.references :flow, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true

      t.timestamps
    end
  end
end
