class Room < ApplicationRecord

  has_many :chats, dependent: :destroy
  has_many :user_rooms, dependent: :destroy

  def create_notification_dm!(current_user, room_id, chat_id)
    dm_user = UserRoom.select(:user_id).where(room_id: room_id).where.not(user_id: current_user.id).distinct
    dm_user.each do |dm_user|
      save_notification_dm!(current_user, chat_id, dm_user['user_id'], room_id)
    end

    if dm_user.blank?
      visited_id = UserRoom.where(room_id: room_id).where.not(user_id: current_user.id).distinct.first.user_id
      save_notification_dm!(current_user, chat_id, visited_id, room_id)
    end
  end

  def save_notification_dm!(current_user, chat_id, visited_id, room_id)
    notification = current_user.active_notifications.new(
      room_id: room_id,
      chat_id: chat_id,
      visited_id: visited_id,
      action: 'dm',
      checked: false
      )
      notification.save! if notification.valid?
  end
end
