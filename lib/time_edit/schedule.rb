module TimeEdit
  class Schedule
    METADATA_MAPPING = {
      'Lokal/Plats' => :location,
      'Lärare' => :lecturer,
      'Kurs/Grupp' => :group,
      'Information' => :info
    }

    attr_reader :headers

    attr_reader :data

    def initialize(code)
      data = TimeEdit::API.schedule code

      @headers = data['columnheaders']
      @data = []

      add_reservations data['reservations']
    end

    private

    def add_reservations(reservations)
      reservations.each { |reservation| add_reservation reservation }
    end

    def add_reservation(reservation)
      start = "#{reservation['startdate']} #{reservation['starttime']}"
      stop = "#{reservation['enddate']} #{reservation['endtime']}"
      @data << {
        id: reservation['id'],
        start: parse_time(start),
        end: parse_time(stop),
        data: parse_metadata(reservation['columns'])
      }
    end

    def parse_time(time)
      DateTime.parse time
    end

    def parse_metadata(data)
      {}.tap do |result|
        data.each_with_index do |v, i|
          key = METADATA_MAPPING[@headers[i]] || @headers[i]
          result[key] = v
        end
      end
    end
  end
end
