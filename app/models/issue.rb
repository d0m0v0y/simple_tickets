class Issue < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :department
  has_many :comments

  validates :reporter_email, presence: true, email: true
  validates_presence_of :reporter_name, :subject, :description

  scope :unassigned, -> { where user_id: nil }
  scope :opened, -> { where 'status in (?)', %w(waiting_for_staff_response waiting_for_customer on_hold) }
  scope :closed, -> { where 'status in (?)', %w(cancelled completed) }
  scope :filtered, -> (query) { where("id = ? OR subject LIKE ?", query, "%#{query}%")}

  after_create :send_notification

  # set pagination count
  self.per_page = 10

  def department_name
    department.name if department.present?
  end

  def assigned_to
    user.username if user.present?
  end

  aasm column: 'status' do
    state :waiting_for_staff_response, initial: true
    state :waiting_for_customer
    state :on_hold
    state :cancelled
    state :completed

    event :staff_response do
      transitions from: [:waiting_for_staff_response, :waiting_for_customer], to: :waiting_for_customer
    end

    event :customer_response do
      transitions from: [:waiting_for_staff_response, :waiting_for_customer], to: :waiting_for_staff_response
    end

    event :hold do
      transitions from: [:waiting_for_staff_response, :waiting_for_customer], to: :on_hold
    end

    event :unhold do
      transitions from: :on_hold, to: :waiting_for_staff_response
    end

    event :cancel do
      transitions from: [:waiting_for_staff_response, :waiting_for_customer, :on_hold], to: :cancelled
    end

    event :complete do
      transitions from: [:waiting_for_staff_response, :waiting_for_customer, :on_hold], to: :completed
    end

  end

  def can_comment?
    (self.aasm.states(:permissible => true).include? :waiting_for_staff_response) ||
        (self.aasm.states(:permissible => true).include? :waiting_for_customer)
  end

  def possible_actions
    self.aasm.events & [:hold, :unhold, :cancel, :complete]
  end

  def send_notification
    IssueMailer.new_issue(self).deliver
  end

end
