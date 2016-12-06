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

  class ProcessPool

    def initialize(controller)
      @controller = controller
      @active_processes = 0
      @started_count = 0
      @ended_count = 0
      @errors = 0
    end


    def run

      progress

      while @controller.running?

	num_processes = @controller.num_processes

	# Create processes
	while @active_processes < num_processes

	  @controller.info "num_proceses #{num_processes}, active_processes #{@active_processes}; forking"

	  pid = Process.fork do
	    @controller.run_process
	  end


	  @active_processes = @active_processes + 1
	  @controller.process_started(pid, @active_processes)
	  @started_count = @started_count + 1

	  progress
	end

	doneWaiting = false
	while ! doneWaiting 
	 begin
	   pidStatus = Process.wait2(-1, Process::WNOHANG)
	   if pidStatus != nil
	     @controller.process_ended(pidStatus[0], pidStatus[1].exitstatus)
	     @active_processes = @active_processes - 1 
	     @ended_count = @ended_count + 1
	     if pidStatus[1].exitstatus != 0 
	       @errors = @errors + 1
	     end
	   else 
	     doneWaiting = true
	   end
	 rescue => e
	   doneWaiting = true
	   #@controller.info "Exception #{e}"
	 end
       end

       progress

       sleep @controller.delay

      end
      @controller.finished

    end

    def progress

       @controller.progress({
	  :active_processes => @active_processes, 
	  :processes_started => @started_count, 
	  :processes_ended => @ended_count, 
	  :errors => @errors
       })
    end

  end

end