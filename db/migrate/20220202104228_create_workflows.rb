class CreateWorkflows < ActiveRecord::Migration[7.0]
  def change
    create_table :workflows do |t|
      t.string :name, null: false
      t.text :steps, null: false

      t.timestamps
    end
  end
end
