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
    post = Post.new(post_type: type,
                title: "#{type == "Offer" ? offer_title.sample : request_title.sample} #{cat.name}",
                description: Faker::Lorem.paragraph(sentence_count: 3, random_sentences_to_add: 2),
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
end
puts "generated 10 random connections!"

