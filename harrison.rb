require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pp'


class Student
	url = "http://students.flatironschool.com/"
	doc = Nokogiri::HTML(open(url))

	each_url = doc.css(".columns .one_third a")
	all_url = []


	each_url.each do |iterate|
			full_url = url + iterate["href"]
			all_url << full_url
	end

	all_url.each do |iterate|
		this_student = {}
		begin
		doc2 = Nokogiri::HTML(open(iterate))
		rescue => e 
			next
		end

		name = doc2.css(".two_third h1")
		name.each_with_index do |num|
			this_student[:name] = num.text
		end

		tagline = doc2.css("h2 + p")
		tagline.each_with_index do |num|
			this_student[:tagline] = num.text
		end

		interests = doc2.css("h3 + p")
		interests.each_with_index do |num|
			this_student[:interests] = num.text
		end

		social_links = doc2.css(".social_icons ul li a")
		social_links.each_with_index do |num|
			this_student[:social_links] ||= []
			this_student[:social_links] << num.attr("href") 
		end ## How to create an array of different social links here, only one shows up

		work = doc2.css(".one_half:first li a")
		work.each_with_index do |num|
			this_student[:work] ||= []
			this_student[:work] << num.text
		end

		education = doc2.css(".last ul.check_style li")
		education.each_with_index do |num|
			this_student[:education] ||= []
			this_student[:education] << num.text
		end

		favorite_tools_companies = doc2.css("figcaption")
 		favorite_tools_companies.each_with_index do |num|
 			this_student[:favorite_companies] ||= []
 			this_student[:favorite_companies] << num.text
		end

		favorite_sites = doc2.css(".one_third p a")
 		favorite_sites.each_with_index do |num|
 			this_student[:favorite_sites] ||= []
 			this_student[:favorite_sites] << num.text

		end

	# puts this_student
		this_student.each do |key, value|
			puts "#{key}: #{value}"
		end
	end
end 




















