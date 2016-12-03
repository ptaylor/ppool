
require 'curses'

class CursesProcessController < ShellProcessController

  def initialize(size, script, logdir)
    super(script, logdir)
    @finishing = false
    @finished = false
    @size = size
    @msg = ""
    @last_stats = {}
    init_window
  end

  def running?
    return !@finished
  end

  def num_processes
    return @size
  end


  def process_started(pid, num_processes) 
  end

  def process_ended(pid, status)
    #draw_window
  end

  def progress(stats)

    @last_stats = stats

    draw_window

    @win.attron(Curses.color_pair(3)|Curses::A_BOLD) {
      @win.setpos(2 , 5)
      @win.addstr("Time      #{time_running}")
      @win.setpos(3 , 5)
      @win.addstr("Size      #{@size}")
      @win.setpos(4 , 5)
      @win.addstr("Running   #{stats[:active_processes]}")
      @win.setpos(5 , 5)
      @win.addstr("Started   #{stats[:processes_started]}")
      @win.setpos(6 , 5)
      @win.addstr("Ended     #{stats[:processes_ended]}")
      @win.setpos(7 , 5)
      @win.addstr("Errors    #{stats[:errors]}")
      @win.setpos(8 , 5)
      @win.addstr("Logs      #{@logdir}")
      @win.setpos(9 , 5)
      @win.addstr("          #{@msg}")
    }

    process_keys

    if @finishing
      info "finishing #{stats[:active_processes]}"
      if stats[:active_processes] == 0
        @finished = true
      end
    end
    @win.refresh

  end

  def delay
    return 0.1
  end


  def init_window
     
     info "init_window"

     Curses.init_screen
     Curses.start_color
     Curses.init_pair(1, Curses::COLOR_BLUE, Curses::COLOR_BLACK) 
     Curses.init_pair(2, Curses::COLOR_RED, Curses::COLOR_BLACK) 
     Curses.init_pair(3, Curses::COLOR_WHITE, Curses::COLOR_BLACK) 

     #Curses.noecho
     #Curses.cbreak
     #Curses.nonl 
     #Curses.curs_set(0)

     lines = Curses.lines
     cols = Curses.cols

     height = 12
     width = 70

     @win = Curses::Window.new(height, width, 2, 2)
     #@win.keypad = true
     #@win.nodelay = true

     draw_window end

  def draw_window
     @win.clear
     @win.attron(Curses.color_pair(1)|Curses::A_NORMAL) {
       @win.box('|', '-')
     }
     
  end

  def finished
    info "finished"
    Curses.close_screen 

    puts ""
    puts "Time     #{time_running}"
    puts "Size     #{@size}"
    puts "Running  #{@last_stats[:active_processes]}"
    puts "Started  #{@last_stats[:processes_started]}"
    puts "Ended    #{@last_stats[:processes_ended]}"
    puts "Errors   #{@last_stats[:errors]}"
    puts "Logs     #{@logdir}"
    puts "         #{@msg}"
    puts ""

    exit(0)
  end


  def process_keys 

     # Need to reset keyboard handling after a process
     # has been forked.
     Curses.noecho
     Curses.cbreak
     Curses.nonl 
     Curses.curs_set(0)
     @win.keypad = true
     @win.nodelay = true

    case @win.getch
    when '+', Curses::KEY_UP
      @size = @size + 1
    when '-', Curses::KEY_DOWN
      @size = @size - 1
      if @size < 0
        @size = 0
      end
    when 'q', 'Q'
      @size = 0
      @finishing = true
    when 'x', 'X'
      finished
    end
  end 


end

