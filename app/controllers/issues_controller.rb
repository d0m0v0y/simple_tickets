class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :update]
  before_filter :authenticate_user!, only: [:index]

  has_scope :unassigned, :type => :boolean
  has_scope :opened, :type => :boolean
  has_scope :on_hold, :type => :boolean
  has_scope :closed, :type => :boolean
  has_scope :filtered

  def index
    # where('1=1') used instead of .all to avoid rails 4 deprecation warning
    # see https://github.com/plataformatec/has_scope/issues/41
    @issues = apply_scopes(Issue).paginate(:page => params[:page])
  end

  def show
    @comment = Comment.new
    @comment.user = current_user if user_signed_in?
    @comment.issue = @issue
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new(issue_params)

    if @issue.save
      redirect_to @issue, notice: 'Issue was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @issue.update(issue_params)
      redirect_to @issue, notice: 'Issue was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def fire
    @issue = Issue.find(params[:issue_id])
    if @issue.aasm.events.include? params[:event].to_sym
      @issue.send("#{params[:event]}!") rescue nil
    end
    redirect_to @issue
  end

  private

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:reporter_name, :reporter_email, :department_id,
                  :subject, :description, :user_id )
  end

end
