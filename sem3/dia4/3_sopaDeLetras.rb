class Cuadricula
  def formato(str,_player_color,_background)
    require "colorize"
    str.ljust(3).colorize(_player_color).colorize( :background => _background)
  end
  def background(_background)
    _background == :cyan ? :white : :cyan
  end
  def player_color(_player_color)
    _player_color == :black ? :red : :black
  end
end

class Board < Cuadricula
  def initialize(cols,a)
    @array_tomatch = a[0]
    @cols = cols
    @rows = a[1].length / cols - 1
    format_str(complete_board(a[1]))
  end

  def to_s
    "try to print a board, what does this method do?"
    #format_str(@board_template[1]).inject {|memo,sum| memo + sum +["\n"] }.join # La ultima linea no suma salto de linea
    out = ""
    @tbls[:formated].each {|line| out += line.join + "\n"}
    out
  end
  def match_toarray!
    match2 = {a: [], col: []}
    # get vertical coords
    for i in 0..@cols
      match2[:a] << (0..@rows).to_a.product([i])
      match2[:col] << i
    end

    word = {str: [], array: []}
    result = []

    match2[:a].each do |line|

      line.each do |a,b|
        word[:str] << @tbls[:notformated][a][b]
        word[:array] << [a] + [b]
      end

      result << kick_badchars(word) if include?(word[:str].join) == true
      word = {str: [], array: []}
    end

    result.flatten(1).each do |x,y|
      @tbls[:formated][x][y] = formato(@tbls[:formated][x][y],:white,:black)
    end
  end

  def kick_badchars(word)
    result = []
    @array_tomatch.each do |original|
      if word[:str].join.include?(original)

        original_array = original.split("")
        start_from = word[:str].join.index(original[0])
        index_original = 0
        for index_word in start_from..word[:str].join.length - 1
          result << word[:array][index_word] if original_array[index_original] == word[:str][index_word]
          index_original += 1
        end
      elsif word[:str].join.include?(original.reverse)
        original.reverse!
        original_array = original.split("")
        start_from = word[:str].join.index(original[0])
        index_original = 0
        for index_word in start_from..word[:str].join.length - 1
          result << word[:array][index_word] if original_array[index_original] == word[:str][index_word]
          index_original += 1
        end
      end
    end
    result
  end

  def include?(word)
    @array_tomatch.any? {|w| word.include?(w) || word.reverse.include?(w)}
  end
  def format_str(s)
    row_formated = []
    tbl_formated = []
    tbl_notformated = []
    row_notformated = []
    _background = :cyan
    _player_color = :black
    s_ln = s.length - 1

    (0..s_ln).step(@cols) do |line_break|
      s.slice(line_break,@cols).split("").each do |char|

        _background = background(_background)
        _player_color = player_color(_player_color)

        row_formated << formato(char, _player_color, _background) #+ "\n"
        row_notformated << char

      end
      tbl_formated << row_formated
      tbl_notformated << row_notformated
      row_formated = []
      row_notformated = []
    end
    @tbls = {formated: tbl_formated, notformated: tbl_notformated}
  end

  private

  def complete_board(board_line)
    #Este método debe rellenar un tablero incompleto, en otras palabras cambiar las "x" por letras random.
    shuffle = ("A".."Z").to_a.shuffle
    board = board_line.split("")
    while board.include?("X") == true
        board[board.index("X")] = shuffle.sample
    end
    board_line = board.join
  end

end

board = Board.new(5,[["POEMA", "CANCION", "RONDAS", "RIMAS"],"POEMAXCXXXXAXXSXNXAAXCMXDXIXXNROXXOXNXXR"])
puts board
board.match_toarray!
puts " "
puts board
