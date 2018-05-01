class LoadLikesController < ApplicationController
  def index
    @count_likes = UserBook.count_likes(params[:book_id].to_i).count
    respond_to do |format|
      format.html {redirect_to @count_likes}
      format.js
    end
  end

  def load_likes
    params.permit :book_id
  end
end
