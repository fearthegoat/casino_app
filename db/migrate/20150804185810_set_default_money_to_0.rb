class SetDefaultMoneyTo0 < ActiveRecord::Migration
  def change
    remove_column :players, :games_played
    add_column :players, :games_played, :integer, default: 0, null: false
  end
end
