puts 'cleaning'
Comment.destroy_all
Resto.destroy_all
Genre.destroy_all

puts 'creating'

# genres = ['Thai', 'Viet', 'Italian', 'Mexican', 'Chinese', 'French', 'Greek']
tab=[]
10.times do
    tab << Genre.create!( name: Faker::Restaurant.unique.type )
end
# tab = []
# genres.each do |g|
#     tab << Genre.create!({name: g})
# end

5.times do
    resto = Resto.create!( name: Faker::Restaurant.unique.name, genre: tab.sample )
    3.times do
        Comment.create!( resto: resto, comment: Faker::Restaurant.unique.review )
    end
end

10.times do
    Resto.create!(name: Faker::Restaurant.unique.name, genre: tab.sample)
end

