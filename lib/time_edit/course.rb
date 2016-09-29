require 'nokogiri'

module TimeEdit
  class Course
    attr_reader :id

    attr_reader :name

    attr_reader :code

    attr_reader :uid

    attr_reader :semester

    attr_reader :start

    attr_reader :end

    attr_reader :schedule

    def initialize(fields)
      @id = fields[:id]
      @name = fields[:name]
      @code = fields[:ccode]
      @uid = fields[:scode]
      @semester = fields[:semester]
      @start = fields[:start]
      @end = fields[:end]

      @schedule = Schedule.new @uid
    end

    def self.search(code)
      result = TimeEdit::API.search code
      parse_search result
    end

    def self.find(id)
      info = TimeEdit::API.info id
      self.new id: id, ccode: info['Kurskod'], scode: info['Anmkod'],
               name: info['Benämning(E)'], semester: info['Starttermin'],
               start: info['Startvecka'].to_i, end: info['Slutvecka'].to_i
    end

    private

    def self.parse_search(content)
      doc = Nokogiri::HTML(content)
      courses = doc.css 'div.searchObject'
      courses.map do |course|
        {
          id: course.attr('data-idonly').to_i,
          name: course.attr('data-name')
        }
      end
    end
  end
end
