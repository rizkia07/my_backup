class ReportBranch
  def self.main(user_id=nil)
    Report.main(Branch, user_id)
  end
end
