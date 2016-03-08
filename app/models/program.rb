class Program < ActiveRecord::Base
	has_many :activities
	validates :line, :name, :description, presence: true
end