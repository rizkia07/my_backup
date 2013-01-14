class TopicsController < ApplicationController
  # GET /topics
  # GET /topics.xml
  def index

    respond_to do |format|
      format.html {
        @topics = Topic.all
      }
      format.xml { 
        offset = 0 
        limit = params[:n].blank? ? 3 : params[:n].to_i 

# manual topic
=begin
        topics = Topic.where(:lang_id => params[:lang_id].to_i).order("updated_at DESC").offset(offset).limit(limit)

        result = topics.map do |topic|
          {   
            :branch_id => topic.branch.id,
            :title => topic.branch.title.name,
          }   
        end 
=end

        logs = LogAccessWord.where('branch_id > ?', 100).where('branches.lang_id = ?', params[:lang_id].to_i).includes(:branch).group(:branch_id).limit(10).order('count_id DESC').count(:id)
        result = logs.map do |k, v|
            branch = Branch.find_by_id(k)
            {
              :branch_id => branch.id,
              :title => branch.title.name,
            }
        end

        render :xml => result.to_plist
      }
    end
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @topic = Topic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.json
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(params[:topic])

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render json: @topic, status: :created, location: @topic }
      else
        format.html { render action: "new" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.json
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to topics_url }
      format.json { head :no_content }
    end
  end
end
