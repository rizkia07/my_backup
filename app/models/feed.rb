require 'rss'
require 'open-uri'

class Feed

  def self.recommends(user, offset = 0, num = 10, is_read = false)

    feeds = []

    unread_count = user.feed_reads.where(:is_read => is_read).order("published_at DESC").offset(offset * num).limit(num).joins(:feed_entry).count

    if (unread_count < num) 
      #FeedEntry.order("RAND()").limit(num - feeds.count).each do |entry|
      FeedEntry.order("RAND()").limit(num).each do |entry| # limit includes buffer
        Feed.bring_entry(entry, user)
      end
    end

    reads = user.feed_reads.where(:is_read => is_read).order("published_at DESC").offset(offset * num).limit(num).joins(:feed_entry).readonly(false)

    reads.each do |read|
      feeds << {
        :id => read.feed_entry.id,
        :date => read.feed_entry.published_at.to_s,
        #:summary => strip_tags(read.feed_entry.summary),
        :summary => Sanitize.clean(read.feed_entry.summary.to_s.gsub(/<script.+?script>/im, ''), :whitespace_elements => nil).gsub(/\n/, '').gsub(/\s+/, ''),
        :uri => read.feed_entry.uri.to_s,
        :title => read.feed_entry.title.to_s,
        :is_read => read.is_read,
        :favicon => read.feed_entry.favicon.to_s  
      }
      read.count_up
    end

    return feeds
  end

  def self.subscribe(user, uri)

    # Find feed uri if uri is not feed
    unless Feedbag.feed?(uri)
      feeds = Feedbag.find(uri)
      if feeds.present?
        uri = feeds[0]
      else
        uri = ''
      end
    end

    if uri.present?
      # Add site to global table
      rss = RSS::Parser.parse(uri, false)

      site = FeedSite.find_or_initialize_by_uri(uri)

      site.title = Feed.parse_title(rss)
      site.save!

      # Fetch entries
      rss.items.each do |item|
        entry = Feed.store_entry(item, site)
        if entry
          Feed.bring_entry(entry, user)
        end
      end

      # Subscribe by this user
      unless user.feed_sites.exists?(site)
        user.feed_sites << site 
        subscription = user.feed_subscriptions.last
        #subscription.title = title
        subscription.uri = uri
        subscription.save!
      else
        subscription = user.feed_subscriptions.find_by_feed_site_id(site.id)
        #subscription.title = title
        subscription.save!
      end
    end

    rescue => e
      Rails.logger.error(e)
  end

  def self.crawl

    FeedSite.all.each do |site|

      rss = RSS::Parser.parse(site.uri, false)

      # Update title
      site.title = Feed.parse_title(rss)
      site.save!

      # Fetch entries
      rss.items.each do |item|
        entry = Feed.store_entry(item, site)

        site.users.each do |user|
          Feed.bring_entry(entry, user)
        end
      end

      sleep 1
    end

  end

  def self.store_entry(item, site)
    # rss, rss2 -> link, title
    # atom -> link.href, title.content
    link = item.link.respond_to?(:href) ? item.link.href : item.link

    # Remove ad
    return if URI.parse(link).host == 'rss.rssad.jp'

    title = item.title.respond_to?(:content) ? item.title.content : item.title

    published_at = item.date if item.respond_to?(:date) # rss1
    published_at = item.pubDate if item.respond_to?(:pubDate) # rss2
    published_at = item.published.content if item.respond_to?(:published) #rss3

    summary = item.respond_to?(:summary) ? item.summary.content : item.description

    favicon = Feed.fetch_base64_favicon(link)

    entry = FeedEntry.find_or_initialize_by_uri(link)
    entry.title = title
    entry.uri = link
    entry.published_at = published_at.nil? ? nil : published_at.to_datetime 
    entry.summary = summary
    entry.feed_site = site
    entry.favicon = favicon
    entry.save!

    return entry

    rescue => e
      Rails.logger.error(e)
  end

  # Add entry to user as unread entry
  def self.bring_entry(entry, user)
    unless user.feed_entries.exists?(entry)
      user.feed_entries << entry
      user.save
    end
  end

  def self.parse_title(rss)
    # rss, rss2 -> rss.channel.title
    # atom -> rss.title
    #rss.respond_to?(:channel) ? rss.channel.title : rss.title.content
    rss.respond_to?(:title) ? rss.title.content : rss.channel.title 

    rescue => e
      Rails.logger.error(e)
  end
  
  # Just test for cron
  def self.test
    Rails.logger.error 'called'
  end

  def self.fetch_base64_favicon(url)
    favicon = WWW::Favicon.new.find(url)

    unless favicon.nil?
      uri = open(favicon)
      data = uri.read
      base64 = Base64.encode64(data).gsub /\n/,""
      data_uri = "data:#{uri.content_type};base64,#{base64}"
      favicon = data_uri
    end

    return favicon
  end

end
