require 'json'
require 'open-uri'

puts "destroying all connections"
Connection.destroy_all
puts "destroying all user"
User.destroy_all
puts "destroying all POSTS"
Post.destroy_all
puts "destroying all CATS"
Category.destroy_all

puts "generating categories..."
categories = ['tools', 'tech help', 'medicine', 'ppe', 'hygienics',
              'food', 'transportation', 'errands', 'deliveries', 'clothing',
              'finances', 'educational', 'shelter', 'cleaning',
              'household', 'conversation']
categories.each { |cat| Category.create!(name: cat) }
puts "categories created!"

# 20 addresses
MTL_ADDRESSES = ['1701 rue Parthenais, Montréal, QC',
                '750 rue Willibrord, Montréal, QC',
                '1000 de La Gauchetiere Street West, Montréal, QC',
                '2113 Rue Saint-Louis, Saint-Laurent, QC',
                '900 Place Jean-Paul-Riopelle, Montréal, QC',
                '5134 St Laurent Blvd, Montreal, Quebec',
                '468 Rue McGill, Montréal, QC',
                '805 Rue Tassé, Saint-Laurent, QC',
                '403 Rue des Seigneurs, Montréal, QC',
                '7503 Rue St Denis, Montreal QC',
                '251 Av Percival Montreal Ouest QC',
                '3708 Rue St Hubert, Montreal QC',
                '800 Rue Gagne Lasalle QC',
                '5545 Rue Vanden Abeele, Saint-Laurent, QC',
                '6730 44 Av, Montreal QC',
                '1940 Jolicoeur Street, Montreal QC',
                '5240 Randall Av, Montreal QC',
                '3555 Edouard-Montpetit, Montreal QC',
                '12225 Av de Saint-Castin, Montreal QC',
                '391 Rue de la Congrégation, Montreal QC']

# 20 phone numbers
MTL_PHONES = ['(514) 376-8344', '(514) 279-7016', '(514) 482-1925', '(514) 366-7190',
              '(514) 680-4011', '(514) 593-0995', '(514) 282-9395', '(514) 769-5499',
              '(514) 488-4685', '(514) 767-3902', '(438) 380-0604', '(514) 253-8475',
              '(514) 729-1844', '(514) 761-3242', '(514) 485-2431', '(514) 507-2550',
              '(514) 342-8215', '(514) 257-9112', '(438) 380-3437', '(514) 935-1002']

# GENERATE COMRADES
puts "generating comrades..."
deb = User.create!(name: 'Deb Anjos',
       img_url: 'https://kitt.lewagon.com/placeholder/users/deb-anjos',
       email: 'deb@email.com',
       address: "5333 Ave Casgrain, Montreal, QC",
       password: 'password',
       phone: '(514) 438-2917')
ryan = User.create!(name: 'Ryan Buckley',
       img_url: 'https://kitt.lewagon.com/placeholder/users/ryanbuckleyca',
       email: 'ryanbuckley@gmail.com',
       address: "4107 Rue St. Laurent, Montreal QC",
       password: 'password',
       phone: '(438) 403-6403')
arthur = User.create!(name: 'Arthur Prats',
       img_url: 'https://kitt.lewagon.com/placeholder/users/arthurprats',
       email: 'arthur@email.com',
       address: "1200 Rue Atateken, Montreal QC",
       password: 'password',
       phone: '(438) 403-1532')
nirali = User.create!(name: 'Nirali Patel',
       img_url: 'https://kitt.lewagon.com/placeholder/users/mynameisnirali',
       email: 'nirali@email.com',
       address: "468 McGill St, Montreal, Qc",
       password: 'password',
       phone: '(438) 403-5221')
puts "comrades created!"

# CREATE RANDO USERS WITH 1-3 POSTS EACH
puts "generating 20 random users with 1-3 posts each..."
url = 'https://randomuser.me/api/?results=20'
user_serialized = open(url).read
randos = JSON.parse(user_serialized)

