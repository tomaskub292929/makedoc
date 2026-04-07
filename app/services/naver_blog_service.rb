require "rss"
require "net/http"
require "openssl"

class NaverBlogService
  FEED_URL = "https://rss.blog.naver.com/makedoc.xml"

  def self.recent_posts(count = 4)
    uri = URI.parse(FEED_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.open_timeout = 5
    http.read_timeout = 5
    response = http.get(uri.request_uri)
    feed = RSS::Parser.parse(response.body, false)

    feed.items.first(count).map do |item|
      desc = item.description.to_s
      thumbnail = extract_thumbnail(desc)
      clean_text = ActionController::Base.helpers.strip_tags(desc).squish.truncate(120)

      {
        title: item.title,
        link: item.link.gsub("?fromRss=true&trackingCode=rss", ""),
        date: item.pubDate,
        category: item.category&.content || "해외 의대",
        author: item.author || "makedoc",
        description: clean_text,
        thumbnail: thumbnail
      }
    end
  rescue StandardError => e
    Rails.logger.error("NaverBlogService fetch failed: #{e.message}")
    []
  end

  def self.extract_thumbnail(html)
    match = html.match(/<img[^>]+src=["']([^"']+)["']/)
    match[1] if match
  end

  private_class_method :extract_thumbnail
end
