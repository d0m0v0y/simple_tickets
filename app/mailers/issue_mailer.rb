class IssueMailer < ActionMailer::Base
  # default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.issue.new_issue.subject
  #
  def new_issue(issue)
    @issue = issue
    mail from: ENV['ADMIN_EMAIL'], to: issue.reporter_email
  end
end
