# encoding: UTF-8
require "sqlite3"
require "active_record"
require "fileutils"
require "pp"
require "yaml"
require "shellwords"
require "nokogiri"

include FileUtils

version = File.read("html/VERSION").strip

docset = "docsets/RTシリーズコマンドリファレンス.docset"
mkdir_p "#{docset}/Contents/Resources/Documents"
exit $?.exitstatus unless system("cp -R html/* #{"#{docset}/Contents/Resources/Documents".shellescape}")
cp "resources/favicon.png", "#{docset}/icon.png"

open("#{docset}/Contents/Info.plist", "w") do |f|
  f.write <<-XML
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>CFBundleIdentifier</key>
        <string>RTシリーズコマンドリファレンス</string>
        <key>CFBundleName</key>
        <string>RTシリーズコマンドリファレンス</string>
        <key>DocSetPlatformFamily</key>
        <string>rt</string>
        <key>isDashDocset</key>
        <true/>
        <key>dashIndexFilePath</key>
        <string>index.html</string>
      </dict>
    </plist>
  XML
end

rm "#{docset}/Contents/Resources/docSet.dsidx", force: true

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "#{docset}/Contents/Resources/docSet.dsidx"
)

ActiveRecord::Base.connection.execute <<-SQL
  CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT)
SQL

class SearchIndex < ActiveRecord::Base
  self.table_name = "searchIndex"
end

html_dir = "#{docset}/Contents/Resources/Documents"

cmdref_index = Nokogiri::HTML.parse(File.read("#{html_dir}/cmdref_index.html"))
cmdref_index.css("a").each do |a|
  path = a["href"]
  key = a.text.strip
  index = SearchIndex.new
  index.name = key
  index.type = "Function"
  index.path = path
  index.save!
  print "."
end
