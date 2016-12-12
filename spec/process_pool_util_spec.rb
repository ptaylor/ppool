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

require "spec_helper"

describe "process_pool_util" do


  [
	{ :timespec => '01', :seconds => 1},
	{ :timespec => '59', :seconds => 59},
	{ :timespec => '1:05', :seconds => 65},
	{ :timespec => '14:00', :seconds => 840},
	{ :timespec => '1:00:00', :seconds => 3600},
        { :timespec => '24:59:59', :seconds => 89999},

  ].each do |data| 
    it "convert_time_to_secs converts #{data[:timespec]} to #{data[:seconds]}" do 

      expect(PPool.convert_time_to_secs(data[:timespec])).to eq(data[:seconds])

    end
  end

  [ 
    '60',
    '05:03:04:01',
    '60:01',
    '25:00:00',
    '-1'
  ].each do |data| 
    it "convert_time_to_secs raises ArgumentError for #{data}" do 

      expect { PPool.convert_time_to_secs(data) }.to raise_error(ArgumentError)

    end
  end
end