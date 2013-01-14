# -*r coding: utf-8 -*-
class Url < ActiveRecord::Base
  attr_accessible :name, :url
  has_many :titles

  def self.updt_body_summary_all
    Url.all.each do |url|
      url.updt_body_summary
    end
  end

  def updt_body_summary
    self.body_summary = Sanitize.clean(self.body.to_s.gsub(/<script.+?script>/im, ''), :whitespace_elements => nil).gsub(/\n/, '').gsub(/\s+/, '')
    self.save
  end
end
