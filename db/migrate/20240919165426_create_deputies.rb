class CreateDeputies < ActiveRecord::Migration[7.2]
  def change
    create_table :deputies do |t|
      t.string :name, null: false
      t.string :party, null: false
      t.string :state, null: false
      t.string :cpf, null: false

      t.timestamps
    end

    add_index :deputies, :cpf, unique: true
  end
end
