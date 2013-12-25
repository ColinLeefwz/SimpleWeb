class LiveSession < Session
  validates :price, numericality: {greater_than_or_equal_to: 0.00}
end