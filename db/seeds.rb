19.times do |n|
  title= "Tiêu đề sách #{n+1}"
  author= "Tác giả sách #{n+1}"
  publish_date= Time.now+ n.day
  number_of_pages= 200 + n
  image= "haysongothechudong.jpg"
  summary= "Đây là phần nội dung tóm tắt cho sách Đây là phần nội dung tóm tắt cho sách
  Đây là phần nội dung tóm tắt cho sách
  Đây là phần nội dung tóm tắt cho sách
  Đây là phần nội dung tóm tắt cho sách
  Đây là phần nội dung tóm tắt cho sách
  Đây là phần nội dung tóm tắt cho sách #{n+1}"
  Book.create!(title: title, author: author, publish_date: publish_date,
    number_of_pages: number_of_pages, image: image, summary: summary)
end
