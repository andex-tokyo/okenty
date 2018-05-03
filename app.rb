require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

def draw_text(draw, x, y, text, color,  size ,font="/app/public/fonts/Pomeranian-Regular.ttf")
  draw.font = font
  draw.pointsize = size
  draw.fill(color)
  draw.text(x, y, text)
end


get '/' do
  erb :index
end

post '/pic' do
  @ip = request.ip
  picPath = "/tmp/posted_#{@ip}.jpg"
  image = params[:pic][:tempfile]
  name = params[:name]
  color = params[:color] 
  
      name = "おっ" + name + "ぁー" if name.end_with?("あ","か","が","さ","ざ","た","だ","な","は","ぱ","ば","ま","や","ら","わ","ぁ")
      name = "おっ" + name + "ぃー" if name.end_with?("い","き","ぎ","し","じ","ち","ぢ","に","ひ","ぴ","び","み","り","ゐ","ぃ")
      name = "おっ" + name + "ぅー" if name.end_with?("う","く","ぐ","す","ず","つ","づ","ぬ","ふ","ぷ","ぶ","む","ゆ","る","ぅ")
      name = "おっ" + name + "ぇー" if name.end_with?("え","け","げ","せ","ぜ","て","で","ね","へ","ぺ","べ","め","れ","ゑ","ぇ")
      name = "おっ" + name + "ぉー" if name.end_with?("お","こ","ご","そ","ぞ","と","ど","の","ほ","ぽ","ぼ","も","ろ","を","ぉ")
      name = "おっ" + name + "んんー" if name.end_with?("ん")
  
  
  
  
  open(picPath, 'wb') do |output|
    open(image) do |data|
      output.write(data.read)
      original = Magick::Image.read(picPath).first
          ok = Magick::Draw.new
          ok.gravity(Magick::CenterGravity)
          fontsize = original.columns * 0.09
          fontsize = original.columns * 0.08 if name.end_with?("んんー")
          draw_text(ok, 0 ,0,name,color,fontsize)
          ok.draw(original)
          original.write("/tmp/result_#{@ip}.jpg")
        end
      end
  send_file("/tmp/result_#{@ip}.jpg")
end