Connection.destroy_all
User.destroy_all
Post.destroy_all
Category.destroy_all

puts "generating categories..."
categories = ['tools', 'tech help', 'medicine', 'ppe', 'personal hygiene supplies',
              'food', 'transportation', 'errands', 'deliveries', 'clothing',
              'financial support', 'school supplies', 'shelter', 'cleaning supplies',
              'household supplies', 'emotional support']
categories.each { |cat| Category.create!(name: cat) }
puts "categories created!"

# 20 addresses
MTL_ADDRESSES = ['1701 rue Parthenais, Montréal, QC',
                '750 rue Willibrord, Montréal, QC',
                '1000 de La Gauchetiere Street West, Montréal, QC',
                '106 rue St-Paul ouest, Montréal, QC',
                '900 Place Jean-Paul-Riopelle, Montréal, QC',
                '1 rue St-Paul Ouest, Montréal, QC',
                '468 Rue McGill, Montréal, QC',
                '312 rue Saint-Paul O., Montréal, QC',
                '4285 Drolet St, Montreal, QC',
                '7503 Rue St Denis, Montreal QC',
                '251 Av Percival Montreal Ouest QC',
                '11727 Rue Notre Dame E, Montreal QC',
                '3708 Rue St Hubert, Montreal QC',
                '800 Rue Gagne Lasalle QC',
                '5930 Rue Hurteau, Montreal QC',
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

puts "generating comrades..."
deb = User.create!(name: 'Deb Anjos',
       email: 'deb@email.com',
       address: "1200 Rue Atateken, Montreal QC",
       password: 'password',
       phone: '(514) 438-2917')
ryan = User.create!(name: 'Ryan Buckley',
       email: 'ryanbuckley@gmail.com',
       address: "4107 Rue St. Laurent, Montreal QC",
       password: 'password',
       phone: '(438) 403-6403')
arthur = User.create!(name: 'Arthur Prats',
       email: 'arthur@email.com',
       address: "4655 Rivard St, Montreal, QC",
       password: 'password',
       phone: '(438) 403-1532')
nirali = User.create!(name: 'Nirali Patel',
       email: 'nirali@email.com',
       address: "5333 Ave Casgrain, Montreal, QC",
       password: 'password',
       phone: '(438) 403-5221')
puts "comrades created!"

puts "generating comrade posts..."
nirali_post = Post.create!(post_type: "Offer",
              title: "Offering tools",
              author: nirali,
              category: Category.find_by_name('tools'),
              description: "Hey, I've got a bunch of hardware in case anyone needs it. Hammers, saws, levels, drills...you name it! Just lemme know what you need--happy to deliver too :)",
              location: nirali.address)
ryan_post = Post.create!(post_type: "Request",
            title: "Looking to borrow a ladder",
            author: ryan,
            category: Category.find_by_name('tools'),
            description: "Seems pointless to buy something I'll only use once. Give me a shout if anyone has a 6ft ladder and can deliver. Thanks!!",
            location: ryan.address,
            priority: "Medium")
deb_post = Post.create!(post_type: "Offer",
            title: "Groceries to give away!",
            author: deb,
            category: Category.find_by_name('food'),
            description: "Hey everyone, I'm moving at the end of the month and I've got a bunch of awesome healthy food to give away. If you're within 20km I can deliver too!",
            location: deb.address)
arthur_post = Post.create!(post_type: "Request",
            title: "Food bank is out, need some support!",
            author: arthur,
            category: Category.find_by_name('food'),
            description: "This month's been rough since losing my job, and the food bank can't keep up with the recent supply. Some basic necessities would go a long way if anyone has some staples like rice, pasta, or canned good they could contribute?",
            location: arthur.address)

puts "comrade posts created!"

puts "generating 20 random users with 1-3 posts each..."
20.times do |i|
  user = User.new(name: Faker::Name.unique.name,
                  email: Faker::Internet.unique.email,
                  address: MTL_ADDRESSES[i],
                  password: 'password',
                  phone: MTL_PHONES[i])
  user.save!

  type = rand(1) > 0.5 ? "Request" : "Offer"

  rand(3).times do
    post = Post.new(post_type: type,
                title: Faker::Quote.famous_last_words,
                description: Faker::Lorem.paragraph(sentence_count: 3, random_sentences_to_add: 2),
                location: user.address,
                priority: type == "Offer" ? %w[High Medium Low].sample : nil)
    post.author = user
    post.category = Category.all.sample
    post.save!
  end
end
puts "generated 20 random users with 1-3 posts each"

puts "generating 10 random connections..."
message = ["I can help!", "I got you!", "I've got what you need!",
           "I think I could be of service to you", "I'm here for you.",
           "No worries, I got this :)", "Let me offer you some support",
           "Let's find a time, I'd be happy to help.", "How's this weekend?"]
10.times do
  # make some random connections!
  connection = Connection.new(message: message.sample, status: "Pending")
  # find a random user who has offered before
  connection.responder = Post.where("post_type = 'Offer'").sample.author
  # find a random user looking for something
  connection.post = Post.where("post_type = 'Request'").sample

  connection.save!
end
puts "generated 10 random connections!"

