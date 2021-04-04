require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)

    # url = URI.parse(index_url)
    # response = NET::HTTP.get(url)
    html = open(index_url)
  #binding.pry
    doc = Nokogiri::HTML(html)
    student_cards = doc.css(".student-card a")   #.text.strip
    #puts student_cards
    #binding.pry
      student_cards.map do |element|
        {:name => element.css(".student-name").text,
          :location => element.css(".student-location").text,
          :profile_url => element.attr('href')
        }
      end

  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    #binding.pry
    social_icons = doc.css(".vitals-container .social-icon-container a")
    student_hash = {}
    #binding.pry
    social_icons.each do |element|
      if element.attr('href').include?("twitter")
        student_hash[:twitter] = element.attr('href')
      elsif element.attr('href').include?("linkedin")
        student_hash[:linkedin] = element.attr('href')
      elsif element.attr('href').include?("github")
        student_hash[:github] = element.attr('href')
      elsif element.attr('href').end_with?("com/")
        student_hash[:blog] = element.attr('href')
      end
    end

    student_hash[:profile_quote] = doc.css(".vitals-container .vitals-text-container .profile-quote").text
    student_hash[:bio] = doc.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text
      # elsif element.attr('href').include?("quote")
      #   student_hash[:profile_quote] = element.attr('href')
      # elsif element.attr('href').include?("bio")
      #   student_hash[:bio] = element.attr('href')
      student_hash
   
  end

  #end

end

