class Topic < ActiveRecord::Base
  attr_accessible :branch_id, :lang_id
  
  validates :branch_id, :lang_id, presence: true
  validates :branch_id, :lang_id, numericality: {greater_than: 0}
  validates :branch_id, uniqueness: true
  validates :branch_id, :inclusion => { :in => Branch.find(:all).map(&:id)}
  validates :lang_id, :inclusion => { :in => [1, 2]}
  
  belongs_to :branch 
end
