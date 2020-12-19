require 'rails_helper'

RSpec.describe "AdminEyecatches", type: :system do
  let(:user) { create(:user) }
  let!(:article) { create(:article) }
  before { login_as(user) }

  describe '記事編集画面でアイキャッチを選択' do
    before do
      visit edit_admin_article_path(article.uuid)
      attach_file('article[eye_catch]', 'public/images/eye_catch.jpg')
    end

    context 'アイキャッチ幅を200にしてプレビューを閲覧' do
      it '幅200pxのアイキャッチが表示される' do
        fill_in 'article[eyecatch_width]', with: '200'
        click_button '更新'
        click_link 'プレビュー'
        switch_to_window(windows.last)
      end
    end

    context 'アイキャッチ幅を100未満にして更新を押す' do
      it '「100以上の値にしてください」というバリデーションエラーが表示される' do
        fill_in 'article[eyecatch_width]', with: '1'
        click_button '更新'
        expect(page).to have_content('100以上の値にしてください')
      end
    end

    context 'アイキャッチ幅を700より上の値にして更新を押す' do
      it '「700以下の値にしてください」というバリデーションエラーが表示される' do
        fill_in 'article[eyecatch_width]', with: '1000'
        click_button '更新'
        expect(page).to have_content('700以下の値にしてください')
      end
    end

    context '左寄せを選択してプレビューを閲覧' do
      it '左側にアイキャッチが表示される' do
        choose('左寄せ')
        click_button '更新'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        within('.eye_catch') do
          expect(page).to_not have_css '.mx-auto'
          expect(page).to_not have_css '.ml-auto'
        end
      end
    end

    context '中央揃えを選択してプレビューを閲覧' do
      it '中央にアイキャッチが表示される' do
        choose('中央揃え')
        click_button '更新'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        within('.eye_catch') do
          expect(page).to have_css '.mx-auto'
        end
      end
    end

    context '右寄せを選択してプレビューを閲覧' do
      it '右側にアイキャッチが表示される' do
        choose('右寄せ')
        click_button '更新'
        click_link 'プレビュー'
        switch_to_window(windows.last)
        within('.eye_catch') do
          expect(page).to have_css '.ml-auto'
        end
      end
    end
  end
end
