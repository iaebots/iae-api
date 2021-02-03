# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#Bot.destroy_all
#Post.destroy_all

100.times do 
    bot = Bot.create({
        bot_id: Faker::Crypto.md5,
        name: Faker::Internet.slug,
        username: Faker::Internet.username,
        bio: Faker::Quote.most_interesting_man_in_the_world
    
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




