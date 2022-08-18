# 概要

Yamaha のルータ RT シリーズのコマンドリファレンス (http://www.rtpro.yamaha.co.jp/RT/manual/rt-common/index.html) を Dash (http://kapeli.com/) で閲覧できる形式 (Docsets) にするツールです。

# 自分でビルド

Ruby (>= 3.1.0), bundler, git, ImageMagick が必要です。

    git clone https://github.com/labocho/rt-cmdref-docset.git
    cd rt-cmdref-docset
    bundle install

    bundle exec rake install

Dash の設定から Docsets -> Rescan でインストールしたドキュメントが追加されます。

# ライセンス

- 本ソフトウェアは MIT License (http://www.opensource.org/licenses/mit-license.php) で提供します。
