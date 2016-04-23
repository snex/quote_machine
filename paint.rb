require 'rmagick'
require 'httpi'

module Paint

  def self.paint_image(url, quote, face_rect)
    req = HTTPI::Request.new(url)
    img_data = HTTPI.get(req).body
    img = Magick::Image.from_blob(img_data).first

    draw_width = draw_left = draw_height = draw_top = 0

    if face_rect['left'] > img.bounding_box.width - (face_rect['width'] + face_rect['left'])
      draw_width = face_rect['left']
    else
      draw_width = img.bounding_box.width - (face_rect['width'] + face_rect['left'])
      draw_left = face_rect['left'] + face_rect['width']
    end

    if face_rect['top'] > img.bounding_box.height - (face_rect['height'] + face_rect['top'])
      draw_height = face_rect['top']
    else
      draw_height = img.bounding_box.height - (face_rect['height'] + face_rect['top'])
      draw_left = face_rect['top'] + face_rect['height']
    end

    quote_wrap_size = draw_width / 8
    puts quote_wrap_size
    wrapped_quote = quote.scan(/\S.{0,#{quote_wrap_size}}\S(?=\s|$)|\S+/).join("\n")
    draw = Magick::Draw.new
    draw.annotate(img, draw_width, draw_height, draw_left, draw_top + 10, wrapped_quote) {
      self.undercolor = 'white'
      self.gravity = Magick::ForgetGravity
      self.pointsize = 12
    }

    img.write("#{img.format}:public/images/temp")
  end

end
