require 'rails_helper'

RSpec.describe "AdminSites", type: :system do
  let(:user) { create(:user) }
  let(:article) { create(:article) }
  before do
    login_as(user)
    click_on '設定'
  end

  describe 'サイト設定ページ' do
    context 'faviconの画像ファイルを選択して保存ボタンを押す' do
      it '選択した画像が表示される' do
        attach_file('site[favicon]', 'public/images/avatar.png')
        click_on '保存'
        expect(page).to have_selector "img[src$='avatar.png']"
      end
    end

    context 'og:imageの画像ファイルを選択して保存ボタンを押す' do
      it '選択した画像が表示される' do
        attach_file('site[og_image]', 'public/images/eye_catch.jpg')
        click_on '保存'
        expect(page).to have_selector "img[src$='eye_catch.jpg']"
      end
    end

    context 'main_imageの画像ファイルを複数選択して保存ボタンを押す' do
      it '選択した画像が全て表示される' do
        attach_file('site[main_images][]', 'public/images/eye_catch.jpg')
        click_on '保存'
        attach_file('site[main_images][]', 'public/images/eye_catch0.jpg')
        click_on '保存'
        attach_file('site[main_images][]', 'public/images/eye_catch1.jpg')
        click_on '保存'
        attach_file('site[main_images][]', 'public/images/eye_catch2.jpg')
        click_on '保存'
        attach_file('site[main_images][]', 'public/images/eye_catch3.jpg')
        click_on '保存'
        expect(page).to have_selector "img[src$='eye_catch.jpg']"
        expect(page).to have_selector "img[src$='eye_catch0.jpg']"
        expect(page).to have_selector "img[src$='eye_catch1.jpg']"
        expect(page).to have_selector "img[src$='eye_catch2.jpg']"
        expect(page).to have_selector "img[src$='eye_catch3.jpg']"
      end
    end

    context 'faviconに画像を選択したのち削除ボタンを押す' do
      it '画像が削除される' do
        attach_file('site[favicon]', 'public/images/avatar.png')
        click_on '保存'
        click_on '削除'
        within('.box-body') do
          expect(page).to_not have_selector "img[src$='avatar.png']"
        end
      end
    end

    context 'og:imageに画像を選択したのち削除ボタンを押す' do
      it '画像が削除される' do
        attach_file('site[og_image]', 'public/images/eye_catch.jpg')
        click_on '保存'
        click_on '削除'
        within('.box-body') do
          expect(page).to_not have_selector "img[src$='eye_catch.jpg']"
        end
      end
    end

    context 'main_imageに複数画像を選択したのち削除ボタンを押す' do
      it '削除ボタンを押した画像のみ削除される' do
        attach_file('site[main_images][]', 'public/images/eye_catch.jpg')
        click_on '保存'
        attach_file('site[main_images][]', 'public/images/eye_catch0.jpg')
        click_on '保存'
        attach_file('site[main_images][]', 'public/images/eye_catch1.jpg')
        click_on '保存'
        attach_file('site[main_images][]', 'public/images/eye_catch2.jpg')
        click_on '保存'
        attach_file('site[main_images][]', 'public/images/eye_catch3.jpg')
        click_on '保存'
        page.all('.main_image')[0].click_on('削除')
        within('.box-body') do
          expect(page).to_not have_selector "img[src$='eye_catch.jpg']"
        end
      end
    end
  end
end
