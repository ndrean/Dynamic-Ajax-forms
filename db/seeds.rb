# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


puts 'cleaning'
Comment.destroy_all
Resto.destroy_all

puts 'creating'

3.times do
    resto = Resto.create! name: Faker::Restaurant.unique.name
    3.times do
        Comment.create!(resto_id: resto.id, comment: Faker::Restaurant.unique.review  )
    end
end
