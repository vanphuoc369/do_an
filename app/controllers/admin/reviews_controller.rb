module Admin
  class ReviewsController < ApplicationController
    before_action :find_review, only: [:show, :destroy]
    def index
      @reviews = Review.all
      respond_to do |format|
        format.html
        format.js
      end
    end

    def show
      respond_to do |format|
        format.html
        format.js
      end
    end

    def destroy
      if @review.destroy
        flash.now[:success] = "Xóa bài đánh giá thành công"
      else
        flash.now[:danger] = "Xóa bài đánh giá không thành công"
      end
      @reviews = Review.all
      respond_to do |format|
        format.html
        format.js
      end
    end

    private

    def find_review
      @review = Review.find_by id: params[:id]
    end
  end
end
