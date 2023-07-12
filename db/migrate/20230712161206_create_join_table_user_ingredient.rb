class CreateJoinTableUserIngredient < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :ingredients do |t|
      t.index [:user_id, :ingredient_id]
      t.index [:ingredient_id, :user_id]
    end
  end
end
