require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open("https://learn-co-curriculum.github.io/student-scraper-test-page/")
    doc = Nokogiri::HTML(html)
    student_array = []

    doc.css("div.student-card").each do |student|
      student_array << student_hash = {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    attribute_hash = {}

    social_box = doc.css("div.social-icon-container a").collect {|icon| icon.attribute("href").value}
    social_box.each do |url|
      if url.include?("twitter")
        attribute_hash[:twitter] = url
      elsif url.include?("linkedin")
        attribute_hash[:linkedin] = url
      elsif url.include?("github")
        attribute_hash[:github] = url
      else url.include?(".com")
        attribute_hash[:blog] = url
      end
    end

    doc.css("div.vitals-text-container").each do |info|
      attribute_hash[:profile_quote] = info.css("div.profile-quote").text
    end

    doc.css("div.details-container").each do |stat|
      attribute_hash[:bio] = stat.css("p").text
    end
  attribute_hash
  end
end


# twitter = social.css("a").attribute("href").value
#   attribute_hash[:twitter] = twitter if twitter.include?("twitter")
# linkedin = social.css("a[2]").attribute("href").value
#   attribute_hash[:linkedin] = linkedin if linkedin.include?("linkedin")
# github = social.css("a[3]").attribute("href").value
#   attribute_hash[:github] = github if github.include?("github")
# blog = social.css("a[4]").attribute("href").value
#   attribute_hash[:blog] = blog if blog.include?(".com")
