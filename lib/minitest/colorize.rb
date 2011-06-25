require "minitest/colorize/version"
require "minitest/unit"

module MiniTest
  class Colorize
    attr_accessor :io

    def initialize(io)
      self.io = io
    end

    def print(string = nil)
      return io.print if string.nil?

      if color = colors[string]
        io.print tint(color, string)
      else
        io.print string
      end
    end

    def puts(string = nil)
      return io.puts if string.nil?

      if string =~ /(\d+) tests, (\d+) assertions, (\d+) failures, (\d+) errors, (\d+) skips/
        color = if $3 != '0'
                  colors['F']
                elsif $4 != '0'
                  colors['E']
                elsif $5 != '0'
                  colors['S']
                else
                  colors['.']
                end

        io.puts tint(color, string)
      else
        io.puts string
      end
    end

    def method_missing(method, *args, &block)
      io.send(method, *args, &block)
    end

    protected

    def tint(color, string)
      "#{color}#{string}#{clear}"
    end

    def colors
      { "F" => "\e[31m", "E" => "\e[31m", "S" => "\e[33m", "." => "\e[32m" }
    end

    def clear
      "\e[0m"
    end
  end
end

MiniTest::Unit.output = MiniTest::Colorize.new(MiniTest::Unit.output)
