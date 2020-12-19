class ChangeDataEyecatchWidthToArticle < ActiveRecord::Migration[5.2]
  def change
    change_column :articles, :eyecatch_width, :string
  end
end
