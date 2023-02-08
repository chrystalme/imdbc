# frozen_string_literal: true

class Movie < ApplicationRecord
  belongs_to :category
  belongs_to :publisher, class_name: 'User'
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user


  validates :title, presence: true
  validates :publisher, presence: true
  validates :text, length: {minimum: 10}
  validates :publisher, presence: true
  validates :category, presence: true

  scope :ordered, -> { order(title: :asc) }
end
