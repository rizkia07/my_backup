# -*r coding: utf-8 -*-
class Csvdata
  def self.export
    require 'kconv'
    require 'csv'
    file_name = Kconv.kconv("public/csv/#{Time.now.strftime("%Y-%m-%d")}baton.csv", Kconv::SJIS)
    branches = Branch.where(:is_ng => false)
    titles = []
    header = ["id","操作","本文(120文字まで)","言語","1","2","3","4","5","6","7","8","9"]
    csv_data = CSV.generate("", {:row_sep => "\r\n", :headers => header, :write_headers => true}) do |csv|
      branches.each do |branch|
        column = [
          branch.id,
          "",
          "",
        ]
        breadcrumbs = []
        parent_id = branch.parent_id
        while(branch.parent_id != 0) do
          breadcrumbs = [branch.title.name] + breadcrumbs 
          branch = branch.parent
        end
        breadcrumbs = [branch.title.name] + breadcrumbs 
        column += breadcrumbs 
        csv << column
      end
    end
    csv_data = csv_data.tosjis

    #save_file(csv_data, :type => 'text/csv; charset=shift_jis; header=present', :filename => file_name)


    File.open(file_name,'w:sjis'){|f|
      f.write csv_data
    }

  end

end
