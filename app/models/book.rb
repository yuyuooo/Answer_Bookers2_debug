class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.looks(method, content)
    if method == "perfect_match"
      @book = Book.where("title LIKE?", "#{content}")
    elsif method == "forward_match"
      @book = Book.where("title LIKE?", "#{content}%")
    elsif method == "backward_match"
      @book = Book.where("title LIKE?", "%#{content}")
    elsif method == "partial_match"
      @book = Book.where("title LIKE?","%#{content}%")
    end
  end
end
