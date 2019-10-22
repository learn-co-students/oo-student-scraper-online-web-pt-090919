require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open("http://learn-co-curriculum.github.io/student-scraper-test-page/"))
    doc.css("div.student-card")

  def self.scrape_profile_page(profile_url)

  end

end
