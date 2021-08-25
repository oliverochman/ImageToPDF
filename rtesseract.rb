require 'rtesseract'
require 'mimemagic'
require 'pry'
require "prawn"
require 'fileutils'
require 'combine_pdf'

class ImageToPDF
  attr_reader :path
  def initialize(path)
    @path = path
    create_pdf(path)
  end

  def create_pdf(path)
    Dir.foreach(path) do |image|
      if image.end_with?(".jpg") 
        pathname = path + '/' + image
        is_it_an_image?(pathname)
        analyzed_image = RTesseract.new(pathname)
        pdf = analyzed_image.to_pdf
        FileUtils.move pdf, './pdf/' + File.basename(image,File.extname(image)) + '.pdf'
      end
    end

    pdf_paths = []
    Dir.foreach('./pdf') do |pdf_path|
      if pdf_path.end_with?('.pdf')
        pdf_paths.push('./pdf/' + pdf_path)
      end
    end
    
    pdf_paths.sort_by { |x| -x[/\d+/].to_i }

    pdf = CombinePDF.new
    pdf_paths.each do |lonely_pdf|
      pdf << CombinePDF.load(lonely_pdf)
    end

    pdf.save('./finished_pdf/java.pdf')
  end

  private

  def missing_image
    raise 'An image is required'
  end

  def is_it_an_image?(image)
    begin
      file = File.open(image)
      MimeMagic.by_magic(file).type == "image/jpeg" ? true : missing_image
    rescue => error
      missing_image
    end
  end
end

test = ImageToPDF.new('./images/java')