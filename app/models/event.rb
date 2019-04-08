class Event < ApplicationRecord
  validates :name, :location, presence: true

  validates :description, length: {minimum: 25}

  validates :location, presence: true

  validates :price, numericality: { greater_than_or_equal_to: 0 }

  validates :capacity, numericality: {only_integer: true, greater_than: 0}

  validates :image_file_name, allow_blank: true, format: {
    with:    /\w+\.(gif|jpg|png)\z/i,
    message: "must reference a GIF, JPG, or PNG image"
  }

  has_many :registrations, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  scope :upcoming, -> { where('starts_at >= ?', Time.now).order(:starts_at) }
  scope :past, -> { where('starts_at < ?', Time.now).order(:starts_at) }
  scope :free, -> { upcoming.where(price: 0.0).order(:name) }
  scope :recent, ->(max=3) { past.limit(max) }

  def free?
    price.blank? || price.zero?  
  end

  # def self.past
  #   where("starts_at < ?", Time.now).order("starts_at")
  # end

  # def self.upcoming
  #   where("starts_at >= ?", Time.now).order("starts_at")
  # end

  def spots_left
    if capacity.zero?
      0
    else
      capacity - registrations.size
    end
  end
  
  def sold_out?
    spots_left.zero?
  end
end
