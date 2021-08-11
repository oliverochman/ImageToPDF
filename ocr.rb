require 'rtesseract'
require 'pdf/inspector'
require 'mimemagic'
require 'pry'
require "prawn"

# image = RTesseract.new("image_1.jpg")
# pdf = image.to_pdf
# page_analysis = PDF::Inspector::Text.analyze(pdf)

# require './ocr'
# test = ImageToPDF.new('images/java/image_1.jpg')
# test.strip_text_from_image
# test.create_pdf


class ImageToPDF
  attr_reader :image_text, :finished_pdf

  def initialize(image)
    @image = set_image(image)
  end

  def strip_text_from_image
    analyzed_image = RTesseract.new(@image)
    @image_text = analyzed_image.to_s
  end

  def create_pdf
    begin
      pdf = Prawn::Document.new
      pdf.text(@image_text)
      pdf.page_number = 1
      pdf.render_file("./pdf/test.pdf")
      puts 'PDF created'
    rescue => error
      raise error
    end
  end

  private

  def set_image(obj)
    is_it_an_image?(obj) ? @image = obj : missing_image
  end

  def missing_image
    raise 'An image is required'
  end

  def is_it_an_image?(obj)
    begin
      file = File.open(obj)
      true if MimeMagic.by_magic(file).type == "image/jpeg"
    rescue
      missing_image
    end
  end
end

test = ImageToPDF.new('images/java/image_1.jpg')
test.strip_text_from_image
test.create_pdf

