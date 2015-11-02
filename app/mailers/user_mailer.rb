class UserMailer < ActionMailer::Base
  default from: "noreply@greatvines.com"
  
  def job_notification_email(job_spec, log_path)

    @job_spec = job_spec
    @log_path = log_path

    mail(to: Settings.birst_soap.session.username, subject: 'ERROR: ' + @job_spec.client.name + ', ' + @job_spec.name)
  end
  
end
