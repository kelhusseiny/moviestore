class User < ActiveRecord::Base
  has_many :purchases, foreign_key: :buyer_id
  has_many :movies, through: :purchases
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  # Braintree methods
  FIELDS = [:first_name, :last_name, :phone, :website, :company, :fax, :addresses, :credit_cards, :custom_fields]
  attr_accessor *FIELDS

  def has_payment_info?
    braintree_customer_id
  end

  def with_braintree_data!
    return self unless has_payment_info?
    braintree_data = Braintree::Customer.find(braintree_customer_id)

    FIELDS.each do |field|
      send(:"#{field}=", braintree_data.send(field))
    end
    self
  end

  def default_credit_card
    return unless has_payment_info?
    credit_cards.find { |cc| cc.default? }
  end

  # Cart methods
  def cart_count
    $redis.scard "cart#{id}"
  end

  def cart_total_price
    total_price = 0
    get_cart_movies.each { |movie| total_price+= movie.price }
    total_price
  end

  def get_cart_movies
    cart_ids = $redis.smembers "cart#{id}"
    Movie.find(cart_ids)
  end

  # Purchasing methods
  def purchase_cart_movies!
    get_cart_movies.each { |movie| purchase(movie) }
    $redis.del "cart#{id}"
  end

  def purchase?(movie)
    movies.include?(movie)
  end

  def purchase(movie)
    movies << movie unless purchase?(movie)
  end
end
