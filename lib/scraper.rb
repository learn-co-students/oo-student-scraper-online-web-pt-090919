#require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = Nokogiri::HTML(open(index_url))
    cards = html.css("div.student-card").map{|line|line.text.split(/\s{2,}/)}
    links = html.css("div.student-card a").map{|link|link["href"]}
    dictionary = []
    
    links.each_with_index { |link, index|
      student = {
        :name => cards[index][2],
        :location => cards[index][3],
        :profile_url => link
      }
      dictionary << student
    }
    dictionary
  end

  def self.scrape_profile_page(profile_url)
    html = Nokogiri::HTML(open(profile_url))
    links = html.css("div.social-icon-container a").map{|link|link["href"]}
    quote = html.css("div.profile-quote").text
    bio = html.css("div.description-holder").text.split(/\s{2,}/)[1]
    
    profile = {
      :twitter => links.detect{|link|link.include?("twitter")},
      :linkedin => links.detect{|link|link.include?("linkedin")},
      :github => links.detect{|link|link.include?("github")},
      :blog => nil,
      :profile_quote => quote,
      :bio => bio
    }
    
    profile[:blog] = links.detect{|link|!profile.values.include?(link)}
    
    profile.each{ |key,value| profile.delete(key) unless value }
#    binding.pry
    profile
    
  end

end

# :name => html.css("div.student-card").map{|line|line.text.split(/\s{2,}/)}[index][2]

# :loca => html.css("div.student-card").map{|line|line.text.split(/\s{2,}/)}[index][3]

# :url => html.css("div.student-card a").map{|link|link["href"]}[index]