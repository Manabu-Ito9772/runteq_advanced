require 'rails_helper'

RSpec.describe "AdminArticles", type: :system do
  let(:user) { create(:user) }
  let(:article) { create(:article) }
  let(:future_article) { create(:article, :future) }
  let(:past_article) { create(:article, :past) }
  before { login_as(user) }

  describe '記事編集画面' do
    context 'ステータスが「下書き状態以外」かつ、公開日時を「未来の日付」に設定して「更新する」を押す' do
      it 'ステータスを「公開待ち」に変更して「更新しました」とフラッシュメッセージを表示' do
        visit edit_admin_article_path(future_article.uuid)
        click_button '更新する'
        expect(page).to have_select('状態', selected: '公開待ち')
        expect(page).to have_content('更新しました')
      end

      context 'ステータスが「下書き状態以外」かつ、公開日時が「現在または過去の日付」に設定して「更新する」を押す' do
        it 'ステータスを「公開」に変更して「更新しました」とフラッシュメッセージを表示' do
          visit edit_admin_article_path(past_article.uuid)
          click_button '更新する'
          expect(page).to have_select('状態', selected: '公開')
          expect(page).to have_content('更新しました')
        end
      end
    end

    context 'ステータスが「下書き状態」で「更新する」を押す' do
      it 'ステータスは「下書き」のまま「更新しました」とフラッシュメッセージを表示' do
        visit edit_admin_article_path(article.uuid)
        click_button '更新する'
        expect(page).to have_content('下書き')
        expect(page).to have_content('更新しました')
      end
    end

    context '公開日時を未来の日付にして「公開する」を押す' do
      it 'ステータスを「公開待ち」に変更して「記事を公開待ちにしました」とフラッシュメッセージを表示' do
        visit edit_admin_article_path(future_article.uuid)
        click_link '公開する'
        expect(page).to have_select('状態', selected: '公開待ち')
        expect(page).to have_content('記事を公開待ちにしました')
      end
    end

    context '公開日時を過去の日付にして「公開する」を押す' do
      it 'ステータスを「公開」に変更して「記事を公開しました」とフラッシュメッセージを表示' do
        visit edit_admin_article_path(past_article.uuid)
        click_link '公開する'
        expect(page).to have_select('状態', selected: '公開')
        expect(page).to have_content('記事を公開しました')
      end
    end

  end

end
