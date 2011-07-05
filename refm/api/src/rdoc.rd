RDoc は Ruby のドキュメント生成を行うためのライブラリです。rdoc という
ドキュメント生成のためのコマンドも含んでいます。

このパッケージは Rdoc と SimpleMarkup というふたつのコンポーネントを含
んでいます。 Rdoc とは Ruby のソースファイルに対するドキュメントを生成
するアプリケーションです。 JavaDoc と同様に、ソースを解析し、クラス、モ
ジュール、メソッドの定義を抜き出してきます(include,require もです)。そ
してこれらの内容とその直前に書かれたコメントを併合し、ドキュメントを出
力します(現在は HTML しか出力できませんが、この部分は取り替え可能にでき
ています)。Markup とはプレーンテキストを様々なフォーマットに変換するた
めのライブラリです。Rdoc によってメソッドやクラスに関するドキュメントを
生成するとき、コメント部を変換するために使われます。

=== ロードマップ

 * Rdoc で Ruby のソースファイルに対するドキュメントを生成したければ、まずこの文章を読みましょう。
 * Cで書かれた拡張ライブラリを含めたければ、[[lib:rdoc/parsers/parse_c]] を見てください。
 * コメント部で使えるマークアップについて知りたければ、[[lib:rdoc/markup/simple_markup]] を見てください。
 * RDoc をライブラリとして使いたければ、[[c:RDoc::RDoc]] を見てください。
 * テキスト部をHTMLに変換する部分をライブラリとして使いたければ、[[c:SM::SimpleMarkup]] を見てください。
 * 独自の HTML テンプレートで出力したければ、[[c:RDoc::Page]] を見てください。

=== 概要

インストールすれば、'rdoc' コマンドでドキュメントが生成できます。
(Windowsでは 'rdoc.bat' です)

  $ rdoc [options]  [names...]

"rdoc --help" と打てば、最新のオプションに関する情報が得られます。

  $ rdoc

このコマンドでカレントディレクトリ以下にあるすべての Ruby とCのソースか
らドキュメントを生成します。生成したドキュメントはカレントディレクトリ
直下の 'doc' というディレクトリに置かれます。

ドキュメントを読む人に取って便利なように、生成されるドキュメントのイン
デックスページに中心的なファイに書かれている内容を含めることができます。
例えば、Rdoc そのもののドキュメントを生成する場合は、以下のようにタイプ
します。

  $ rdoc --main rdoc/rdoc.rb

RDoc が生成するドキュメントのコメント部で使える様々なマークアップの方法
は以下の [[ref:markup]] の項に書かれています。

RDocは拡張子によってファイルをどう処理すべきかを決めます。ファイル名の
末尾が .rb や .rbw であるファイルは Ruby のソースファイルとして処理され
ます。末尾が .c であるファイルはCのソースとして処理されます。それ以外の
ファイルは単なる SimpleMarkup-style で記述されたファイルとして処理され
ます(行の先頭に「#」というコメント記号があってもなくても同じように処理
されます)。また、RDoc にディレクトリ名が渡されると、その中のディレクト
リを再帰的に走査します。ただしこの場合 Ruby と C のソースファイルのみが
処理されます。

===[a:usage] 使いかた

RDocはコマンドラインから以下のようにして起動します。

  $ rdoc <options> [name...]

ファイルをパースし、そこに含まれている情報を集め、出力します。こうして
全ファイルに渡るクロスリファレンスが生成できます。 もし name がディレク
トリならば、その中を走査します。 name を指定しなければ、カレントディレ
クトリ(とそのサブディレクトリ内)の全ての Ruby のファイルを処理します。

options は以下が指定できます。

#@until 1.9.2
: --accessor name

  name で指定したメソッドを attr_xxx と同様なものとして取り扱います。例え
  ば "--accessor db_opt" とすると、以下のような行も RDoc によって処理さ
  れドキュメントに含まれるようになります。

//emlist{
    db_opt :name, :age
//}

  それぞれの name には "=flagtext" というオプションを付けることができま
  す。例えば、"=rw" とすると attr_accessor と同じように取り扱われます。
#@end

: --all

  プロテクティッドメソッドやプライベートメソッドも出力に含まれるように
  なります(デフォルトではパブリックメソッドのみです)。

: --charset charset

  生成する HTML の charset を指定します。

#@since 1.9.3
  可能であれば --encoding を使用してください。
#@end

