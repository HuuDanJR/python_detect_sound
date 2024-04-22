class MachineReservation < ApplicationRecord
  belongs_to :customer
  belongs_to :gametheme, optional: true

  scope :by_ended_at_from, -> (by_created_at_from) {where("ended_at >= ?", by_ended_at_from)}
  scope :by_ended_at_to, -> (by_ended_at_to) {where("ended_at < ?", by_ended_at_to)}
  scope :by_started_at_from, -> (by_started_at_from) {where("started_at >= ?", by_started_at_from)}
  scope :by_started_at_to, -> (by_started_at_to) {where("started_at < ?", by_started_at_to)}
  scope :by_customer, -> (customer) {where customer_id: customer}
  scope :by_status, -> (status) {where status: status}

  # def self.remind_customer_expires_mc
  #   time_now = Time.zone.now
  #   machine_reservations = MachineReservation.where('ended_at > ?', time_now).order('ended_at asc').limit(50)
  #   machine_reservations.each do |item|
  #     time_noti = ((item[:ended_at].to_time.to_i - time_now.to_i)/60).round
  #     if(time_noti == 30)
  #       user = User.where(id: item[:customer_id]).first
  #       if !user.nil?
  #         notification = Notification.new
  #         notification.user_id = user[:id]
  #         notification.source_id = 1
  #         notification.source_type = "machine_reservations"
  #         notification.notification_type = 3
  #         notification.content = "MC reservations #" + item[:machine_number].to_s + " ends after 30 minutes"
  #         if notification.save
  #           user.send_notification_to_user("E-Vegas", notification.content)
  #         end
  #       end
  #     end
  #   end
    
  # end

end
