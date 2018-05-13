module Admin
  class ReviewsController < ApplicationController
    before_action :find_review, only: [:show, :destroy]
    def index
      @reviews = Review.paginate page: params[:page], per_page: 1
    end

    def show
    end

    def destroy
      if @review.destroy
        flash[:success] = "Xoa thanh cong"
      else
        flash[:danger] = "Xoa khong thanh cong"
      end
      redirect_to admin_reviews_path
    end

    private

    def find_review
      @review = Review.find_by id: params[:id]
    end
  end
end
