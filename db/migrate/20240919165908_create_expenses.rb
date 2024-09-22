class CreateExpenses < ActiveRecord::Migration[7.2]
  def change
    create_table :expenses do |t|
      t.references :deputy, null: false, foreign_key: true
      t.string :supplier
      t.decimal :liquid_value, precision: 15, scale: 2
      t.date :issue_date
      t.string :invoice_url
      t.string :document_number

      t.timestamps
    end

    add_index :expenses, :document_number, unique: true
  end
end