#@since 1.9.3
: --coverage-report level, --dcov level

  ドキュメントが記述されていない要素に関するレポートを出力します。0 以
  下を指定した場合はレポートを出力しません。0 を指定した場合は、クラス、
  モジュール、定数、属性、メソッドに関するレポートを出力します。0 以上を
  指定した場合には、0 を指定した場合に加えて、メソッドの引数に関するレポー
  トを出力します。level を省略した場合は 0 を指定したと見なされます。

: --no-coverage-report, --no-dcov

  ドキュメントが記述されていない要素に関するレポートを出力しません。
#@end

: --debug

  実行時に内部情報を出力します。

#@since 1.9.2
: --no-debug

  実行時に内部情報を出力しません。
#@end

: --diagram

  モジュールやクラスを表示するのに図を使うようになります。この機能は実
  験的なもので、すべての出力テンプレートに対応しているわけではありません。
  dot V1.8.6 かそれ以降がなければ "--diagram" オプションは正しい出力が
  できません(www.research.att.com/sw/tools/graphviz/)。

#@since 1.9.3
: --dry-run

  ファイルの出力を行わず、表示だけを行います。

: --no-dry-run

  ファイルの出力を行います。
#@end

#@since 1.9.3
: --encoding encoding

  出力ファイルの文字エンコーディングを encoding に指定します。rdoc が読
  み込んだ全てのファイルはこの文字エンコーディングに変換されま
  す。--charset オプションもありますが --encoding オプションを使用して
  ください。
#@end

: --exclude pattern

  pattern にマッチするディレクトリおよびファイルを処理の対象から取り除きます。

: --extension new=old

  ファイル名の末尾が .new であるものを、末尾が .old であるものとして取
  り扱います。例えば '--extension cgi=rb' とすれば、RDoc は ".cgi" で
  終わるファイルを Ruby のソースとして取り扱います。

: --fileboxes

  --diagram を指定した場合生成された図において、クラスがどのソースファ
  イルで定義されているかを四角で囲うことで示します。複数のファイルで定
  義されているクラスは複数の四角にまたがった図が作られます。--diagram
  といっしょに使わなければ意味のないオプションです。(実験的な機能です)

#@since 1.8.6
: --force-update

  出力済みのファイルの方が新しい場合でも全てのファイルを更新します。
  1.9.2 以下では指定しなかった場合は有効になりません。1.9.2 以降は指定
  しなかった場合でも有効になります。

#@since 1.9.2
: --no-force-update

  出力済みのファイルの方が新しい場合のみファイルを更新します。
#@end

#@end

: --fmt fmt

  生成される出力を指定します。

: --help

  使いかたの概要を表示します。

#@until 1.9.1
: --help-output

  出力に関するオプションを解説します。
#@end

#@since 1.9.2
: --ignore-invalid

  無効なオプションを指定した場合に、そのオプションを無視して処理を続行
  します。また、標準エラーに無視されるがオプションが出力されます。標準
  で有効になっています。

: --no-ignore-invalid

  無効なオプションを指定した場合に、標準エラーに情報を出力して終了ステー
  タス 1 でプログラムを終了します。
#@end

: --image-format gif/png/jpg/jpeg

  図のフォーマットを指定します。png、gif、jpeg、jpg が指定できます。指
  定しなかった場合は png が使われます。--diagram が必要です。

: --include dir,…

  :include: 命令でファイルを探すディレクトリを指定します。 --include を
  複数使ってもかまいません。これを指定しなくとも処理中のファイルはすべ
  て探索されます。

: --inline-source

  デフォルトでは、メソッドのソースコードはポップアップウィンドウで表示
  されます。このオプションを付けると、インラインで表示されます。

: --line-numbers

  ソースコードに行番号を付けます。

: --main name

  最初に表示されるページに置かれるもの(クラス、ファイルなど)を指定しま
  す。もし、特定のファイル(例えば、README など)を置きたければ、それをコ
  マンドラインの最初に置くだけでもかまいません。

: --merge

  ri の出力を生成するとき、出力ディレクトリにすでにファイルが存在すれば、
  そのファイルを上書きせずに、マージするようにします。

: --one-file

  すべての出力を一つのファイルに書きだします。

#@since 1.9.2
: --output dir, --op dir
#@else
: --op dir
#@end

  出力先のディレクトリを dir に設定します(デフォルトは "doc" です)。

: --opname name

  出力の名前をnameにします(HTMLを出力する場合には何の効果もありません)

#@since 1.9.2
: --pipe

  標準入力を読み込んで HTML に変換し、標準出力に出力します。ファイルへ
  の出力は行わないため、--op などのオプションは無視されます。
