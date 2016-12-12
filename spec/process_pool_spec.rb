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

describe "process_pool" do

  before do
    @controller = double('controller')
    @process_pool = PPool::ProcessPool.new(@controller)
  end

  it "expects progress to call controller with stats" do
    log = double("logfile")
    expect_progress
    @process_pool.progress

  end
  
  it "expects run to return if the controller is not running" do
    expect(@controller).to receive(:running?).once.and_return(false)
    expect_progress
    expect(@controller).to receive(:terminate).once
    @process_pool.run

  end

  it "expects run create and wait for processes until the controller stops running" do

    expect(@controller).to receive(:info).at_least(:once)
    expect(@controller).to receive(:running?).and_return(true, false)
    expect(@controller).to receive(:num_processes).and_return(1)
    expect_progress
    expect(@controller).to receive(:terminate).once
    expect(Process).to receive(:fork).and_return(1234)
    expect(@controller).to receive(:process_started).with(1234, 1)
    expect(@controller).to receive(:delay).once.and_return(0.25)
    expect(Kernel).to receive(:sleep).once.with(0.25)

    status = double("pidStatus")
    expect(status).to receive(:exitstatus).and_return(2).at_least(:once)
    expect(Process).to receive(:wait2).once.with(-1, Process::WNOHANG).and_return([4321, status])
    expect(@controller).to receive(:process_ended).with(4321, 2)

    expect(Process).to receive(:wait2).once.with(-1, Process::WNOHANG).and_return(nil)
    
    @process_pool.run

  end

  def expect_progress()

    expect(@controller).to receive(:progress).at_least(:once) do |data|
      expect(data[:active_processes]).to be >= 0
      expect(data[:processes_started]).to be >= 0
      expect(data[:processes_ended]).to be >= 0
      expect(data[:errors]).to be >= 0
    end

  end

end