require 'rails_helper'

RSpec.describe "AdminArticlesPreviews", type: :system do
  let(:user) { create(:user) }
  let!(:article) { create(:article) }

  describe '記事編集画面で画像ブロックを追加' do
    context '画像を添付せずにプレビューを閲覧' do
      it '正常にプレビューが表示される' do
        login_as(user)
        click_link '記事'
        click_link '編集'
        click_link 'ブロックを追加する'
        click_link '画像'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_content(article.title), 'プレビューページが正しく表示されていません'
      end
    end
  end

  describe '記事編集画面で文章ブロックを追加' do
    context '文章を記入せずにプレビューを閲覧' do
      it '正常にプレビューが表示される' do
        login_as(user)
        click_link '記事'
        click_link '編集'
        click_link 'ブロックを追加する'
        click_link '文章'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        expect(page).to have_title(article.title), 'プレビューページが正しく表示されていません'
      end
    end
  end
end