#@end

: --promiscuous

  クラスやファイルが複数のファイルで定義されていて、ナビゲーションペイ
  ンのファイルの所をクリックした場合、そのモジュール内のクラスなどは通
  常はそのファイルで定義されている分しか表示されません。このオプション
  を指定すると、そのファイルで定義されているかどうかにかかわらず、すべ
  てのモジュール(クラス)内モジュール(クラス)を表示します。

: --quiet

  処理進行メッセージを表示しません。

#@since 1.8.2
: --ri, --ri-site, and --ri-system

  ri で読める出力を生成します。デフォルトでは --ri を指定すると
  ~/.rdoc に出力されますが、--ri-site で $datadir/ri/<ver>/site
  に、--ri-system で $datadir/ri/<ver>/system に出力されます。これれす
  べてはうしろに指定した --op を上書きします。デフォルトのディレクトリ
  は ri のデフォルトのサーチパスです。
#@else
: --ri, --ri-site

  ri で読める出力を生成します。デフォルトでは --ri を指定すると
  ~/.rdoc に出力されますが、--ri-site で $datadir/ri/<ver>/site
  にに出力されます。これれすべてはうしろに指定した --op を上書きします。
  デフォルトのディレクトリは ri のデフォルトのサーチパスです。
#@end

: --show-hash

  コメント内の name というところからインスタンスメソッドへのハイパーリ
  ンクを生成します。このオプションを指定しなければ '#' は取り除かれま
  す。

: --style stylesheet url

  (RDoc のではなく)外部スタイルシートの URL を指定する。

: --tab-width n

  タブの幅を指定する(デフォルトは 8)。

: --template name

  出力生成時に使うテンプレートを指定する(デフォルトは 'standard')。実
  際にはこれで [[m:$:]] の中のディレクトリの
  rdoc/generators/xxxx_template が使われる。 (xxxx はフォーマッタによっ
  て異なる)。

: --title text

  出力のタイトルを text に指定します。

#@since 1.9.3
: --visibility visibility

  出力するメソッドの可視性を public、protected、private のいずれかから指定します。
  指定しなかった場合は protected です。
#@end

#@since 1.9.1
: --verbose

  プログラムの解析時に詳細な情報を表示します。
#@end

: --version

  RDocのバージョンを表示する。

: --webcvs url

  CVS のウェブフロントエンドへのリンクの URL を指定する。URL が '\%s'
  を含んでいれば、そこがファイル名が置きかえられます。'\%s' を含んで
  いなければ、ファイル名を指定した URL の後に付けたものを使います。

===[a:markup] Markup

コメント部はかなり自然に書くことができます。'#' で始まるコメントも使え
ますし、=begin/=end でのコメントも使えます。=begin/=end を使う場合は、
以下のように =begin の行に 'rdoc' タグを付ける必要があります。

  =begin rdoc
  Documentation to
  be processed by RDoc.
  =end

パラグラフは左のインデントを揃えたテキストのかたまりで構成されます。そ
れよりも深くインデントされたテキストはそのまま、マークアップを考慮せず
にフォーマットされます。

また、RDocは '#--' を含む行が現われると処理をしなくなります。これで外部
向けコメントと内部向けコメントを分離したり、メソッド、クラスモジュール
と関係ないコメントを取り除いたりできます。'#++' で始まる行が現われると、
処理を再開します。

  # Extract the age and calculate the
  # date-of-birth.
  #--
  # FIXME: fails if the birthday falls on
  # February 29th
  #++
  # The DOB is returned as a Time object.

  def get_dob(person)
     ...

==== リスト

リストは以下のような記号が付いたパラグラフです。

  * '*' もしくは '-' で普通のリスト
  * 数字+ピリオドで番号付きリスト
  * アルファベット+ピリオドでアルファベットリスト

例えば、上のパラグラフは以下のように書きます。

  リストは以下のような記号が付いた
  パラグラフです。
    * '*' もしくは '-' で普通のリスト
    * 数字+ピリオドで番号付きリスト
    * アルファベット+ピリオドで
      アルファベットリスト

==== ラベル付きリスト

ラベル付きリスト(description list とも呼ばれる)は通常大括弧でラベルを囲
います。

  [cat]   small domestic animal
  [+cat+] command to copy standard input