randos["results"].each_with_index do |rando, i|

  avatar = rando["picture"]["large"]
  first_name = rando["name"]["first"]
  last_name = rando["name"]["last"]
  email = rando["email"]

  user = User.new(name: "#{first_name} #{last_name}",
                  email: email,
                  address: MTL_ADDRESSES[i],
                  password: 'password',
                  phone: MTL_PHONES[i],
                  img_url: avatar)
  user.save!

  type = rand > 0.5 ? "Request" : "Offer"
  request_title = ["I need", "Could use some", "Looking for", "In need of", "Who's got",
                   "I need someone with", "SVP", "I want help with", "Please help with",
                   "Looking for someone with", "Hoping for", "Trying to find", "Wishing for",
                   "Searching for", "I want", "I would like a hand with"]
  offer_title = ["Wanting to provide", "Giving away", "Offering help with", "I'm offering",
                 "I can help with", "I can provide", "Here for", "I can give you",
                 "Providing", "I want to supply", "Lending a hand with", "I can offer"]

  (rand(2) + 1).times do
    cat = Category.all.sample

    case cat.name
    when "tools"
      offer_description = ["I have an entire toolkit if anyone needs it!", "Let me know if anyone wants to borrow a ladder!"].sample
      request_description = ["I really need to borrow a hammer.", "In need of a saw to build a dog house."].sample
    when "tech help"
      offer_description = ["I just got done learning a lot from Le Wagon! Let me know if anyone needs a website built!", "I am a computer expert! I can fix anything on a computer or laptop!"].sample
      request_description = ["Broke my computer. Can someone help?", "I am old and don't know anything about the internet. Please help me with an online order."].sample
    when "medicine"
      offer_description = ["Corona got your head hurting?  I have a lot of asprine!", "Vicks fixes anything!  I have lots of it! Let me know if you need some!"].sample
      request_description = ["Need some advil!", "I have a fever.  Does anyone have anything to help with that?"].sample
    when "ppe"
      offer_description = ["I have extra masks and gloves!", "I have a 3D printer and can make you a face shield!  Let me know if you need one!"].sample
      request_description = ["I need a mask!", "Does anyone have extra hand sanitizer?"].sample
    when "hygienics"
      offer_description = ["Need deodrant?  I have some!", "I have lot of extra person hygiene items.  Let me know if you need something!"].sample
      request_description = "Need some soap."
    when "food"
      offer_description = ["I have extra flours, sugar, and eggs.", "I have milk, eggs, and bread to offer!"].sample
      request_description = ["I would like some bread.", "In search of some veggies and fruits."].sample
    when "transportation"
      offer_description = ["Offering a ride within a 20km radius.", "Let me know if you need a ride to work!"].sample
      request_description = ["I need a ride to work!", "I need a ride to school!"].sample
    when "errands"
      offer_description = ["Willing to ran any errand you have on my bike!", "I have a car and can run errands!"].sample
      request_description = "Can someone please walk my dog."
    when "deliveries"
      offer_description = "Can make delivers for you!"
      request_description = "I need my groceries delivered to me!"
    when "clothing"
      offer_description = ["Lots of old baby clothes!", "Lots of gently used women clothing.  Size medium"].sample
      request_description = ["Looking for clothes for my teenage daughter.", "Looking for mens medium clothes."].sample
    when "finances"
      offer_description = ["I can help with your hydro bill.", "I have some extra cash and can help pay for groceries or gas."].sample
      request_description = ["I need some assistance with paying my phone bill.", "I need some help with paying for my textbook."].sample
    when "educational"
      offer_description = ["I have old kids books.", "Extra school supplies to offer.  Notebooks, pencils, binders.  Let me know if you need anything."].sample
      request_description = ["I need a backpack." "I need some notebooks and pens."].sample
    when "shelter"
      offer_description = ["My house is your house.  Let me know if you are in need of a place to stay.", "I have an empty room for 3 nights. Let me know if you need it."].sample
      request_description = "Looking for a place to crash for 2 nights."
    when "cleaning"
      offer_description = "Will clean your house!"
      request_description = "I need my house cleaned!"
    when "household"
      offer_description = ["I have a couch I don't need! Free to whoever wants to come pick it up!", "Let me know if you need to borrow my mop!"].sample
      request_description = "Does anyone have some bedsheet for a queen size bed?"
    when "conversation"
      offer_description = "Not a real therapist, but I will listen to your problems. <3"
      request_description = "I just really need someone to talk to."
    end

    post = Post.new(post_type: type,
                title: "#{type == "Offer" ? offer_title.sample : request_title.sample} #{cat.name}",
                description: type == "Offer" ? offer_description : request_description,
                location: user.address,
                priority: type == "Request" ? %w[High Medium Low].sample : nil)
    post.author = user
    post.category = cat
    post.save!
  end
