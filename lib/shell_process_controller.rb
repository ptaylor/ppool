class ShellProcessController < BasicProcessController

  def initialize(script, logdir)
    super()
    @script = script
    @logdir = logdir
    @log = File.open("#{logdir}/ppool.log", 'w')

  end

  def run_process

    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    pid = Process.pid
 
    stdout = "#{@logdir}/process_#{pid}_#{timestamp}.stdout"
    stderr = "#{@logdir}/process_#{pid}_#{timestamp}.stderr"
    stdin = "/dev/null"

    info "running #{@script} output to #{stdout}"
    exec("#{@script} > #{stdout} 2> #{stderr} < #{stdin}")

  end

  def info(m)
    @log.write("#{m}\n")
    @log.flush
  end

end
