# 1. ExClassクラスのオブジェクトが2つあります。これらをJudgement.callに渡しています。
#    Judement.callはテスト側で定義するので実装は不要です。この状況でe2オブジェクト"だけ"helloメソッドを
#    使えるようにしてください。helloメソッドの中身は何でも良いです。

class ExClass
end

e1 = ExClass.new
e2 = ExClass.new

e2.define_singleton_method(:hello) { 'hello' }

Judgement.call(e1, e2)

# 2. ExClassを継承したクラスを作成してください。ただし、そのクラスは定数がない無名のクラスだとします。
#    その無名クラスをそのままJudgement2.call の引数として渡してください(Judgement2.callはテスト側で定義するので実装は不要です)

Judgement2.call(Class.new(ExClass))


# 3. 下のMetaClassに対し、次のように`meta_`というプレフィックスが属性名に自動でつき、ゲッターの戻り値の文字列にも'meta 'が自動でつく
#    attr_accessorのようなメソッドであるmeta_attr_accessorを作ってください。セッターに文字列以外の引数がくることは考えないとします。
#
#    使用例:
#
#    class MetaClass
#      # meta_attr_accessor自体の定義は省略
#      meta_attr_accessor :hello
#    end
#    meta = MetaClass.new
#    meta.meta_hello = 'world'
#    meta.meta_hello #=> 'meta world'

class MetaClass
  define_singleton_method(:meta_attr_accessor) do |name|
    define_method("meta_#{name}") do
        instance_variable_get("@meta_#{name}")
    end

    define_method("meta_#{name}=") do |value|
        instance_variable_set("@meta_#{name}", "meta #{value}")
    end
  end
end

# 4. 次のようなExConfigクラスを作成してください。ただし、グローバル変数、クラス変数は使わないものとします。
#    使用例:
#    ExConfig.config = 'hello'
#    ExConfig.config #=> 'hello'
#    ex = ExConfig.new
#    ex.config #=> 'hello'
#    ex.config = 'world'
#    ExConfig.config #=> 'world'

ExConfig = Class.new
ExConfig.class_eval do
  self.class.class_eval { attr_accessor :config }
  define_method(:config=) { |value| self.class.config = value }
  define_method(:config) { self.class.config }
end

# 5.
# ExOver#helloというメソッドがライブラリとして定義されているとします。ExOver#helloメソッドを実行したとき、
# helloメソッドの前にExOver#before、helloメソッドの後にExOver#afterを実行させるようにExOverを変更しましょう。
# ただしExOver#hello, ExOver#before, ExOver#afterの実装はそれぞれテスト側で定義しているので実装不要(変更不可)です。
#

class ExOver
  alias_method :hello2, :hello

  def hello
    before
    hello2
    after
  end
end

# 6. 次の toplevellocal ローカル変数の中身を返す MyGreeting#say を実装してみてください。
#    ただし、下のMyGreetingは編集しないものとします。toplevellocal ローカル変数の定義の下の行から編集してください。
#    ヒント: スコープゲートを乗り越える方法について書籍にありましたね

class MyGreeting
end

toplevellocal = 'hi'

MyGreeting.class_eval { define_method(:say) { toplevellocal }}