end
puts "generated 20 random users with 1-3 posts each"

# CREATE POSTS FOR COMRADES
puts "generating comrade posts..."
Post.create!(post_type: "Offer",
    author: nirali,
    title: "Offering tools",
    category: Category.find_by_name('tools'),
    description: "Hey, I've got a bunch of hardware in case anyone needs it. Hammers, saws, levels, drills...you name it! Just lemme know what you need--happy to deliver too :)",
    location: nirali.address)
Post.create!(post_type: "Request",
    author: ryan,
    title: "Looking to borrow a ladder",
    category: Category.find_by_name('tools'),
    description: "Seems pointless to buy something I'll only use once. Give me a shout if anyone has a 6ft ladder and can deliver. Thanks!!",
    location: ryan.address,
    priority: "Medium")
Post.create!(post_type: "Offer",
    author: deb,
    title: "Groceries to give away!",
    category: Category.find_by_name('food'),
    description: "Hey everyone, I'm moving at the end of the month and I've got a bunch of awesome healthy food to give away. If you're within 20km I can deliver too!",
    location: deb.address)
Post.create!(post_type: "Request",
    author: arthur,
    title: "Food bank is out, need some support!",
    category: Category.find_by_name('food'),
    priority: 'High',
    description: "This month's been rough since losing my job, and the food bank can't keep up with the recent supply. Some basic necessities would go a long way if anyone has some staples like rice, pasta, or canned good they could contribute?",
    location: arthur.address)
puts "comrade posts created!"

puts "generating 10 random connections..."
messages = ["I can help!", "I got you!", "I've got what you need!",
           "I think I could be of service to you", "I'm here for you.",
           "No worries, I got this :)", "Let me offer you some support",
           "Let's find a time, I'd be happy to help.", "How's this weekend?"]
10.times do
  # make some random connections!
  connection = Connection.new(message: messages.sample, status: "Pending")
  # find a random user who has offered before
  connection.responder = Post.where("post_type = 'Offer'").sample.author
  # find a random user looking for something
  connection.post = Post.where("post_type = 'Request'").sample

  connection.save!

  # this is a non-identical copy of the initialize_chat method in the connections_controller
  # we could probably call that method from here instead, but for now, this:
  room_name = [connection.post.author.id, connection.responder.id].sort.join('-')
  @chatroom = Chatroom.find_by_name(room_name) || Chatroom.new(name: room_name)
  @initial_msg = "<span class='chat-alert'>new connection via
                  <a href='posts/#{connection.post.id}'>#{connection.post.title}</a></span>"
  @initial_msg += connection.message
  @message = Message.create!(content: @initial_msg, user: connection.responder, chatroom: @chatroom)
  @responder_msg = "Thanks for the message, I'll be in touch soon."
  @message = Message.create!(content: @responder_msg, user: connection.post.author, chatroom: @chatroom)

end

puts "generated 10 random connections!"

