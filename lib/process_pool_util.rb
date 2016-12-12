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
  extend self

  #class ProcessPoolUtil extend self

    def convert_time_to_secs(timespec)

      s = 0
      m = 0
      h = 0

      parts = timespec.split(':')
      case parts.length
	when 1
	  s = parts[0].to_i
	when 2
	  s = parts[1].to_i
	  m = parts[0].to_i
	when 3
	  s = parts[2].to_i
	  m = parts[1].to_i
	  h = parts[0].to_i

	else
	  raise ArgumentError.new('invalid timespec; too many parts')
      end

      if s < 0 || s > 59
	raise ArgumentError.new('invalid timespec; seconds are invalid')
      end

      if m < 0 || m > 59
	raise ArgumentError.new('invalid timespec; minutes are invalid')
      end
      if h < 0 || h > 24
	raise ArgumentError.new('invalid timespec; hours are invalid')
      end

      return h * (60 * 60) + m * 60 + s

    end


  #end
end