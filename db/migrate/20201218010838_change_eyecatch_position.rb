class ChangeEyecatchPosition < ActiveRecord::Migration[5.2]
  def change
    change_column :articles, :eyecatch_position, :integer, default: 0
  end
end
