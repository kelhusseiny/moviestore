class CartsController < ApplicationController
  def show
    cart_ids = $redis.get("1")
    @cart_movies = Movie.find(eval cart_ids)
  end
end
