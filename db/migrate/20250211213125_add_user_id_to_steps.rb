class AddUserIdToSteps < ActiveRecord::Migration[7.1]
  def change
    add_column :steps, :user_id, :bigint, null: false  # Adiciona a coluna user_id como bigint e obrigatória
    add_foreign_key :steps, :users, column: :user_id  # Define a chave estrangeira
    add_index :steps, :user_id  # Cria um índice para a coluna user_id
  end
end
