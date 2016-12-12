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

  class ShellProcessController < BasicProcessController

    def initialize(script, logdir, rmlogs)
      super()
      @script = script
      @logdir = logdir
      @rmlogs = rmlogs
      @log = File.open("#{logdir}/ppool.log", 'w')
      @stdout_log = {}
      @stderr_log = {}

    end

    def run_process

      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      pid = Process.pid

      stdout = "#{@logdir}/process_#{pid}_#{timestamp}.stdout"
      stderr = "#{@logdir}/process_#{pid}_#{timestamp}.stderr"
      stdin = "/dev/null"

      info "running #{@script} output to #{stdout}"
      Kernel.exec("#{@script} > #{stdout} 2> #{stderr} < #{stdin}")

    end

    def process_ended(pid, status)
      if @rmlogs && status == 0    
	      delete_log_file(pid, 'stdout')
	      delete_log_file(pid, 'stderr')
      end
    end

    def info(m)
      @log.write("#{m}\n")
      @log.flush
    end


    def delete_log_file(pid, suffix)
      begin
        Dir.glob("#{@logdir}/process_#{pid}_*.#{suffix}") { |file|
	        info "deleting log file #{file} for process #{pid}"
	        File.delete(file)
	      }
      rescue => e
        info "error deleting log file for process #{pid}: #{e}"
      end

    end

  end

end