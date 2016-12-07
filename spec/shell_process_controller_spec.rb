require "spec_helper"

describe "shell_process_controller" do


  it "expects run_process to call exec to run the script" do
    log = double("logfile")
    expect(File).to receive(:open).with("logs/ppool.log", "w").once.and_return(log)
    expect(log).to receive(:write)
    expect(log).to receive(:flush)
    controller = PPool::ShellProcessController.new("ts", "logs", false)

    t = double("time")
    expect(Time).to receive(:now).and_return(t)
    expect(t).to receive(:strftime).with('%Y%m%d%H%M%S').and_return('TS')
    expect(Process).to receive(:pid).and_return(1234)

    expect(Kernel).to receive(:exec).with("ts > logs/process_1234_TS.stdout 2> logs/process_1234_TS.stderr < /dev/null")
    controller.run_process
  end

  it "expects process_end to do nothing if rmlogs is false" do
    log = double("logfile")
    expect(File).to receive(:open).with("logs/ppool.log", "w").once.and_return(log)
    controller = PPool::ShellProcessController.new("ts", "logs", false)

    expect(Dir).to receive(:glob).exactly(0).times
    controller.process_ended(1234, 0)
  end

  it "expects process_end to do nothing if rmlogs is true and status is not 0" do
    log = double("logfile")
    expect(File).to receive(:open).with("logs/ppool.log", "w").once.and_return(log)
    controller = PPool::ShellProcessController.new("ts", "logs", true)

    expect(Dir).to receive(:glob).exactly(0).times
    controller.process_ended(1234, 1)
    controller.process_ended(4321, 2)
  end

  it "expects process_end to remove logs if rmlogs is true and status is 0" do
    log = double("logfile")
    expect(log).to receive(:write).at_least(:once)
    expect(log).to receive(:flush).at_least(:once)
    expect(File).to receive(:open).with("logs/ppool.log", "w").once.and_return(log)
    controller = PPool::ShellProcessController.new("ts", "logs", true)

    f1 = double("file1")
    expect(Dir).to receive(:glob).with("logs/process_1234_*.stdout").once.and_yield(f1)
    f2 = double("file2")
    expect(Dir).to receive(:glob).with("logs/process_1234_*.stderr").once.and_yield(f2)

    expect(File).to receive(:delete).with(f1).once
    expect(File).to receive(:delete).with(f2).once
    controller.process_ended(1234, 0)

  end


end
