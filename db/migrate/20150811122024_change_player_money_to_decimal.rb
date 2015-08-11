class ChangePlayerMoneyToDecimal < ActiveRecord::Migration
  def change
    change_column :players, :money, :decimal, :precision => 12, :scale => 2
  end
end
