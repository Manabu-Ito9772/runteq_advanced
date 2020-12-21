require 'rails_helper'

RSpec.describe "AdminArticlesEmbeds", type: :system do
  let(:user) { create(:user) }
  let(:article) { create(:article) }

  describe '記事編集ページで埋め込みブロックを追加する' do
    before do
      login_as(user)
      visit edit_admin_article_path(article.uuid)
      click_link 'ブロックを追加する'
      click_link '埋め込み'
    end

    context '埋め込みタイプでyoutubeを選んでurlを添付して更新するを押す' do
      it '埋め込みブロックにyoutubeが表示され、プレビューにも反映される' do
        click_link '編集'
        select 'YouTube', from: 'embed[embed_type]'
        fill_in 'embed[identifier]', with: 'https://youtu.be/yH-LI--Q-TY'
        within '.js-update-article-block' do
          click_button '更新する'
        end
        page.save_screenshot 'screenshot.png'
      end
    end

    context '埋め込みタイプでtwitterを選んでurlを添付して更新するを押す' do
      fit '埋め込みブロックにツイートが表示され、プレビューにも反映される' do
        click_link '編集'
        select 'Twitter', from: 'embed[embed_type]'
        fill_in 'embed[identifier]', with: 'https://twitter.com/otI_ubanaM/status/1049248760918724608'
        within '.js-update-article-block' do
          click_button '更新する'
        end
        page.save_screenshot 'screenshot.png'
      end
    end
  end
end
