class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.integer :money
      t.integer :games_played

      t.timestamps null: false
    end
  end
end
