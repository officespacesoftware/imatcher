module Imatcher
  module Modes # :nodoc:
    require 'imatcher/modes/base'

    # Compare pixels by values.
    # Resulting image contains per-channel differences.
    class RGB < Base
      def pixels_equal?(a, b)
        a == b
      end

      def update_result(a, b, x, y)
        @result.diff << [a, b, x, y]
      end

      def background(bg)
        Image.new(bg.width, bg.height, BLACK)
      end

      def create_diff_image(bg, diff_image)
        bg.to_grayscale.compose!(diff_image, 0, 0)
      end

      def pixels_diff(d, a, b, x, y)
        d[x, y] = rgb(
          (r(a) - r(b)).abs,
          (g(a) - g(b)).abs,
          (b(a) - b(b)).abs
        )
      end
    end
  end
end
