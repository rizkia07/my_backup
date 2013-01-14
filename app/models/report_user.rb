class ReportUser
  def self.main(user_id=nil)
    Report.main(User, user_id)
  end
end
