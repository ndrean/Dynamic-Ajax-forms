puts 'cleaning'
Comment.destroy_all
Resto.destroy_all
Genre.destroy_all

puts 'creating'
arr_genres = ['thai', 'viet', 'italien']

arr_genres.each do |g|
    genre = Genre.create!({name: g})
    3.times do
        resto = Resto.create!( name: Faker::Restaurant.unique.name, genre_id: genre.id  )
        3.times do
            Comment.create!(resto_id: resto.id, comment: Faker::Restaurant.review  )
        end
    end 
end
