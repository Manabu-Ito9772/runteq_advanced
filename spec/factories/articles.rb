# == Schema Information
#
# Table name: articles
#
#  id           :bigint           not null, primary key
#  category_id  :bigint
#  author_id    :bigint
#  uuid         :string(255)
#  slug         :string(255)
#  title        :string(255)
#  description  :text(65535)
#  body         :text(65535)
#  state        :integer          default("draft"), not null
#  published_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  deleted_at   :datetime
#
# Indexes
#
#  index_articles_on_author_id     (author_id)
#  index_articles_on_category_id   (category_id)
#  index_articles_on_deleted_at    (deleted_at)
#  index_articles_on_published_at  (published_at)
#  index_articles_on_slug          (slug)
#  index_articles_on_uuid          (uuid)
#

FactoryBot.define do
  factory :article do
    sequence(:id) { |n| "#{n}" }
    uuid  { SecureRandom.uuid }
    sequence(:slug) { |n| "TestSlug#{n}" }
    sequence(:title) { |n| "Title#{n}" }
    category

    trait :with_tag do
      after(:create) do |article|
        create(:tag, articles: [article])
      end
    end

    trait :with_author do
      association :author
    end

    trait :draft do
      state { 'draft' }
    end

    trait :future do
      state { 'published' }
      published_at { DateTime.now.since(1.hours) }
    end

    trait :past do
      state { 'publish_wait' }
      published_at { DateTime.now.ago(1.hours) }
    end

    trait :with_sentence do
      transient do
        sequence(:sentence_body) { |n| "test_body_#{n}" }
      end

      after(:build) do |article, evaluator|
        article.sentences << create(:sentence, body: evaluator.sentence_body)
      end
    end

    trait :article_publish_wait_tomorrow do
      state { :publish_wait }
      published_at { Time.current.tomorrow }
      category
    end

    trait :article_published_yesterday do
      state { :published }
      published_at { Time.current.yesterday }
      category
    end

    trait :article_published_two_days_ago do
      state { :published }
      published_at { Time.current.ago(2.days) }
      category
    end
  end
end
