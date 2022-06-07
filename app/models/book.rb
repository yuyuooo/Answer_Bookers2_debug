class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy

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
  
  def create_notification_comment!(current_user, book_comment_id)
    comment_users = BookComment.select(:user_id).where(book_id: id).where.not(user_id: current_user.id).distinct
    comment_users.each do |comment_user|
      save_notification_comment!(current_user, book_comment_id, comment_user['user_id']) if comment_users.blank?
    end
      save_notification_comment!(current_user, book_comment_id, user_id) if comment_users.blank?
  end
  
  def save_notification_comment!(current_user, book_comment_id, visited_id)
    notification = current_user.active_notifications.new(
      book_id: id,
      book_comment_id: book_comment_id,
      visited_id: visited_id,
      action: 'comment',
      checked: false
    )
    notification.save! if notification.valid?
  end
      
end
