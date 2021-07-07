require 'open-uri'
require 'pry'

html = Nokogiri::HTML(open("https://learn-co-curriculum.github.io/student-scraper-test-page/index.html"))

class Scraper

  def self.scrape_index_page(index_url) # scraping the index page that lists all of the students
    
  end

  def self.scrape_profile_page(profile_url) #individual student's profile page 
    
  end



