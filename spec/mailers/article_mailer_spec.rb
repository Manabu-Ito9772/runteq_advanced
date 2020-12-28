require "rails_helper"

RSpec.describe ArticleMailer, type: :mailer do
  describe "report_summary" do
    let(:mail) { ArticleMailer.report_summary }
    let(:articles) { create_list(:article, 3) }
    let(:articles_published_yesterday) { create_list(:article, 3, :published_yesterday) }

    it "renders the headers" do
      expect(mail.subject).to eq('公開済記事の集計結果')
      expect(mail.to).to eq(['admin@example.com'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it '公開済の記事数が表示される' do
      articles
      expect(mail.body).to match('公開済の記事数: 3件')
    end

    context '昨日公開された記事がある' do
      it '昨日公開された記事数と各記事のタイトルが表示される' do
        expect(mail.body.encoded).to match("Hi")
      end
    end

    context '昨日公開された記事がない' do
      it '「昨日公開された記事はありません」と表示される' do
        expect(mail.body.encoded).to match("Hi")
      end
    end
  end

end
