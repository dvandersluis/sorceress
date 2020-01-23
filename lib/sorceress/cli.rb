module Sorceress
  module CLI
    module Colors
      RESET = "\e[0m".freeze # Text Reset

      # Regular Colors
      BLACK = "\e[0;30m".freeze        # Black
      RED = "\e[0;31m".freeze          # Red
      GREEN = "\e[0;32m".freeze        # Green
      YELLOW = "\e[0;33m".freeze       # Yellow
      BLUE = "\e[0;34m".freeze         # Blue
      PURPLE = "\e[0;35m".freeze       # Purple
      CYAN = "\e[0;36m".freeze         # Cyan
      WHITE = "\e[0;37m".freeze        # White

      # Bold
      BOLD_BLACK = "\e[1;30m".freeze       # Black
      BOLD_RED = "\e[1;31m".freeze         # Red
      BOLD_GREEN = "\e[1;32m".freeze       # Green
      BOLD_YELLOW = "\e[1;33m".freeze      # Yellow
      BOLD_BLUE = "\e[1;34m".freeze        # Blue
      BOLD_PURPLE = "\e[1;35m".freeze      # Purple
      BOLD_CYAN = "\e[1;36m".freeze        # Cyan
      BOLD_WHITE = "\e[1;37m".freeze       # White
    end

    def color(msg, color)
      "#{color}#{msg}#{Colors::RESET}"
    end

    def announce(msg)
      $stdout.puts
      $stdout.puts color(msg, Colors::BOLD_GREEN)
    end

    def info(msg)
      $stdout.puts color(msg, Colors::BOLD_BLUE)
    end

    def warning(msg)
      $stderr.puts color(msg, Colors::BOLD_YELLOW)
    end

    def error(msg)
      $stderr.puts color(msg, Colors::BOLD_RED)
    end

    def abort(msg = nil)
      $stderr.puts
      error(msg) if msg
      error('Sorceress was unable to successfully complete the incantation.')
      exit 1
    end

    def result(val)
      emoji = val ? '✅' : '❌'
      $stdout.puts emoji
      val
    end
  end
end
