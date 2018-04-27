class StaticPagesController < ApplicationController

  def home
    flash[:info] = "Load trang home thanh cong!"
  end
end
