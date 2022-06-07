module NotificationsHelper
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end

  def notification_form(notification)
    @visitor = notification.visitor
    @comment = nil
    @visitor_comment = notification.book_comment_id

    case notification.action
      when "comment" then
        @comment = BookComment.find_by(id: @visitor_comment)&.comment
        tag.a(@visitor.name, href:user_path(@visitor), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:book_path(notification.book_id), style:"font-weight: bold;")+"にコメントしました"
    end
  end
end
