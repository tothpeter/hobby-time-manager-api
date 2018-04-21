class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :description
      t.date :date, index: true
      t.integer :duration

      t.timestamps
    end
  end
end
