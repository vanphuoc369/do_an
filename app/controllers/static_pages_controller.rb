class StaticPagesController < ApplicationController

  def home
    @new_books = Book.newest
  end
end
