class Student
  # Student class shouldn't know about the Scraper class
  # shouldn't call on the Scraper class in any of its methods or
  # take in the Scraper class itself as an argument
  
  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  # Takes in an arg of a hash and sets new student's attrs using k/v pairs of hash 
  def initialize(student_hash)
    # Metaprogramming + Mass assignment
    # .send calls method name that's is key's name, with an arg of the value 
    student_hash.each {|key, value| self.send(("#{key.to_s}="), value)}
    
    # Same as:
      # @name = student_hash[:name]
      # @location = student_hash[:location]
      # @profile_url = student_hash[:profile_url]
    
    # Every time an instance of the class is initialized
    # Adds new student to the Student class' collection of all existing students
    # stored in `@@all` class variable
    @@all << self
  end

  # Uses Scraper class to create new students w/ correct name + location
  def self.create_from_collection(students_array)
    ## Iterate over array of hashes and create a 
    # new individual student using each hash
    students_array.each do |student_hash|
      Student.new(student_hash)
    end
  end

  # Uses Scraper class to get a hash of a given students attributes and 
  # uses that hash to set additional attributes for that student. 
  def add_student_attributes(attributes_hash)
    # Iterate over the given hash and use meta-programming to
    # dynamically assign student attr per the key/value pairs
    
    attributes_hash.each { |key, value| self.send(("#{key.to_s}="), value)}
    
  end

  # Returns the class variable @@all
  def self.all
    @@all 
  end
end