class Comment < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user

  validates_presence_of :body

  after_save :change_issue_status

  def author
    if user.present?
      user.username
    else
      issue.reporter_name
    end
  end

  def change_issue_status
    if user.present?
      issue.staff_response!
    else
      issue.customer_response!
    end
  end

end
