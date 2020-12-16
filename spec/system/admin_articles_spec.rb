require 'rails_helper'

RSpec.describe "AdminArticles", type: :system do
  let(:user) { create(:user) }
  let(:editor) { create(:user, :editor) }
  let(:writer) { create(:user, :writer) }
  let(:draft_article) { create(:article, :draft) }
  let(:future_article) { create(:article, :future) }
  let(:past_article) { create(:article, :past) }
  let(:articles_with_tags) { create_list(:article, 2, :with_tag) }
  let(:articles_with_authors) { create_list(:article, 2, :with_author) }
  let(:article_with_sentence) { create(:article, :with_sentence, sentence_body: 'Sample') }
  let(:article_with_another_sentence) { create(:article, :with_sentence, sentence_body: 'Title') }
  let(:draft_article_with_sentence) { create(:article, :draft, :with_sentence, sentence_body: '基礎編アプリの記事') }
  let(:draft_article_with_another_sentence) { create(:article, :draft, :with_sentence, sentence_body: '応用編アプリの記事')}

  describe '記事一覧画面' do
    before { login_as(user) }
    context 'セレクトボックスでタグを選んで記事を検索' do
      it '該当するタグを持つ記事が全て表示される' do
        articles_with_tags
        visit admin_articles_path
        select 'Tag1', from: 'q[tag_id]'
        click_button '検索'
        expect(page).to have_select('q[tag_id]', selected: 'Tag1')
        expect(find('.box-body')).to have_content('Tag1')
        expect(find('.box-body')).to_not have_content('Tag2')
      end
    end

    context 'セレクトボックスで著者を選んで記事を検索' do
      it '該当する著者を持つ記事が全て表示される' do
        articles_with_authors
        visit admin_articles_path
        select 'Author1', from: 'q[author_id]'
        click_button '検索'
        expect(page).to have_select('q[author_id]', selected: 'Author1')
        expect(find('.box-body')).to have_content('Author1')
        expect(find('.box-body')).to_not have_content('Author2')
      end
    end

    context 'フリーワードで本文を検索' do
      it '本文に検索されたワードを含む記事を全て表示' do
        article_with_sentence
        article_with_another_sentence
        visit admin_articles_path
        fill_in 'q[body]', with: 'Sample'
        click_button '検索'
        expect(find('.box-body')).to have_content(article_with_sentence.title)
        expect(find('.box-body')).to_not have_content(article_with_another_sentence.title)
      end
    end

    it '下書き状態の記事について、本文で絞り込み検索ができること' do
      draft_article_with_sentence
      draft_article_with_another_sentence
      visit admin_articles_path
      fill_in 'q[body]', with: '基礎編アプリ'
      click_button '検索'
      expect(page).to have_content(draft_article_with_sentence.title)
      expect(page).not_to have_content(draft_article_with_another_sentence.title)
    end
  end

  describe '記事編集画面' do
    before { login_as(user) }
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

  describe '権限設定' do
    before { login_as(writer) }
    before { user }
    context 'ライターでログイン' do
      it 'サイドバーにカテゴリー・タグ・著者が表示されない' do
        expect(page).to_not have_content('カテゴリー')
        expect(page).to_not have_content('タグ')
        expect(page).to_not have_content('著者')
      end

      it 'ライター以外のユーザーの編集ができない' do
        click_link 'ユーザー'
        click_link 'admin'
        expect(page).to_not have_content('更新')
      end

      it 'ライター以外のユーザーを削除できない' do
        click_link 'ユーザー'
        expect(page).to_not have_content('削除')
      end

      it '権限エラーが発生した場合403エラーページを返す' do
        visit admin_categories_path
        expect(page).to have_content('権限がありません')
        page.save_screenshot 'screenshot.png'
      end
    end
  end

end
