#
# MIT License
#
# Copyright (c) 2017 Paul Taylor
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

  class TimeStats

    def initialize(average_size)
      @average_size = average_size
      @start_time = {}
      @process_count = 0
      @elapsed_time = {}
      @total_elapsed = 0
    end


    def process_started(pid)
      @start_time[pid] = Time.now
    end


    def process_ended(pid) 
      elapsed_time = (Time.now - @start_time.delete(pid)) * 1000

      if is_unlimited
        @total_elapsed = @total_elapsed + elapsed_time
        @process_count = @process_count + 1
      else 
        i = @process_count % @average_size
        @process_count = @process_count + 1
        @elapsed_time[i] = elapsed_time
      end
    end


    def average_elapsed_time()
        
      if is_unlimited
        if @process_count == 0
            return 0
        end
        return (@total_elapsed / @process_count).round
       
      else
        size = @elapsed_time.size
        if size == 0
          return 0
        end
        
        total = @elapsed_time.inject(0) { |t, v| 
           t = t + v[1]
        }

        return (total / size).round
      end
    end        


    def is_unlimited
       return @average_size == 0
    end

  end
end