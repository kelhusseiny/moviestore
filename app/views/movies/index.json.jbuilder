json.array!(@movies) do |movie|
  json.extract! movie, :id, :title, :release_year, :price, :description, :imdb_id, :poster_url
  json.url movie_url(movie, format: :json)
end
