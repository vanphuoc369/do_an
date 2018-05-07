class StaticPagesController < ApplicationController

  def home
    @new_books = Book.top4_newest
    @top_is_favorite_books = Book.top_is_favorite_book
    @top_read_books = Book.top_read_book
  end
end
