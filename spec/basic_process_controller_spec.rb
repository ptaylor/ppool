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

describe "basic_process_controller" do

  before do
    @controller = PPool::BasicProcessController.new
  end

  it "always returns true for running?" do
    expect(@controller.running?).to be true
  end

  it "always returns 1 for num_processes" do
    expect(@controller.num_processes).to eq(1)
  end

  it "always returns 0.1 for delay" do
    expect(@controller.delay).to eq(0.1)
  end

  [
    {:before => 0, :after => 59, :expected => "00:00:59" },
    {:before => 0, :after => 123, :expected => "00:02:03" },
    {:before => 0, :after => 4343, :expected => "01:12:23" },
    {:before => 40030, :after => 9931333, :expected => "11:35:03" },
  ].each do |data| 
    it "time_running returns correct data using #{data}" do 
      allow(Time).to receive(:now).and_return(data[:before])
      @controller = PPool::BasicProcessController.new

      allow(Time).to receive(:now).and_return(data[:after])
      expect(@controller.time_running).to eq(data[:expected])
    end
  end

  it "run_process should call exit" do 
    expect { @controller.run_process }.to raise_error(SystemExit)
  end

end
