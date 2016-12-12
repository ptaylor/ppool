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

module PPool

  class BasicProcessController 

    def initialize
      @time_started = Time.now.to_i
    end

    def running?
      return true
    end

    def num_processes
      return 1
    end

    def process_started(pid, num_processes) 
      puts "> process started #{pid}; num_processes #{num_processes}"
    end

    def run_process 
      info "#{Process.pid} running"
      exit 0
    end

    def process_ended(pid, status)
      puts "> process ended - pid #{pid}, status #{status}"
    end

    def progress(stats)
      puts "> active #{stats[:active_processes]} started #{stats[:processes_started]} ended #{stats[:processes_ended]} errors #{stats[:errors]}"
    end

    def delay
      return 0.1
    end

    def info(m)
      puts "+ #{m}"
    end

    def time_running
      secs = time_running_secs
      hours = (secs / (60 * 60)) % 24
      mins = (secs / 60) % 60
      secs = secs % 60

      return "%.2d:%.2d:%.2d" % [hours, mins,secs]
    end

    def time_running_secs
      Time.now.to_i - @time_started
    end

  end

end
