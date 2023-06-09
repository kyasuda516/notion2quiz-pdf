# Notion2QuizPdf

Notionの記事を問題集のようにしたPDFを作ることができます。

「一問一答」形式のNotion記事を用意すれば、答え部分がマスクされたPDFを作ることができます。また、見開き右側に、マスクされていない元の状態のものが一緒になっているので、答え合わせもしやすいです。

できあがるPDFの例が[QuizPdf](https://github.com/kyasuda516/quiz-pdf "kyasuda516/quiz-pdf: Notion2QuizPdfで作られたPDF集")にありますので、そちらもご参照ください。

# デモ動画

Notion2QuizPdfをデモンストレーションしている様子がこちらです（サムネイルをクリックするとYouTubeに飛びます）。

[!['デモ動画'](https://user-images.githubusercontent.com/127583471/229123827-0a8bdc8e-c479-44fe-93ab-56effe928c6e.PNG)](https://www.youtube.com/watch?v=ORBx_WCSRZ0)

# 流れ

本アプリケーションの大まかな処理の流れです。

1. Notion記事をHTMLファイルとしてダウンロード。
2. ダウンロードしたHTMLを問題用・答え用それぞれに編集し、別ファイルとして保存。
3. 保存したHTML（問題用・答え用）をそれぞれPDFとして書き出し。
4. 2種類のPDFが見開き1ページになる（各ページが左右に並ぶ）ように編集し、1つのファイルとして保存。

なお、これらは4つのバッチファイル `/Step1 - notion2html.bat` ～ `/Step4 - combine_pdfs.bat` それぞれが実行する内容に対応しています。


# 注意
## 推奨環境

推奨されるOSは **Windows 10 または 11** となります。macOS でも可能かもしれませんが、試しておりません。

また、実行環境として **Anaconda** を用います。

## その他の注意点
その他、いくつか注意点があります。

* Step1ではNotionへのログインを行いますが、ここではGoogleアカウントによるログインとなっています。  
現在Notionでは他に「Appleアカウントによるログイン」「メールアドレスによるログイン」がサポートされていますが、これらのログイン方法を用いる場合は `/.scripts/notion2html.py` を少し書き直していただく必要があります。
* Notion記事中のあるブロックが、問い部分、答え部分をもつ「一問一答ブロック」として認識され、答え部分にマスクが適用されるには、そのブロックが一定のフォーマットに従っている必要があります。（詳細は次段へ）
* Notion記事のURLが記載された `/setting.csv` を用意する必要があります。（詳細は次段へ）


# はじめに

Anaconda と Google Chrome をあらかじめインストールしておいてください。  
（それらのインストール方法は他のサイトを参照してください）

Anaconda Prompt を起動してください。  
このリポジトリをクローンしたディレクトリに移動したあと、以下のコマンドを順に実行してください。（ `notion2quiz-pdf-env` というconda環境が作成されます）

```bash
conda env create -f ./.scripts/environment.yml
conda activate notion2quiz-pdf-env
conda update --all
```


# 準備
## 一定のフォーマットに従うNotion記事の作成
前述したとおり、Notion記事のあるブロックにマスクを適用するには、そのブロックが一定のフォーマットに準じている必要があります。といっても、そのフォーマットの制約はとても簡単なものです。

まず、「一問一答ブロック」となりえるブロックのタイプは<strong>「トグルリスト」のみ</strong>です。しかも、トグルリストがネストされている場合、最上位のブロックにしか適用できません（これは、最終的にトグルリストが閉じた状態でレンダリングされるためです）。

そのうえで「一問一答ブロック」と認識されるには、問い部分と答え部分との間を、「スペース文字列」（全角、半角を問わずスペース文字のみで構成される文字列）で満たさなければなりません。さらに、スペース文字列には次のいずれかが含まれている必要があります。

* 全角スペース1字 ( `　` )
* 半角スペース連続2字 ( <code>  </code> )

なお、スペース文字列が複数箇所にある場合、最も前にあるものが問い部分と答え部分を分けていると見なされます。また、ブロック内で改行がなされている（Notionでは Shift+Enter で改行が可能）場合、各行でスペース文字列が探され、マスクがなされます。

それから、例外としてマスクが適用されない場合があります。ブロックの先頭の文字が `☆` または `※` である場合、そのブロックでマスクが適用されることはありません。

以上が制約の説明となります。これをふまえると、たとえば次のようなトグルブロックがあった場合、下線で示す部分がマスクされます。
<ul>
<details>
<summary style="list-style-position: outside;">静脈, 葉脈は英語で&nbsp;&nbsp;&emsp;<ins>vane　　※ vane (風向計, 羽根) と同じ読み</ins></summary>
</details>
<details>
<summary style="list-style-position: outside;">ボイラープレート&emsp;&emsp;<ins>ほとんどまたは全く変化することなく複数の場所で繰り返される</ins>
     <br>コードとは&emsp;&emsp;&emsp;&emsp;&emsp;<ins>定型コードのセクション</ins></summary>
</details>
<details>
<summary style="list-style-position: outside;">シャドーイングとは&emsp;<ins>既存のものと同名の変数や関数を定義して、</ins>
     <br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<ins>そのスコープで既存の変数や関数にアクセスできなくする機能</ins></summary>
</details>
</ul>

## `/setting.csv` の作成
`/setting.csv` というCSVファイルを作成し、内容を次のようなものにしてください（**文字コードは `UTF-8`** ）。

| name | url | active |
| ---- | ---- | ---- |
|英単語|https&#58;//www.notion.so/～|1|
|Python|https&#58;//www.notion.so/～|0|
|C言語|https&#58;//www.notion.so/～|1|
|簿記試験|https&#58;//www.notion.so/～|0|
|色彩検定|https&#58;//www.notion.so/～|0|

必ず見出し行を設けてください。

各列についての説明は次のとおりです。

* `name` 列: 出来上がるPDFの名前。  
※拡張子 `.pdf` は含まないでください。また、重複した値にしないでください。
* `url` 列: Notion記事のURL。
* `active` 列: 処理の対象にするかどうか。python で `True` に評価できる値なら処理の対象に含み、`False` に評価できる値なら処理の対象から除きます。


# 使い方
[準備](#準備 "準備")は必ず済ませておいてください。

[流れ](#流れ "流れ")で説明したステップをそれぞれ実行する場合、次の名前のバッチファイルを実行してください。（エクスプローラでのダブルクリックで実行できます）
* `/Step1 - notion2html.bat`
* `/Step2 - reform_html.bat`
* `/Step3 - html2pdf.bat`
* `/Step4 - combine_pdfs.bat`

反対に、4つのステップを一気に実行したい場合は、次の名前のバッチファイルを実行してください。
* `/OneStop - do_all_at_once.bat`

Step4まで終えてできる最終的なPDFは `/pdf/combined/` に保存されます。

# 作成者
Kanta Yasuda (@kyasuda516)

# ライセンス
This software is released under the MIT License, see LICENSE.
