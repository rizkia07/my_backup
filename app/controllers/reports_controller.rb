class ReportsController < ApplicationController
  # POST /reports.json
  def create
    viewer = User.find(params[:reports][:user_id].to_i)
    if viewer.id != current_user.id && viewer.app_token != params[:app_token]
      raise "invalid app_token or session"
    else
      @report = Report.create(params[:reports])
      render json: @report
    end
  end

  def index
=begin
    @data[:report_baton] = ReportBranch.main(@user.id)
    @data[:report_check] = ReportLeaf.main(@user.id)
    @data[:report_log_access] = ReportLeaf.main(@user.id)
    @data[:report_user] = ReportUser.main(@user.id)
=end
  end
end
