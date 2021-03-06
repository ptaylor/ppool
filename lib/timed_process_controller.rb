#
# MIT License
#
# Copyright (c) 2016 Paul Taylor
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

  class TimedProcessController < ShellProcessController

    def initialize(size, delay, script, time, logdir, rmlogs)
      super(script, logdir, rmlogs)

      @size = size
      @time = time
      @finishing = false
      @finished = false
      @size = size
      @delay = delay
      @msg = ""

      Signal.trap('INT') do 
	finished
      end

    end

    def running?
      if @time != nil && time_running_secs > @time
        @size = 0
        @finishing = true
      end
      return !@finished
    end

    def num_processes
      return @size
    end

    def process_started(pid, num_processes) 
    end

    def delay
      return @delay / 1000.0
    end

    def inc_size
      @size = @size + 1
    end

    def dec_size
      @size = @size - 1
      if @size < 0
        @size = 0
      end
    end

    def set_size(s)
      @size = s
    end

    def finishing
      @size = 0
      @finishing = true
    end

    def finishing?
      return @finishing
    end

    def finished
      @finished = true
    end

  end

end
