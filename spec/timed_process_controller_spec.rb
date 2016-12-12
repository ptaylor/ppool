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

describe "timed_process_controller" do

  before do
    log = double("logfile")
    expect(File).to receive(:open).with("logs/ppool.log", "w").once.and_return(log)
    expect(Time).to receive(:now).and_return("100000").once
    @controller = PPool::TimedProcessController.new(5, 456, 'ts', 150, 'logs', false)
  end


  it "increments size when inc_size is called" do
   
    expect(@controller.num_processes).to eq(5)

    @controller.inc_size
    expect(@controller.num_processes).to eq(6)

    @controller.inc_size
    expect(@controller.num_processes).to eq(7)

    @controller.inc_size
    expect(@controller.num_processes).to eq(8)

  end

  it "decrements size when dec_size is called" do
   
    expect(@controller.num_processes).to eq(5)

    @controller.dec_size
    expect(@controller.num_processes).to eq(4)

    @controller.dec_size
    expect(@controller.num_processes).to eq(3)

    @controller.dec_size
    expect(@controller.num_processes).to eq(2)

    @controller.dec_size
    expect(@controller.num_processes).to eq(1)

    @controller.dec_size
    expect(@controller.num_processes).to eq(0)

    @controller.dec_size
    expect(@controller.num_processes).to eq(0)

  end

  it "returns delay in seconds" do
    expect(@controller.delay).to eq(0.456)
  end


  it "sets size to 0 when finishing" do

     expect(@controller.num_processes).to eql(5)
     expect(@controller.finishing?).to be_falsey()

     @controller.finishing

     expect(@controller.num_processes).to eql(0)
     expect(@controller.finishing?).to be_truthy()

  end

  
  it "sets running? to false when finished" do

    expect(Time).to receive(:now).and_return("100000").once
    expect(@controller.running?).to be_truthy()
 
    expect(Time).to receive(:now).and_return("100000").once
    @controller.finished

    expect(@controller.running?).to be_falsey()

  end

  it "sets finishing? to true when time has run out" do

    expect(Time).to receive(:now).and_return("100000").once
    expect(@controller.running?).to be_truthy()
    expect(@controller.num_processes).to eq(5)
    expect(@controller.finishing?).to be_falsey()

    expect(Time).to receive(:now).and_return("100149").once
    expect(@controller.running?).to be_truthy()
    expect(@controller.num_processes).to eq(5)
    expect(@controller.finishing?).to be_falsey()

    expect(Time).to receive(:now).and_return("100151").once
    expect(@controller.running?).to be_truthy()
    expect(@controller.num_processes).to eq(0)
    expect(@controller.finishing?).to be_truthy()
    
  end

end
