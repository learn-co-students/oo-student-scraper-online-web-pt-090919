require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  attr_accessor :name, :location, :profile_url

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    student_array = []
    
    doc.css(".student-card").each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      profile_url = student.css("a").attribute("href").value
      student_array << {:name => name, :location => location, :profile_url => profile_url}
    end  
    student_array
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    
    profile_hash = {}
    
    socials = doc.css(".social-icon-container a").collect{|icon| icon.attribute("href").value}
    
    socials.each do |link|
      if link.include?("twitter")
        profile_hash[:twitter] = link
      elsif link.include?("linked")
        profile_hash[:linkedin] = link
      elsif link.include?("github")
        profile_hash[:github] = link
      else
        profile_hash[:blog] = link
      end
    end
    
    profile_hash[:profile_quote] = doc.css(".profile-quote").text
    profile_hash[:bio] = doc.css(".description-holder p").text
    
    profile_hash
  end
end

