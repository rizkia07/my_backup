# -*r coding: utf-8 -*-
class ReportMailer < ActionMailer::Base
  def sent(org=nil)
    mail(
      :subject => "hoge subject",
      :from => "baton@mindia.jp",
      :to =>  "nishiko@mindia.jp",
      :bcc =>  "nishiko+baton_reply_bcc@mindia.jp",
    )
  end
end
