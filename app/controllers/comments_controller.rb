class CommentsController < ApplicationController
  before_action :set_issue

  def create
    @comment = Comment.new comment_params
    @comment.user = current_user if user_signed_in?

    if @comment.save
      redirect_to @issue, notice: 'Comment was successfully added.'
    else
      redirect_to @issue, warn: 'Error has been occurred on adding comment.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:issue_id, :user_id, :body)
  end

  def set_issue
    @issue = Issue.find(params[:comment][:issue_id])
  end
end
