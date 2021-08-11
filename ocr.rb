require 'rtesseract'
require 'pdf/inspector'
require 'mimemagic'
require 'pry'

# image = RTesseract.new("image_1.jpg")
# pdf = image.to_pdf
# page_analysis = PDF::Inspector::Text.analyze(pdf)

class ImageToPDF
  attr_reader :image_text

  def initialize(image)
    @image = set_image(image)
  end

  def strip_text_from_image
    analyzed_image = RTesseract.new(@image)
    @image_text = analyzed_image.to_s
  end

  private

  def set_image(obj)
    is_it_an_image?(obj) ? @image = obj : missing_image
  end

  def missing_image
    raise 'An image is required'
  end

  def is_it_an_image?(obj)
    file = File.open(obj)
    binding.pry
    true if MimeMagic.by_magic(file).type == "image/jpeg"
  end
end
