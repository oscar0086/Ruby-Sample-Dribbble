# 画像を取得して保存する
# @param [Array] url_list
def download_image(url_list)
  url_list.each do |url|

    # 画像を保存するパスを設定する
    file_name = url.gsub('https://cdn.dribbble.com/', '').gsub('/', '_')
    file_dir = Dir.pwd + '/' + 'image'
    file_path = file_dir + '/' + file_name

    # 保存先ディレクトリが存在しない場合は作成する
    if FileTest.directory?(file_dir) == false
      begin
        puts 'mkdir : ' + file_dir
        Dir.mkdir(file_dir)
        puts 'success'
      rescue
        puts 'fail'
        exit
      end
    end

    # 画像を取得する
    image_file = get_image_file(url)

    if image_file != nil
      # 画像を保存する
      puts 'save : ' + file_path

      begin
        File.open(file_path, 'wb') {|fp| fp.write(image_file)}
        puts 'success'
      rescue
        puts 'fail'
        exit
      end
    end
  end
end

# 画像を取得する
# @param [String] url
# @return [Binary] response body(image)
def get_image_file(url)
  require "faraday"

  puts 'download : ' + url
  res = Faraday.get url

  if res.status == 200
    puts 'success'
    return res.body
  else
    puts 'HTTP Status Code : ' + http_response_status_code.to_s
    exit
  end
end

# ダウンロード済みのファイルを移動する
# @param [String] src ファイルの移動元ディレクトリ
# @param [String] dst ファイルの移動先ディレクトリ
def move_images(src, dst)

  # 移動元ディレクトリが存在しない場合はreturn
  if FileTest.directory?(src) == false
    return
  end

  # 移動先ディレクトリが存在しない場合は作成する
  if FileTest.directory?(dst) == false

    begin
      puts 'mkdir : ' + dst
      Dir.mkdir(dst)
      puts 'success'
    rescue
      puts 'fail'
      exit
    end
  end

  begin
    puts 'move files : ' + src + ' to ' + dst
    require 'fileutils'
    FileUtils.mv(Dir.glob("#{src}/*"), dst + '/')
    puts 'success'
  rescue
    puts 'fail'
    exit
  end
end
