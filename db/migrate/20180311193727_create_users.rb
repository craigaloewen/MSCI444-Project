class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.boolean :admin
      t.string :password_digest
      t.string :name
      t.references :department, foreign_key: true

      t.timestamps
    end
  end
end
