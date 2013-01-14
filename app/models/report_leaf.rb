class ReportLeaf
  def self.main(user_id=nil)
    Report.main(Leaf, user_id)
  end
end
