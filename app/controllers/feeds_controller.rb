require 'rss'

class FeedsController < ApplicationController

  include ActionView::Helpers::TextHelper

  def index
    feeds = Feed.recommends(@user, params[:offset].to_i, 9)
    render :json => feeds
  end

  def show
  end

  def create
    title = params[:title]
    uri = params[:uri]

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
          Feed.bring_entry(entry, @user)
        end
      end

      # Subscribe by this user
      unless @user.feed_sites.exists?(site)
        @user.feed_sites << site 
        subscription = @user.feed_subscriptions.last
        subscription.title = params[:title] 
        subscription.uri = params[:uri] 
        subscription.save!
      else
        subscription = @user.feed_subscriptions.find_by_feed_site_id(site.id)
        subscription.title = params[:title] 
        subscription.save!
        #raise 'This site has been already subscried'
      end

    else
        raise "Can't find news"
    end

    render :json => { :result => true }

    rescue => e
      #render :json => { :error => e.message } 
      render :json => { :error => "This site is not supperted now." } 
  end

  def destroy
    subscription = @user.feed_subscriptions.find_by_feed_site_id(params[:id].to_i)

    @user.feed_reads.where(:feed_entries => { :feed_site_id => subscription.feed_site_id }).joins(:feed_entry).destroy_all
    
    subscription.delete

    render :json => { :result => true }
  end

  def update
    if params[:is_all].nil? || !params[:is_all]
      read = @user.feed_reads.find_by_feed_entry_id(params[:id].to_i)
      read.is_read = params[:is_read]
      read.save! 
    else
      @user.feed_reads.each do |read|
        read.is_read = params[:is_read]
        read.save! 
      end
    end
    render :json => { :result => true }
  end

  def sites
    feeds = []
    @user.feed_subscriptions.each do |subscription|
      feeds << {
        :id => subscription.feed_site.id,
        :uri => subscription.feed_site.uri,
        :title => subscription.title.present? ? subscription.title : subscription.feed_site.title,
      }
    end
    render :json => feeds
  end

end

