puts 'cleaning'
Comment.destroy_all
Resto.destroy_all
Genre.destroy_all

puts 'creating'

RCOLORS = ['cornsilk','bluebell','lavender','magnolia','deepblue', 'orange','indigo','beige', 'sandy', 'soda' ]



tab=[]
10.times do
    tab << Genre.create!( name: Faker::Restaurant.unique.type, color: Genre::COLORS.sample )
end
# tab = []
# genres.each do |g|
#     tab << Genre.create!({name: g})
# end

6.times do
    resto = Resto.create!( name: Faker::Restaurant.unique.name, genre: tab.sample, color: RCOLORS.sample )
    puts resto.color
    2.times do
        Comment.create!( resto: resto, comment: Faker::Restaurant.unique.review )
    end
end

10.times do
    Resto.create!(name: Faker::Restaurant.unique.name, genre: tab.sample, color: RCOLORS.sample)
end

