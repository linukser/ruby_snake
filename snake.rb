#!/usr/bin/ruby

# This file is part of ruby_snake.
# ruby_snake is licensed under the MIT License.
# See the LICENSE file in the project root for more information.

require 'ncurses'

class SnakeGame
  def initialize
    Ncurses.initscr
    Ncurses.cbreak
    Ncurses.noecho
    Ncurses.curs_set(0)
    Ncurses.timeout(100)
    Ncurses.keypad(Ncurses.stdscr, true)

    @height, @width = [], []
    Ncurses.getmaxyx(Ncurses.stdscr, @height, @width)
    @height = @height[0]
    @width = @width[0]

    @snake = [[@height / 2, @width / 2]]
    @direction = 'RIGHT'
    @food = [rand(@height), rand(@width)]
    @score = 0
  end

  def run
    loop do
      render
      input = Ncurses.getch

      case input
      when Ncurses::KEY_UP
        @direction = 'UP' unless @direction == 'DOWN'
      when Ncurses::KEY_DOWN
        @direction = 'DOWN' unless @direction == 'UP'
      when Ncurses::KEY_LEFT
        @direction = 'LEFT' unless @direction == 'RIGHT'
      when Ncurses::KEY_RIGHT
        @direction = 'RIGHT' unless @direction == 'LEFT'
      when 'q'.ord
        break
      end

      move_snake
      if game_over?
        break
      end

      if @snake.first == @food
        @score += 1
        @food = [rand(@height), rand(@width)]
      else
        @snake.pop
      end
    end
    close_game
  end

  private

  def render
    Ncurses.clear
    @snake.each do |segment|
      Ncurses.mvaddch(segment[0], segment[1], '#'.ord)
    end
    Ncurses.mvaddch(@food[0], @food[1], 'O'.ord)
    Ncurses.mvprintw(0, 2, "Score: #{@score}")
    Ncurses.refresh
  end

  def move_snake
    head = @snake.first.dup
    case @direction
    when 'UP'
      head[0] -= 1
    when 'DOWN'
      head[0] += 1
    when 'LEFT'
      head[1] -= 1
    when 'RIGHT'
      head[1] += 1
    end
    @snake.unshift(head)
  end

  def game_over?
    head = @snake.first
    return true if head[0] < 0 || head[0] >= @height || head[1] < 0 || head[1] >= @width
    return true if @snake[1..-1].include?(head)
    false
  end

  def close_game
    Ncurses.endwin
    puts "Game Over! Your score is #{@score}."
  end
end

SnakeGame.new.run