ラベル付きリストはコロン2つをラベルの後に置くことでもマークアップできる。
この場合は表形式となり、記述部(コロン2つの後のテキスト)は左揃えになりま
す。この形式は本ドキュメントの末尾のほうの 'author' のところで使われて
います。

  cat::   small domestic animal
  +cat+:: command to copy standard input

どちらの形式のラベル付きリストでも、ラベルと同じ行から記述部を書き始め
た場合は、その記述部と同じインデントでひとかたまりとなります。また、ラ
ベルの次の行から記述部を書き始めることもできます。ラベル部の文章が長く
なるならこうしたほうが良いかもしれません。つまり以下の例のどちらでも良
いということです。

  <tt>--output</tt> <i>name [, name]</i>::
      specify the name of one or more output files. If multiple
      files are present, the first is used as the index.

  <tt>--quiet:</tt>:: do not output the names, sizes, byte counts,
                      index areas, or bit ratios of units as
                      they are processed.

==== 見出し

見出し部は ASCII 文字の等号「=」を使います。

  = 見出しレベル1
  == 見出しレベル2

以下レベル 3、4、…と続きます。

==== 罫線

罫線(横方向の線)はASCII文字のハイフン三つ '---' を使います。

==== イタリック体、ボールド体、タイプライター体

文中で以下のようなマークアップもできます。

 * イタリック体 italic: _word_ もしくは <em>text</em>
 * ボールド体 bold:  *word* もしくは <b>text</b>
 * タイプライター体 typewriter:  +word+ もしくは <tt>text</tt>

それぞれ2つ形式がありますが、word の方は単語を囲うことしかできません。
単語というのは、アルファベットの大文字および小文字とアンダースコアーの
みから構成された文字列です(よって日本語では使えません)。また、これらの
マークアップ記号の前に「\」という文字を置くと、マークアップが抑制されま
す。上の表は以下のようにすれば作れます。

  <em>イタリック体</em> _italic_::         \_word_ もしくは \<em>text</em>
  <b>ボールド体</b> *bold*::               \*word* もしくは \<b>text</b>
  <tt>タイプライター体</tt> +typewriter+:: \+word+ もしくは \<tt>text</tt>

==== クラス、メソッドへのリンク

