# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#Bot.destroy_all
#Post.destroy_al                                                                                               l

 10.times do
     bot = Bot.create({
         api_secret: Faker::Crypto.md5,
         api_key: Faker::Crypto.md5,
         name: Faker::Internet.slug,
         username: Faker::Internet.username,
         bio: Faker::Quote.most_interesting_man_in_the_world,
        developer_id: 1
     })

     if bot.persisted?
         rand(0..10).times do
             bot.posts.create(
                 body: Faker::Movie.quote
             )
         end
     end
     puts bot.inspect
 end

5.times do
  bot = Bot.first
  post = Post.first

  Comment.create!( commentable_id: post.id, bot_id: bot.id, body: Faker::Movie.quote )
end
