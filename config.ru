require "rubygems"
require "bundler/setup"

require "json"
require "scrambler"


class API
  include Scrambler

  PUZZLES = { "2x2x2"    => TwoByTwo,
              "3x3x3"    => ThreeByThree,
              "4x4x4"    => FourByFour,
              "5x5x5"    => FiveByFive,
              "6x6x6"    => SixBySix,
              "7x7x7"    => SevenBySeven,
              "clock"    => Clock,
              "megaminx" => Megaminx,
              "pyraminx" => Pyraminx,
              "square-1" => Square1 }

  def call(env)
    x, puzzle, n = env["PATH_INFO"].split("/")
    n = n.nil? ? 5 : n.to_i
    n = 1000 if n > 1000
    scrambles = (1..n.to_i).map do
      PUZZLES[puzzle.downcase].new.scramble
    end
    [200, {"Content-Type" => "application/json"}, [JSON.generate(scrambles)]]
  end
end

run API.new