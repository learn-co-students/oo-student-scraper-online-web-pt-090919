require 'nokogiri'
require 'open-uri'
require 'pry'
require_relative './student.rb'
class Scraper

  def self.scrape_index_page(index_url)
    html = Nokogiri::HTML(open(index_url))
    students = html.css(".student-card")
    student_array = []
    students.each do |student|
      student_hash = {
      name: student.css(".student-name").text,
      location: student.css(".student-location").text,
      profile_url: student.css("a")[0]["href"]
      }
      student_array << student_hash
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
    media = profile.css(".vitals-container")
    media_hash = {}
    n = 0
    until media.css("a")[n] == nil
      a = media.css("a")[n]["href"]
      if a.include?("twitter")
        media_hash[:twitter] = a
      elsif a.include?("linkedin")
        media_hash[:linkedin] = a
      elsif a.include?("github")
        media_hash[:github] = a
      elsif a.include?("blog")
        media_hash[:blog] = a
      end
      n += 1
      binding.pry
    end
      media_hash[:bio] = profile.css(".description-holder p").text
    media_hash
  end

end