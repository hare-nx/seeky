class Public::ReportsController < ApplicationController
  def create
    if params[:comment_id] == nil
      post=Post.find(params[:post_id])
      report=current_user.reports.new(post_id: post.id, reported_id: post.user_id)
      report.save
      post.update(status: false) if Report.where(reported_id: post.user_id).count>=30
      user=User.find_by(user_id: post.user_id)
      user.update(status: "suspension") if number_of_hidden_data(user)>=10
      redirect_to post_path(post)
    else
      comment=Comment.find(params[:comment_id])
      report=current_user.reports.new(comment_id: comment.id, post_id: nil, reported_id: comment.user_id)
      report.save
      comment.update(status: false) if Report.where(reported_id: post.user_id).count>=30
      user=User.find_by(user_id: comment.user_id)
      user.update(status: "suspension") if number_of_hidden_data(user)>=10
      redirect_to post_path(comment.post)
    end
  end

  def destroy
    if params[:comment_id] == nil
      post=Post.find(params[:post_id])
      report=current_user.reports.find_by(post_id: post.id)
      report.destroy
      redirect_to post_path(post)
    else
      comment=Comment.find(params[:comment_id])
      report=current_user.reports.find_by(comment_id: comment.id)
      report.destroy
      redirect_to post_path(comment.post)
    end
  end
end
