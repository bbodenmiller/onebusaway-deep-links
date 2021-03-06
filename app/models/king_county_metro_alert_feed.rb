class KingCountyMetroAlertFeed < AlertFeed
  def fetch
    rss = Feedjira::Feed.fetch_and_parse(self.url)
    rss.entries.each do |entry|
      self.alert_feed_items.find_or_create_by!(external_id: entry.entry_id) do |item|
        item.title        = entry.title
        item.url          = entry.url
        item.summary      = parse_summary(entry.summary)
        item.published_at = entry.published
        item.external_id  = entry.entry_id
      end
    end
    super
  end

  private

  def parse_summary(summary)
    doc = Nokogiri::HTML(summary)
    doc.text.gsub(/\n/, ' ').strip
  end
end
