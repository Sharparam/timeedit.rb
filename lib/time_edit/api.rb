require 'httparty'

module TimeEdit
  module API
    SEARCH_ENDPOINT = BASE_URI + '/objects.html'

    # ?fr=t&types=199&sid=3&l=sv_SE
    INFO_ENDPOINT = BASE_URI + '/objects/%d/o.json'

    # ?object=27465&tab=3&p=0.months%2C1.years
    SCHEDULE_ENDPOINT = BASE_URI + '/scheduleschema.json'

    SEARCH_PARAMS = {
      max: 15,
      fr: 't',
      im: 'f',
      sid: 3,
      types: 199,
      partajax: 't'
    }

    INFO_PARAMS = {
      fr: 't',
      types: 199,
      sid: 3
    }

    SCHEDULE_PARAMS = {
      tab: 3,
      p: '0.months,1.years'
    }

    class << self
      def search(course)
        resp = HTTParty.get SEARCH_ENDPOINT, make_opts(course)
        resp.parsed_response
      end

      def info(id)
        resp = HTTParty.get format(INFO_ENDPOINT, id), { query: INFO_PARAMS }
        resp.parsed_response
      end

      def schedule(code)
        resp = HTTParty.get SCHEDULE_ENDPOINT, {
          query: SCHEDULE_PARAMS.merge({ object: code })
        }
        resp.parsed_response
      end

      private

      def make_opts(text)
        { query: SEARCH_PARAMS.merge(search_text: text) }
      end
    end
  end
end
