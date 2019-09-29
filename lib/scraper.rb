require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css('div.roster-cards-container').each do |card|
      card.css('.student-card a').each do |student|
        student_profile_link = student.attr('href').to_s
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students << { name: student_name, location: student_location, profile_url: student_profile_link }
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))

    student_profile = {}

    socials = profile_page.css('.social-icon-container a').collect{|icon| icon.attribute('href').value}

    socials.each do |link|
      if link.include?('twitter')
        student_profile[:twitter] = link
      elsif link.include?('linked')
        student_profile[:linkedin] = link
      elsif link.include?('github')
        student_profile[:github] = link
      else
        student_profile[:blog] = link
      end
    end

    student_profile[:profile_quote] = profile_page.css('.profile-quote').text
    student_profile[:bio] = profile_page.css('.description-holder p').text

    student_profile
  end

end