コメント内のクラス名やソースファイルの名前やメソッド名(アンダースコアー
を含んでも良いし「#」が前に付いていても良い)は、自動的にリンクが張られ
ます。

==== 外部リンク

http:、 mailto:、 ftp:、 www. で始まるテキストはウェブへのリンクだと判
別されます。外部の画像ファイルを参照している場合は <IMG..> に変換されま
す。link: で始まる場合はローカルファイルへのリンクであるとみなし、--op
で指定したディレクトリからの相対パスとなります。

label[url] の形式でもハイパーリンクが張れます。この場合は lavel が表示
され、url がリンク先となります。label が複数の単語を含んでいる場合(日本
語の場合はこっちを使ってください)、

中括弧を使い、<em>{multi word label}[</em>url<em>]</em> としてください。

==== メソッドパラメータ

メソッドのパラメータは抜きだされ、ドキュメントのメソッド記述のところに
出力されます。メソッドが yield を呼んでいる場合は、yield に渡されている
パラメータもそこに出力されます。

  def fred
    ...
    yield line, address

上のようなメソッド定義に対して、以下の出力が得られます。

  fred() { |line, address| ... }

メソッド名の直後に ':yields: …' を含むコメントを書くと、この出力を上書
きできます。

  def fred      # :yields: index, position
    ...
    yield line, address

上のようにするとお、以下の出力になります。

  fred() { |index, position| ... }

==== 命令

コメント部には他にも以下の命令を含めることができます。

':yield:' はドキュメント修飾子の一例です。以下の修飾子は修飾しようとし
ている部分の直後に書きます。ほかにも以下のようなものがあります。

===== 出力の制御

: :nodoc: [all]

  指定した要素をドキュメントに含めません。クラスやモジュールを指定した場
  合、それに直接含まれるメソッドやエイリアスや定数や属性も省略されます。
  しかし、デフォルトでは、指定したモジュールやクラスに含まれるモジュール
  やクラスはドキュメントに 含まれます。これをオフにしたい場合は all 修飾
  子を加えます。

//emlist{
    module SM  #:nodoc:
      class Input
      end
    end
    module Markup #:nodoc: all
      class Output
      end
    end
//}

  以上のコードでは、SM::Inputのドキュメントのみが出力されます。

: :stopdoc: / :startdoc:

  ドキュメント要素(クラス、メソッドなど)をドキュメントに含めるかどうか
  を制御します。例えば、あるクラスにドキュメントに出力したくない定数があ
  るとすると、その前に :stopdoc: を置き、後ろに :startdoc: を置きましょう。
  もし :startdoc: を置かなければ、そのクラス、モジュール全体がドキュメ
  ントに出力されなくなり ます。

: :doc:

  指定したメソッドや属性を強制的にドキュメントに含めます。これは例えば特
  定のプライベートメソッドをドキュメントに含めたい場合に便利です。

: :enddoc:

  以降の内容を一切ドキュメントに出力しません。

: :notnew:

  これはインスタンスメソッドの initialize にのみ適用できます。通常、
  RDoc は initialize メソッドのドキュメントやパラメータを実際にはクラス
  メソッドnewのものと仮定し、initialize の代わりに new を出力しま
  す。:notnew: 修飾子はこれを止めさせます。initialize メソッドは
  protected なので、コマンドラインで -a を指定するなどしない限り、
  initialize メソッドに関するドキュメントは出力されないことに注意してくだ
  さい。

===== その他の命令

: :include: filename

  指定した場所に指定したファイルを挿入します。ファイルを探すディレクト
  リは --include で指定したものとカレントディレクトリです。挿入されるファ
  イルは :include: 命令を置いたのと同じだけインデントされます。

: :title: text

  ドキュメントのタイトルを指定します。コマンドラインの --title パラメー
  タと同じ働きをします。(コマンドラインでの指定のほうが優先されます)

: :main: name

  コマンドラインの --main パラメータと同じ働きをします。

#@since 1.9.1
: :category: section

  Adds this item to the named +section+ overriding the current section.  Use
  this to group methods by section in RDoc output while maintaining a
  sensible ordering (like alphabetical).

//emlist{
    # :category: Utility Methods
    #
    # CGI escapes +text+

    def convert_string text
      CGI.escapeHTML text
    end
//}

  An empty category will place the item in the default category:

//emlist{
  # :category:
  #
  # This method is in the default category

  def some_method
    # ...
  end
//}

  Unlike the :section: directive, :category: is not sticky.  The category
  only applies to the item immediately following the comment.

  Use the :section: directive to provide introductory text for a section of
  documentation.
#@end

: :section: title

  新しいセクションを開始します。:section: の後ろに置いたタイトルはその
  セクションの見出しとなります。そして、コメントの残りの部分はそのセク
  ションの導入文となります。その後ろのメソッド、エイリアス、属性、クラス
  はこのセクションに含まれます。:section: 命令の前に何行かあってもかま
  いません。それらはドキュメントには含まれず、またそれとまったく同じ内容
  の行がブロックの終端にあった場合、それも取り除かれます。そのため、以下
  のような装飾をすることが できます。

//emlist{
    # ----------------------------------------
    # This is the section that I wrote.
    # See it glisten in the noon-day sun.
    # ----------------------------------------
//}

: :call-seq:

  デフォルトではメソッドの引数や yield の引数をパースして出力しますが、
  これを指定した次の行から次の空行までをメソッド呼び出し列と解釈し、出
  力をそこに書かれたように変更します。

#@# Further directives can be found in RDoc::Parser::Ruby and RDoc::Parser::C.

#@todo マークアップについては、1.9 の rdoc/markup.rb からもう少し持ってくる。(1.9 側は markup.rb に書いてある)

= module RDoc

rdoc ドキュメントを扱うためのモジュールです。

= class RDoc::RDoc

rdoc ドキュメントの作成を行うクラスです。

以下のようにして、rdoc コマンドを実行するのと同様に実行します。

   rdoc = RDoc::RDoc.new
   rdoc.document(args)

args には rdoc コマンドに渡すのと同様の引数を文字列の配列で指定します。

== Instance Methods

--- document(argv) -> nil

argv で与えられた引数を元にドキュメントをフォーマットして指定されたディ
レクトリに出力します。

@param argv コマンドラインで rdoc コマンドに指定するのと同じ引数を文字
            列の配列で指定します。

@raise RDoc::RDocError ドキュメントの処理中にエラーがあった場合に発生します。

指定できるオプションについては、[[ref:lib:rdoc#usage]] を参照してくださ
い。出力ディレクトリが指定されなかった場合はカレントディレクトリ の
doc 以下に出力します。

#@since 1.9.1
= class RDoc::Error < Exception
#@else
= class RDoc::RDocError < Exception
#@end

ドキュメントの処理中にエラーがあった場合に発生します。
