require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  # Take in arg of URL of index page
  def self.scrape_index_page(index_url)
    scraped_students = []
    
    # use Nokogiri and Open-URI to access that page
    doc = Nokogiri::HTML(open(index_url))
    
    get_student_cards = doc.css("div.student-card")
    
    get_student_cards.each_with_index do |student_card, idx|
      student_hash = {
        :name => student_card.css("h4.student-name").text,
        :location => student_card.css("p.student-location").text, 
        :profile_url => student_card.css("a").first.attributes["href"].value
      }
      
      scraped_students << student_hash 
    end
    
    # Return array of hashes in which each hash = single student
    scraped_students
  end

  
  # Class method that scrapes a student's profile page and returns a hash of attributes describing an individual student
  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    
    social_icons = doc.css("div.social-icon-container a")
    
    student_profile = {}
    
    # Can handle profile pages without all of the social links
    # by iterating thru each social icon available
    social_icons.each_with_index do |social_icon, idx|
      link = social_icon.attributes["href"].value 
      
      if link.include?("twitter")
        student_profile[:twitter] = link
      elsif link.include?("linkedin")
        student_profile[:linkedin] = link
      elsif link.include?("github")
        student_profile[:github] = link
      elsif link!= nil 
        student_profile[:blog] = link
      end
        
    end
    student_profile[:profile_quote] = doc.css("div.profile-quote").text
    student_profile[:bio] = doc.css("div.description-holder p").text
    #Return hash 
    student_profile
  end

end

