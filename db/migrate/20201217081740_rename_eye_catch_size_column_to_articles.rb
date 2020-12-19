class RenameEyeCatchSizeColumnToArticles < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :eye_catch_size, :eyecatch_width
    rename_column :articles, :eye_catch_position, :eyecatch_position    
  end
end
