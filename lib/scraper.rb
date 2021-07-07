require 'open-uri'
require 'pry'

class Scraper
  
    
  def self.scrape_index_page(index_url)
   doc = Nokogiri::HTML(open(index_url))
    student_cards = doc.css('div.roster-cards-container .student-card')
    students = []
    
    student_cards.each do |card|
      students << {
        :name => card.css('div.card-text-container h4.student-name').text,
        :location => card.css('div.card-text-container p.student-location').text,
        :profile_url => card.css('a').attribute('href').value
      }
    end
    students
  end
  

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    
    social_media_links = doc.css('div.social-icon-container a')
    profile_quote = doc.css("div.vitals-text-container .profile-quote").text
    biography = doc.css("div.description-holder p").text
    
    social = {}
    
    social_media_links.each do |social_platform|
      blog_name = social_platform.attribute('href').value.scan(/\w+\.{0}/)[1]
      if social_platform.attribute('href').value.include?('github')
        social[:github] = social_platform.attribute('href').value 
        elsif social_platform.attribute('href').value.include?('linkedin')
          social[:linkedin] = social_platform.attribute('href').value
            elsif social_platform.attribute('href').value.include?('twitter')
              social[:twitter] = social_platform.attribute('href').value
              elsif social_platform.attribute('href').value.include?(blog_name)
                social[:blog] = social_platform.attribute('href').value
      end
    end 
    social[:profile_quote] = profile_quote if profile_quote
    social[:bio] = biography if biography
    social
  end

end

