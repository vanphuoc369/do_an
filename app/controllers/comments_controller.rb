class CommentsController < ApplicationController

  before_action :find_review
  before_action :find_book, except: [:new, :edit]
  before_action :find_comment, only: %i(destroy edit update)
  before_action -> {check_login_or_save_url(book_review_path params[:book_id], params[:review_id])}

  def new; end

  def create
    @comment = current_user.comments.build comment_params
    if @comment.content.empty?
      flash.now[:warning] = "Hãy viết suy nghĩ của bạn vào phần nội dung bình luận."
    elsif @review.comments << @comment
      @activity = Activity.create(user_id: current_user.id, type_activity: "comment",
        content: "Bạn đã bình luận về bài đánh giá sách", object_id: @comment.id)
      flash.now[:success] = "Đăng bình luận thành công!"
    else
      flash.now[:danger] = "Đăng bình luận thất bại."
    end
    if params[:comment][:id_comment_reply].nil?
      find_comments params[:review_id]
      if @comments
        @report_users = @comments.select(:user_id).distinct
        @report_users.each do |report_user|
          if report_user.user_id && (report_user.user_id != current_user.id)
            user_report = User.find_by id: report_user.user_id
            if report_user.user_id != @review.user_id
              Notification.create(user_id: user_report.id, activity_id: @activity.id,
                content: current_user.full_name + " đã bình luận về bài đánh giá bạn có tham gia trao đổi.")
            end
          end
        end
      end
      user_review = User.find_by id: @review.user_id
      if user_review && (user_review.id != current_user.id)
        Notification.create(user_id: user_review.id, activity_id: @activity.id,
          content: current_user.full_name + " đã thêm một bình luận mới về bài đánh giá của bạn.")
      end
    else
      @id_comment_reply = params[:comment][:id_comment_reply]
      replied_user_id = (Comment.find_by id: @id_comment_reply).user_id
      find_reply_comments params[:review_id], params[:comment][:id_comment_reply]
      if @comments
        @report_users = @comments.select(:user_id).distinct
        @report_users.each do |report_user|
          if report_user.user_id && (report_user.user_id != current_user.id)
            user_report = User.find_by id: report_user.user_id
            if report_user.user_id != replied_user_id
              Notification.create(user_id: user_report.id, activity_id: @activity.id,
                content: current_user.full_name + " đã bình luận về phản hồi của bạn.")
            end
          end
        end
      end
      if replied_user_id && (replied_user_id != current_user.id)
        Notification.create(user_id: replied_user_id, activity_id: @activity.id,
          content: current_user.full_name + " đã phản hồi bình luận của bạn.")
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @comment_id = params[:id]
    @comments = Comment.list_reply_cmt(params[:review_id], params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    if params[:commit] != 'Hủy bỏ'
      if @comment.update comment_params
        Activity.create(user_id: current_user.id, type_activity: "comment",
          content: "Bạn đã chỉnh sửa bình luận về bài đánh giá sách", object_id: @comment.id)
        flash.now[:success] = "Chỉnh sửa bình luận thành công!"
      else
        flash.now[:danger] = "Chỉnh sửa bình luận thất bại, vui lòng kiểm tra lại!"
      end
    end
    if params[:comment][:id_comment_reply].nil?
      find_comments params[:review_id]
    else
      @id_comment_reply = params[:comment][:id_comment_reply]
      find_reply_comments params[:review_id], params[:comment][:id_comment_reply]
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @book = Book.find_by id: params[:book_id]
    if @comment
      @id_comment_reply = @comment.id_comment_reply
      respond_to do |format|
        format.html {redirect_to @book, @review, @comment}
        format.js
      end
    else
      flash[:danger] = "Bình luận không được tìm thấy."
      redirect_to book_path(params[:book_id])
    end
  end

  def destroy
    @id_reply_comment = @comment.id_comment_reply
    if @comment.destroy
      flash.now[:success] = "Xóa bình luận thành công!"
    else
      flash.now[:danger] = "Xóa bình luận thất bại!"
    end
    if @id_reply_comment.nil?
      find_comments params[:review_id]
    else
      @id_comment_reply = @id_reply_comment
      find_reply_comments params[:review_id], @id_reply_comment
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit :review_id, :content, :id_comment_reply
  end

  def find_review
    @review = Review.find_by id: params[:review_id]
    if @review.nil?
      flash[:danger] = "Không tìm thấy bài đánh giá."
      redirect_to book_path(params[:book_id])
    end
  end

  def find_comment
    @comment = Comment.find_by id: params[:id]
    redirect_to root_url if @comment.nil?
  end

  def find_comments review_id
    find_review
    @comments = Comment.list_cmt(review_id)
    return @notify_comment_empty = "Chưa có bình luận cho bài đánh giá." if @comments.empty?
  end

  def find_reply_comments review_id, cmt_id
    find_review
    @comments = Comment.list_reply_cmt(review_id, cmt_id)
    return @notify_comment_empty = "Chưa có bình luận cho bài đánh giá." if @comments.empty?
  end

  def find_book
    @book = Book.find_by id: params[:book_id]
  end
end
