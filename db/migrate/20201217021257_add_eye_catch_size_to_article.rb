class AddEyeCatchSizeToArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :eye_catch_size, :string
    add_column :articles, :eye_catch_position, :integer, default: 0
  end
end
