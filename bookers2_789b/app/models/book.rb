class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorite, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorite.exists?(user_id: user.id)
  end

  def self.looks(search,word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "forword_match"
      @book = Book.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.days.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

  scope :created_each_date, -> (date){ where(created_at: date.days.ago.all_day) }
  def self.book_week_count
    (1..6).map { |date| created_each_date(date).count}.reverse
  end

end
