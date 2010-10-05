class Course < ActiveRecord::Base
  validates_presence_of :name, :description, :price, :start_at, :stop_at, :location

  has_many :sections
  has_many :questions
  has_many :resources
  has_many :follow_ups
  accepts_nested_attributes_for :questions, :reject_if => :all_blank
  accepts_nested_attributes_for :resources, :reject_if => :all_blank
  accepts_nested_attributes_for :follow_ups, :reject_if => :all_blank


  def questions_with_blank
    questions + [questions.new]
  end

  def resources_with_blank
    resources + [resources.new]
  end

  def follow_ups_with_blank
    follow_ups + [follow_ups.new]
  end
end
