require 'nokogiri'
require 'open-uri'
require 'sqlite3'

class Student
	attr_accessor :name, :tagline

	def self.create_students_from_urls
		self.collect_students_urls.collect do |url|
			begin
				Student.new(url)
				sleep 1
			rescue Exception => e
				next
			end
		end 
	end

	def self.collect_students_urls
		index_url = "http://students.flatironschool.com/"
		each_student_url = index_url + student_url
		doc = Nokogiri::HTML(open(each_student_url)) # is this ok?
		student_url = doc.css(".columns .one_third a")

		student_url.map {|a| index_url + a.attr('href')}
	end

	def initialize(url)
		self.get_data(url)
	end

	def get_data(url)
		scrape = Scrape.new(url)
		scrape.get_via_scrape

		@name = scrape.name
		@tagline = scrape.tagline

		self.save
	end

	def save
	s = Sql.new(@name, @tagline)
	s.sql_save
	end

end

class Scrape
	attr_accessor :name, :tagline

	def initialize(url)
		@doc = Nokogiri::HTML(open(url))
	end

	def get_via_scrape
		self.get_name
		self.get_tagline
	end

	def get_name
		if @doc.css(".two_third h1")
			@name = @doc.css(".two_third h1").text
		end
		puts @name
	end

	def get_tagline
		if @doc.css("h2 + p")
			@tagline = @doc.css("h2 + p").text
		end
	end

end

class Sql
	attr_accessor :name, :tagline

	@@db = SQLite3::Database.new('students.db')

	def initialize(name, tagline)
		@name = name
		@tagline = tagline
	end

	def self.create_table
		puts "+ creating students table"
		@@db.execute("CREATE TABLE IF NOT EXISTS students (ID INTEGER PRIMARY KEY, name TEXT, tagline TEXT)")
	end

	def sql_save
		puts "+ inserting into students table +"
		@@db.execute("INSERT INTO students (name, tagline) VALUES (?,?)", [@name, @tagline])
	end

end

Sql.create_table
students = Student.create_students_from_urls

