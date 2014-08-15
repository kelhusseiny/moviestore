class Movie < ActiveRecord::Base
  has_many :purchases
  has_many :buyers, through: :purchases

  before_save :embed_video_url

  def poster
    "http://ia.media-imdb.com/images/M/#{poster_url}"
  end

  def imdb
    "http://www.imdb.com/title/#{imdb_id}/"
  end

  def embed_video_url
    self.video_url = "//www.youtube.com/embed/#{video_url.split('v=')[1].split('&list')[0]}"
  end

  def cart_action(current_user_id)
    if $redis.sismember "cart#{current_user_id}", id
      "Remove from"
    else
      "Add to"
    end
  end
end
