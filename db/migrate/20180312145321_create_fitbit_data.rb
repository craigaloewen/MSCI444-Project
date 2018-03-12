class CreateFitbitData < ActiveRecord::Migration[5.0]
  def change
    create_table :fitbit_data do |t|
      t.integer :number_of_steps
      t.date :input_week_date
      t.boolean :hr_approved
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
