class TweetsController < ApplicationController
  before_action :authenticate_user!
  # before_actionを用いてログインしていなければログイン画面へ返す
  # ヒント: authenticate_〇〇!（deviseのヘルパーメソッド）

  def index
    @tweets = Tweet.all.order("created_at DESC").page(params[:page]).per(10)
    # allを使ってTweetの全レコードの取得しインスタンス変数に格納
      #→ ページングする場合は...  →  参照：「ページング機能を実装しよう」
        #→  並び順かえたい場合は...  →  「rails order」で検索
    @tweet = Tweet.new
    # form_forに渡すインスタンスを生成
  end

  def create
    @tweet = Tweet.new(tweet_params)
    # ストロングパラメーターを元にインスタンスを生成
    @tweet.user_id = current_user.id
    # 投稿したuser_idをtweetのuser_idカラムにセット　→　参照：「[railsブログを作ろう②]ユーザーとポストを紐付けよう！」
    if @tweet.save
      redirect_to tweets_url, notice: "ツイートしました"
    # データベースへ保存する  →  参照：week2「データの保存、抽出」
    else
      redirect_to tweets_url, notice: "ツイートに失敗しました"
    end
    # ツイート一覧へリダイレクト　→　参照：week2「コントローラーの様々なメソッドを学ぶ」
  end


  def destroy
    # レコードを１件取得　→ 参照：week2「データの保存、抽出」
    @tweet = Tweet.find(params[:id])
    # 取得したレコードの削除　→  参照：week2「データの保存、抽出」
    @tweet.destroy
    # ツイート一覧へリダイレクト　→　参照：week2「簡易掲示板を作ろう３」
    redirect_to tweets_url, notice: "ツイートを削除しました"
  end

  # ここからprivateメソッド
  private
    #ストロングパラメーターを設定
    def tweet_params
      params.require(:tweet).permit(:body)
    end
end


