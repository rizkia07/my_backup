# coding: UTF-8

class Title < ActiveRecord::Base
  attr_accessible :is_ng, :name, :id, :branch_id
  has_many :branches
  belongs_to :title
  belongs_to :url
  belongs_to :branch
  belongs_to :photo

  def self.is_japanese?(string)
    return string =~ /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/
  end

  def self.get(name)
    if name.gsub(/ 　/,'') != ""
      title = Title.find_or_initialize_by_name(name)
      if title.url?
        if Title.is_japanese?(title.name)
          escapedName = CGI.escape(title.name)
          title = Title.find_or_initialize_by_name(escapedName)
        end
      end
      title.save
      return title
    else
      nil
    end

    #rescue => e
    #  logger.info(e)
  end

  def url?
    self.name.match(/^http/) ? true : false
  end

  def updt_parents
    branches = Branch.where(
      "parent_id = ? and leaf_num > 0", self.id
    )
    branches.each do |branch|
      if branch.parent_id != 0
        parent_id = branch.parent.title_id
        child_id = self.id
        TitleParent.find_or_create_by_parent_id_and_title_id(
          parent_id, child_id
        )
      end
      Branch.where(
        "parent_id = ? and leaf_num > 0", branch.id
      ).each do |child|
        parent_id = branch.title_id
        child_id = child.title_id
        TitleParent.find_or_create_by_parent_id_and_title_id(
          parent_id, child_id
        )
      end
    end
  end

  def self.updt_urls
    Title.where("name like 'http%'").order('id desc').each do |title|
      title.updt_url
    end
  end

  def open_html
    begin
      html = open(self.name)
    rescue
      html = open(self.name.gsub(/https/, 'http'))
    end
    return html
  end

  def updt_url
    body = nil

    begin
      html = open_html()
      doc = Nokogiri::HTML(html, nil, html.charset)

      begin
        name = doc.xpath("//title")[0].text.force_encoding('UTF-8')

        unless Title.is_japanese?(name)
          html = open_html()
          doc = Nokogiri::HTML(html)
          name = doc.xpath("//title")[0].text.force_encoding('UTF-8')
        end
      rescue
        name = File.basename(self.name)
      end

      images = doc.xpath("//img")
      image = nil
      images.each do |img|
        if image.nil? || image['width'].to_i < img['width'].to_i 
          image = img
        end
      end

      body = doc.xpath('//body')[0].to_html unless doc.nil?

    rescue => e
      logger.info(e)
    end

    begin
      if name.present?
        url = Url.find_or_create_by_url(self.name)
        url.name = name
        url.image = URI.join(self.name, image['src'].to_s).to_s if image.present?
        url.body = body
        url.favicon = Feed.fetch_base64_favicon(self.name)
        url.save
        self.url_id = url.id
        self.updt_body_summary
        self.save
        return self
      end
    rescue => e
      logger.info(e)
    end
  end

  def leaf(user_id)
    Leaf.where(
      :is_disabled => false,
      :branch_id => self.branches.map{|i|i.id}    
    )
  end
  
  def self.id_name
    @titles = {}
    Title.all.each do |title|
      @titles[title.id] = title.name
    end
    @titles
  end

  def self.suggest(name)
    Title.where("name like ? and url_id is null and is_ng = 0", "%#{name}%").map{|i| i.name}
  end

  def set_flickr_photo
    query = self.url.nil? ? self.name : self.url.name
    photo = Flickr.search(self.name)
    if photo.present?
      self.photo_id = photo.id
      self.save
    end
  end

end
