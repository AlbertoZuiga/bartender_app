class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :name, null: false, default: ""
      t.string :description
      t.string :instruction

      t.timestamps
    end
  end
end
