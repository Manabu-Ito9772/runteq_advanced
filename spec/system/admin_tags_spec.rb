require 'rails_helper'

RSpec.describe "AdminTags", type: :system do
  let(:user) { create(:user) }
  before { login_as(user) }

  describe 'タグ一覧ページ' do
    it 'タグ一覧ページにパンくずが表示される' do
      click_link 'タグ'
      within('.breadcrumb') do
        expect(page).to have_content('Home'), '「Home」というパンくずが表示されていません'
        expect(page).to have_content('タグ'), '「タグ」というパンくずが表示されていません'
      end
    end

    it 'パンくずの「Home」をクリックするとダッシュボードに遷移' do
      click_link 'タグ'
      within('.breadcrumb') do
        click_link 'Home'
      end
      expect(current_path).to eq(admin_dashboard_path), 'パンくずのHomeを押した時にダッシュボードに遷移していません'
    end
  end

  describe 'タグ編集ページ' do
    let!(:tag) { create(:tag) }

    it 'タグ編集ページにパンくずが表示される' do
      click_link 'タグ'
      click_link '編集'
      within('.breadcrumb') do
        expect(page).to have_content('Home'), '「Home」というパンくずが表示されていません'
        expect(page).to have_content('タグ'), '「タグ」というパンくずが表示されていません'
        expect(page).to have_content('タグ編集'), '「タグ編集」というパンくずが表示されていません'
      end
    end

    it 'パンくずの「Home」をクリックするとダッシュボードに遷移' do
      click_link 'タグ'
      click_link '編集'
      within('.breadcrumb') do
        click_link 'Home'
      end
      expect(current_path).to eq(admin_dashboard_path), 'パンくずのHomeを押した時にダッシュボードに遷移していません'
    end

    it 'パンくずの「タグ」をクリックするとダッシュボードに遷移' do
      click_link 'タグ'
      click_link '編集'
      within('.breadcrumb') do
        click_link 'タグ'
      end
      expect(current_path).to eq(admin_tags_path), 'パンくずの「タグ」を押した時にタグ一覧画面に遷移していません'
    end
  end
end
