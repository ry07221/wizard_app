class Address < ApplicationRecord

  belongs_to :user, optional: true
  validates :zipcode, :address ,presence: true

end


