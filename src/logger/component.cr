require "./severity"

class Logger
  class Component
    getter logger : Base
    getter name : String

    def initialize(@name, @logger)
    end

    {% for level in Severity.constants %}
      def {{ level.downcase.id }}(*, time = Time.now, line_number = __LINE__, filename = __FILE__, &message : -> String)
        @logger.log Entry.new(message, Severity::{{ level }}, name, time, line_number, filename)
      end

      def {{ level.downcase.id }}(message, *, time = Time.now, line_number = __LINE__, filename = __FILE__)
        @logger.log Entry.new(message, Severity::{{ level }}, name, time, line_number, filename)
      end
    {% end %}
  end
end
