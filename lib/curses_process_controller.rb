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

require 'curses'

class CursesProcessController < ShellProcessController

  def initialize(size, delay, script, logdir, rmlogs)
    super(script, logdir, rmlogs)
    @finishing = false
    @finished = false
    @size = size
    @delay = delay
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
      if stats[:active_processes] == 0
        @finished = true
      end
    end
    @win.refresh

  end

  def delay
    return @delay / 1000
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

