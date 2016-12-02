
require 'curses'

class CursesProcessController < SpawningProcessController

  def initialize(size, script, logdir)
    super(script, logdir)
    @quit = false
    @size = size
    @time_started = Time.new.to_i
    init_window
  end

  def running?
    return !@quit
  end

  def num_processes
    return @size
  end


  def process_started(pid, num_processes) 

  end

  def process_ended(pid, status)
    #@win.clear
  end

  def progress(stats)

    draw_window
    secs = Time.new.to_i
    @win.attron(Curses.color_pair(3)|Curses::A_BOLD) {
      @win.setpos(2 , 5)
      @win.addstr("Time #{secs - @time_started}")
      @win.setpos(3 , 5)
      @win.addstr("Size #{@size}")
      @win.setpos(4 , 5)
      @win.addstr("Running #{stats[:active_processes]}")
      @win.setpos(5 , 5)
      @win.addstr("Started #{stats[:processes_started]}")
      @win.setpos(6 , 5)
      @win.addstr("Ended #{stats[:processes_ended]}")
      @win.setpos(7 , 5)
      @win.addstr("Errors #{stats[:errors]}")
    }

    @win.refresh

    #puts "!!! active #{stats[:active_processes]} started #{stats[:processes_started]} ended #{stats[:processes_ended]} errors #{stats[:errors]}"
  end

   def init_window
     
     Curses.init_screen
     Curses.start_color
     Curses.init_pair(1, Curses::COLOR_BLUE, Curses::COLOR_BLACK) 
     Curses.init_pair(2, Curses::COLOR_RED, Curses::COLOR_BLACK) 
     Curses.init_pair(3, Curses::COLOR_WHITE, Curses::COLOR_BLACK) 

     Curses.noecho
     Curses.cbreak
     Curses.nonl 
     Curses.curs_set(0)

     lines = Curses.lines
     cols = Curses.cols

     height = 10
     width = 50

     @win = Curses.stdscr
     @win = Curses::Window.new(height, width, 10, 2)
     @win.keypad = true
     @win.nodelay = true

     draw_window

  end

  def draw_window
     @win.clear
     @win.attron(Curses.color_pair(1)|Curses::A_NORMAL) {
       @win.box('|', '-')
     }
     
  end

  def delay
    return 0.1
  end

end

