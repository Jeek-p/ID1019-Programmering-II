defmodule Color do

  def convert(depth, max) do
    red(depth, max)
  end


  def red(d, m) do

    f = d/m   #fraction

    a = f*4   #floating point 0-4.0

    x = trunc(a) # truncate a så det blir avrundat mellan 0-4

    y = trunc(255*(a-x)) # offset

    case x do

      0 -> {:rgb, y, 0, 0}    # black - red
      1 -> {:rgb, 155, y, 0}  # red - yellow
      2 -> {:rgb, 255-y, 255, 0}  # yellow - green
      3 -> {:rgb, 0, 200, y}  # green - green/blue
      4 -> {:rgb, 0, 255-y, 255}  # green/blue -> blue

    end
  end

    def blue(d, m) do

      f = d/m   #fraction

      a = f*4   #floating point 0-4.0

      x = trunc(a) # truncate a så det blir avrundat mellan 0-4

      y = trunc(255*(a-x)) # offset

      case x do

        0 -> {:rgb, 0, 0, y}    # black - blue
        1 -> {:rgb, 0, y, 255}  # blue - green/blue
        2 -> {:rgb, 0, 255, 255-y}  # green/blue - green
        3 -> {:rgb, y, 255, 0}  # green - yellow
        4 -> {:rgb, 255, 255-y, 0}  # yellow - red

      end
  end
end
