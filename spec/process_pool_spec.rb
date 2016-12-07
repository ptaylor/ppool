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
    expect(@controller).to receive(:finished).once
    @process_pool.run

  end

  it "expects run create and wait for processes until the controller stops running" do

    expect(@controller).to receive(:info).at_least(:once)
    expect(@controller).to receive(:running?).and_return(true, false)
    expect(@controller).to receive(:num_processes).and_return(1)
    expect_progress
    expect(@controller).to receive(:finished).once
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