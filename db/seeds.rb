puts 'cleaning'
Comment.destroy_all
Resto.destroy_all
Genre.destroy_all
Client.destroy_all

puts 'creating'

RCOLORS = ['cornsilk','bluebell','lavender','magnolia','deepblue', 'orange','indigo','beige', 'sandy', 'soda' ]



tab=[]
i=0
10.times do
    tab << Genre.create!( name: Faker::Restaurant.unique.type, color: Genre::COLORS.sample )
end
# tab = []
# genres.each do |g|
#     tab << Genre.create!({name: g})
# end
i=0
6.times do
    resto = Resto.create!( name: Faker::Restaurant.unique.name, genre: tab.sample, color: RCOLORS.sample )
    client = Client.create!(name: Faker::Name.unique.name)
    3.times do
        Comment.create!( resto: resto, client: client, comment: Faker::Restaurant.review+"#{i}" )
    end
    i +=1
    puts i
end

# 10.times do
#     Resto.create!(name: Faker::Restaurant.name, genre: tab.sample, color: RCOLORS.sample)
# end

