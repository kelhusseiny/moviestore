class Movie < ActiveRecord::Base
  ratyrate_rateable "visual_effects", "original_score", "director", "custome_design"

  def poster
    "http://ia.media-imdb.com/images/M/#{poster_url}"
  end

  def imdb
    "http://www.imdb.com/title/#{imdb_id}/"
  end
end
