class SystemMailer < ApplicationMailer
  include CommonModule

  def send_email(email_to, email_subject, email_body)
    mail_smtp_address = Setting.where('setting_key = ?', 'MAIL_SMTP_ADDRESS').first!
    mail_smtp_port = Setting.where('setting_key = ?', 'MAIL_SMTP_PORT').first!
    mail_smtp_domain = Setting.where('setting_key = ?', 'MAIL_SMTP_DOMAIN').first!
    mail_smtp_user_name = Setting.where('setting_key = ?', 'MAIL_SMTP_USER_NAME').first!
    mail_smtp_password = Setting.where('setting_key = ?', 'MAIL_SMTP_PASSWORD').first!
    mail_smtp_authentication = Setting.where('setting_key = ?', 'MAIL_SMTP_AUTHENTICATION').first!

    if (!is_blank(mail_smtp_address))
      delivery_options = get_delivery_options(mail_smtp_address.setting_value, mail_smtp_port.setting_value, mail_smtp_domain.setting_value, mail_smtp_user_name.setting_value, mail_smtp_password.setting_value, mail_smtp_authentication.setting_value, true)
      mail(from: mail_smtp_user_name.setting_value,
           to: email_to,
           body: email_body,
           content_type: 'text/html',
           subject: email_subject,
           delivery_method_options: delivery_options)
    else
      mail(to: email_to,
           body: email_body,
           content_type: 'text/html',
           subject: email_subject)
    end
  end

  def send_email_testing(smtp_server, port, domain, user_name, password, authentication, email_to, email_subject, email_body)
    delivery_options = get_delivery_options(smtp_server, port, domain, user_name, password, authentication, true)
    mail(from: user_name,
         to: email_to,
         body: email_body,
         content_type: 'text/html',
         subject: email_subject,
         delivery_method_options: delivery_options)
  end
end
