class ArticleMailer < ApplicationMailer
  def report_summary
    @published_articles = Article.all.published.count
    @published_yesterday_articles = Article.published_yesterday
    mail to: 'admin@example.com', subject: '公開済記事の集計結果'
  end
end
