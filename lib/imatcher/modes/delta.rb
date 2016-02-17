module Imatcher
  module Modes # :nodoc:
    require 'imatcher/modes/base'

    # Compare pixels using Delta E distance.
    class Delta < Base
      def initialize(threshold: 0.0)
        @threshold = threshold
        @result = Result.new(self, threshold)
        @delta_score = 0.0
      end

      private

      def pixels_equal?(a, b)
        a == b
      end

      def update_result(a, b, x, y)
        d = euclid(a, b) / (MAX * Math.sqrt(3))
        @result.diff << [a, b, x, y, d]
        @delta_score += d
      end

      def background(bg)
        Image.new(bg.width, bg.height, WHITE).with_alpha(0)
      end

      def euclid(a, b)
        Math.sqrt(
          (r(a) - r(b))**2 +
          (g(a) - g(b))**2 +
          (b(a) - b(b))**2
        )
      end

      def create_diff_image(bg, diff_image)
        bg.to_grayscale.compose!(diff_image, 0, 0)
      end

      def pixels_diff(d, *_args, x, y, a)
        d[x, y] = rgba(MAX, 0, 0, (a * MAX).round)
      end

      def score
        @delta_score / result.image.pixels.length
      end
    end
  end
end
