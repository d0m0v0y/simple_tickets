class Comment < ActiveRecord::Base
  belongs_to :issue
  belongs_to :user

  validates_presence_of :body

  def author
    if user.present?
      user.username
    else
      issue.reporter_name
    end
  end
end
