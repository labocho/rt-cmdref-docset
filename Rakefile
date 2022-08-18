def version
  require "nokogiri"

  doc = Nokogiri::HTML.parse(File.read("html/defaultpage.html"))

  doc.css("a").map(&:text).each do |s|
    next unless s.strip =~ /\A(.+)年(.+)月　第(.+)版\z/

    y, m, v = $~.captures
    return "v#{v} (#{y}-#{m.rjust(2, "0")})"
  end

  raise "Cannot detect version"
end

file "Cmdref_HTML_Archive.zip" do
  sh "curl --silent -O http://www.rtpro.yamaha.co.jp/RT/manual/rt-common/Cmdref_HTML_Archive.zip"
end

directory "html" => "Cmdref_HTML_Archive.zip" do
  sh "unzip Cmdref_HTML_Archive.zip"
end

directory "resources"

file "resources/favicon.ico" => "resources" do
  sh "curl --silent O http://www.rtpro.yamaha.co.jp/favicon.ico > resources/favicon.ico"
end

file "resources/favicon.png" => "resources/favicon.ico" do
  sh "convert resources/favicon.ico resources/favicon.png"
end

task :generate_docsets => ["html", "resources/favicon.png"] do
  version_file = "html/VERSION"
  File.write(version_file, version)
  ruby "generate_docsets.rb"
end

task :install => :generate_docsets do
  source = "docsets/RTシリーズコマンドリファレンス.docset"
  dest = "#{ENV["HOME"]}/Library/Application Support/Dash/DocSets/RTシリーズコマンドリファレンス"
  rm_rf dest
  mkdir_p dest
  cp_r source, dest
end

task :uninstall do
  dest = "#{ENV["HOME"]}/Library/Application Support/Dash/DocSets/RTシリーズコマンドリファレンス"
  rm_rf dest
end

task :clean do
  rm_rf "docsets"
  rm_rf "html"
  rm_rf "resources"
  rm "Cmdref_HTML_Archive.zip"
end
