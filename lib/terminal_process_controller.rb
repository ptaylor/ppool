#
# MIT License
#
# Copyright (c) 2016, 2017 Paul Taylor
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

require 'io/console'
require 'io/wait'

module PPool

  class TerminalProcessController < TimedProcessController

    def initialize(size, delay, script, time, logdir, rmlogs)
      super(size, delay, script, time, logdir, rmlogs)
      @msg = ""
      @last_stats = {}
      @count = 0

      Signal.trap('INT') do 
	terminate
      end

    end


    def progress(stats)

       if stats != @last_stats
	 if @count % 20 == 0

	    puts "----------------------------------------------------------"
	    puts " Time     | Size  Active  Started Ended Errors Avg Elapsed"
	    puts "=========================================================="

	 end
	 puts(" %s | %4d   %4d   %4d   %4d   %4d   %4d\n" % [time_running, @size, stats[:active_processes], stats[:processes_started], stats[:processes_ended], stats[:errors], stats[:avg_elapsed_time]])
	 @last_stats = stats
	 @count = @count + 1
       end

       process_keys

      if finishing?
	if stats[:active_processes] == 0
	  finished
	end
      end
    end

    def process_keys

      case read_ch
      when '+'
        inc_size
	@last_stats = {}
	puts ""
      when '-'
        dec_size
	@last_stats = {}
	puts ""
      when 'q', 'Q'
        finishing
	@last_stats = {}
	puts ""
      when 'x', 'X'
	terminate
      end

    end

    def read_ch
      begin
	system("stty raw") 
	if $stdin.ready?
	  c = $stdin.getc
	  return c.chr
	end
      ensure
	system("stty -raw")
      end
      return nil
    end


    def terminate
      system("stty -raw")
      puts ""
      exit(0)
    end

  end

end
