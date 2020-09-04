class Connection < ApplicationRecord
  belongs_to :responder, class_name: 'User'
  belongs_to :post

  def connection_card(author, current_user)
    x = author == current_user
    "<span class='badge badge-pill badge-secondary shadow-sm mt-n1 mx-auto'>
      #{x ? responder.name : 'You'} responded to #{x ? 'your' : post.author.name + '\'s '} #{post.post_type.downcase}
     </span>
     <div class='ml-4 flip-reverse'>#{x ? post.header(150, responder) : post.header(150)}</div>
     <div class='pl-4 pb-4 col-12'>
       <strong>#{x ? responder.name.split(' ')[0] : 'You'} wrote:</strong> #{message}<br>
       <strong>Address:</strong> #{x ? responder.address : post.author.address} <br>
       <strong>Phone:</strong> #{x ? responder.phone : post.author.phone} <br>
       <strong>Email:</strong> #{x ? responder.email : post.author.email}
       <button class='btn btn-success float-right' id='openButton' onclick='openForm(\"#{[responder.id, post.author.id].sort.join('-')}\")'>Chat</button>
     </div>"
  end
end
