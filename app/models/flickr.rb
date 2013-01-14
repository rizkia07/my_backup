class Flickr

  def self.auth
    token = flickr.get_request_token
    auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')

    puts "Open this url in your process to complete the authication process : #{auth_url}"
    puts "Copy here the number given when you complete the process."
    verify = gets.strip

    begin
      flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
      login = flickr.test.login
      puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
    rescue FlickRaw::FailedResponse => e
      puts "Authentication failed : #{e.msg}"
    end
  end

  def self.search(query)
    query = query.strip

    photo = Photo.find_by_query(query)
    return photo if photo.present?

    flickr = Flickr.init_flickr

    args = {
      :text => query,
      :license => 4,
      :per_page => 1,
      #:sort => "interestingness-desc",
      :sort => "relevance",
    } 
    
    discovered_pictures = flickr.photos.search args
    id = discovered_pictures.first.id
    info = flickr.photos.getInfo(:photo_id => id)

    photo = Photo.new
    photo.flickr_id = id.to_s
    photo.url_q = FlickRaw.url_q(info) 
    photo.page = FlickRaw.url_photopage(info)
    photo.username = info.owner.username
    photo.realname = info.owner.realname
    photo.query = query
    photo.info = info
    
    photo.save!

    return photo

    rescue
      return nil
  end

  def self.fetch_licenses
    flickr = Flickr.init_flickr
    licenses = flickr.photos.licenses.getInfo
    licenses.each do |license|
      puts "#{license.id}: #{license.name}" 
    end
  end

  def self.init_flickr 
    flickr = FlickRaw::Flickr.new
    flickr.access_token = FLICKR_ACCESS_TOKEN
    flickr.access_secret = FLICKR_ACCESS_SECRET 
    return flickr
  end


end

