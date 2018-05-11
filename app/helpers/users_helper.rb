module UsersHelper
  def gravatar_for user, options = {size: 250}
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.full_name, class: "gravatar")
  end

  def find_object type_activity, object_id
    if type_activity == "book"
      find_book object_id
    elsif type_activity == "review"
      find_review object_id
      if @review
        find_book @review.book_id
      end
    else
      find_comment object_id
      if @comment
        find_review @comment.review_id
        if @review
          find_book @review.book_id
        end
      end
    end
  end

  private

  def find_book book_id
    @book = Book.find_by id: book_id
  end

  def find_review review_id
    @review = Review.find_by id: review_id
  end

  def find_comment comment_id
    @comment = Comment.find_by id: comment_id
  end
end
