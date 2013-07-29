require "RMagick"
require "fileutils"

class MemesController < ApplicationController
  def new
    @meme = Meme.new
  end

  def show
    @meme = Meme.find(params[:id]).decorate
  end

  def create
    @user = current_user
    if !params.has_key?(:url)
      #TODO(cc): change this
      pic_name = "%s.jpg" % [params[:meme][:picture]]
      pic_path = Rails.root.join('app', 'assets', 'images', 'meme_image', pic_name)
      url_result = generate(pic_path, params[:meme][:top_text], params[:meme][:bottom_text])
      params[:url] = url_result
    end
    @meme = Meme.new(url: params[:url], :creator_id => @user.id)
    if @meme.save
      @meme = @meme.decorate
      flash[:notice] = "Successfully Uploaded :)"
      redirect_to root_url
    else
      flash[:error] = @meme.errors.full_messages.join(', ')
    end
  end

  def destroy
    @meme = Meme.find(params[:id])
    @meme.destroy
    redirect_to :root
  end

  def generate(path, top, bottom)
    top = (top || '').upcase
    bottom = (bottom || '').upcase

    canvas = Magick::ImageList.new(path)
    image = canvas.first

    draw = Magick::Draw.new
    draw.font = File.join(File.dirname(__FILE__), "../assets/", "fonts", "Flat-UI-Icons-16.ttf")
    draw.font_weight = Magick::BoldWeight

    pointsize = image.columns / 7.0
    stroke_width = pointsize / 35.0
    x_position = image.columns / 2
    y_position = image.rows * 0.15

    # Draw top
    unless top.empty?
      scale, text = scale_text(top)
      bottom_draw = draw.dup
      bottom_draw.annotate(canvas, 0, 0, 0, 0, text) do
        self.interline_spacing = -(pointsize / 5)
        self.stroke_antialias(true)
        self.stroke = "black"
        self.fill = "white"
        self.gravity = Magick::NorthGravity
        self.stroke_width = stroke_width * scale
        self.pointsize = pointsize * scale
      end
    end

    # Draw bottom
    unless bottom.empty?
      scale, text = scale_text(bottom)
      bottom_draw = draw.dup
      bottom_draw.annotate(canvas, 0, 0, 0, 0, text) do
        self.interline_spacing = -(pointsize / 5)
        self.stroke_antialias(true)
        self.stroke = "black"
        self.fill = "white"
        self.gravity = Magick::SouthGravity
        self.stroke_width = stroke_width * scale
        self.pointsize = pointsize * scale
      end
    end
    output_path = "/tmp/meme-#{Time.now.to_i}.jpeg"
    canvas.write(output_path)
    cmd = "curl -X POST -F fileUpload=@%s https://www.filepicker.io/api/store/S3\?key\=ASvEK6hqxQRaRuAqhSMz9z" % [output_path]

    result =  %x[ #{cmd} ]
    #TODO(cc):hacky
    url_result = "https://%s" % [result.split(',')[0].split(':')[2][2..-2]]
    url_result
  end

  private

  def word_wrap(txt, col = 80)
    txt.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
  end

  def scale_text(text)
    text = text.dup
    if text.length < 10
      scale = 1.0
    elsif text.length < 24
      text = word_wrap(text, 10)
      scale = 0.70
    else
      text = word_wrap(text, 18)
      scale = 0.5
    end
    [scale, text.strip]
  end
end
