require 'rails_helper'

RSpec.describe "AdminArticles", type: :system do
  let(:user) { create(:user) }
  let(:draft_article) { create(:article, :draft) }
  let(:future_article) { create(:article, :future) }
  let(:past_article) { create(:article, :past) }
  before { login_as(user) }

  describe '記事一覧画面' do
    let!(:article_with_tags) { create_list(:article, 3, :with_tags) }
    context 'セレクトボックスでタグを選んで記事を検索' do
      it '該当するタグを持つ記事が全て表示される' do
        visit admin_articles_path
        select 'Tag1', from: 'q[tag_id]'
        click_button '検索'
        expect(page).to have_select('q[tag_id]', selected: 'Tag1')
        expect(find('.box-body')).to have_content('Tag1')
        expect(find('.box-body')).to_not have_content('Tag2')
        expect(find('.box-body')).to_not have_content('Tag3')
      end
    end

    context 'セレクトボックスで著者を選んで記事を検索' do
      it '該当する著者を持つ記事が全て表示される' do
        visit admin_articles_path
        select 'Author7', from: 'q[author_id]'
        click_button '検索'
        expect(page).to have_select('q[author_id]', selected: 'Author7')
        expect(find('.box-body')).to have_content('Author7')
        expect(find('.box-body')).to_not have_content('Author8')
        expect(find('.box-body')).to_not have_content('Author9')
      end
    end

    context 'フリーワードで本文を検索' do
      it '本文に検索されたワードを含む記事を全て表示' do
        create(:article, body: 'Sample')
        visit admin_articles_path
        fill_in 'q[body]', with: 'Sample'
        click_button '検索'
        expect(find('.box-body')).to have_content('Title13')
        expect(find('.box-body')).to_not have_content('Title10')
        expect(find('.box-body')).to_not have_content('Title11')
        expect(find('.box-body')).to_not have_content('Title12')
      end
    end
  end

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
        visit edit_admin_article_path(draft_article.uuid)
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
