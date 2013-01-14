# -*r coding: utf-8 -*-
class WordsController < ApplicationController
  # GET /words/1.json
  def show
    id = params[:id].to_i
    if current_user
      user_id = current_user.id
    elsif params[:user_id]
      user_id = params[:user_id].to_i
    else
      user_id = 1
    end
    @words = Word.show(user_id, id)
    respond_to do |format|
      format.json { render json: @words }
      format.csv { send_data( csv_export(user_id, id, @words),
                              filename: "Batonのデータ(#{Branch.find(id).title.name})-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv",
                              type: 'text/csv; charset=cp932; header=present',
                              disposition: 'attachment'
                            )
                  }
    end
  end

  # POST /words.json
  def create #TODO "words" is "word"...
    viewer = User.find(params[:words][:user_id].to_i) 
    if viewer.id != current_user.id && viewer.app_token != params[:app_token]
      raise "invalid app_token or session"
    else
      @word = Word.create(params[:words])
      render json: @word
    end
  end

  # PUT /words/1.json
  def update #TODO "words" is "word"...
    viewer = User.find(params[:words][:user_id].to_i)
    if viewer.id != current_user.id && viewer.app_token != params[:app_token]
      raise "invalid app_token or session"
    else
      @word = Word.update(params[:id], params[:words])
      render json: @word
    end
  end

  private
    # required models : content, word, leaf
    require 'csv'
    def csv_export(user_id, branch_id, words)
      lang = Branch.get(2).title.name.to_s.tosjis
      headers = [:memo, :body, :lang, :title, :level1, :lebel2]
      dat = CSV.generate do |csv|
        csv <<  headers
        words[:children].each do |word|
          branch = Branch.get(word[:branch_id])
          leaf = branch.blank? ? '' : branch.leaf(user_id)
          csv << [
            leaf.blank? ? '' : leaf.content.try(:text).to_s.tosjis,
            lang,
            word[:title].to_s.tosjis
          ]
          Word.show(user_id, word[:branch_id])[:children].each do |under_word|
            under_branch = Branch.get(under_word[:branch_id])
            under_leaf = under_branch.blank? ? '' : under_branch.leaf(user_id)
            csv << [
              "ここは備考欄なので何を書いても反映されません。「#{word[:title]} > #{under_word[:title]}」より下のCSVファイルはこちらよりダウンロードできます。https://baton.mindia.jp/#{under_word[:branch_id].to_s}.csv".tosjis,
              under_leaf.blank? ? '' : under_leaf.content.try(:text).to_s.tosjis,
              lang,
              word[:title].to_s.tosjis,
              under_word[:title].to_s.tosjis
            ]
          end
        end
      end
    end

end
