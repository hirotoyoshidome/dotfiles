---
name: llm-tool-design
description: Design LLM-facing tools (MCP servers, function calling) so the model gets the input right the first time — keep full parity with the reference UI, carry requirements in the input schema instead of after-the-fact validation, shape arguments for the LLM instead of copying the upstream API, and make guidance text executable on every client. Use when designing or reviewing tool inputs, error messages, or guidance for LLM clients. LLM 向けツール(MCP・function calling)の入力・エラー文言・案内文の設計とレビューで参照する。
---

# LLM Tool Design

LLM は上流の API も画面も知らない。ツールの型と説明だけを頼りに呼ぶので、正しい呼び方しか書けない形をツール側で用意する。

## 機能を削らない

- LLM 向けに単純化して表現力を削らない。参照実装(既存の画面など)でできることは全部できる形にする。複雑さは入力の設計で吸収する(呼び出し回数が増えるのは許容する)
- 参照実装の送信時の変換を正本にし、そこで表現できることを取りこぼさない

## 要件は型で事前に伝える

- 列挙・範囲・件数・排他・必須・入れ子は入力スキーマ(型)に埋め込む。列挙は `Literal`、範囲・件数はフィールドの制約、排他は `Union`(oneOf)。不正な状態を表現できない形にする
- 実行時の検証は、型で表せない条件付きの組み合わせだけを受け持つ安全網にする。その条件も説明文で事前に伝える
- 自由文字列の列挙が残っていないかなど、スキーマの形は機械で検査する(enforce-by-machine)

## 上流 API の引数を写さない

- ツールとして意味の通る形をこちらで決め、上流が受ける形への変換は内側に閉じる
- 上流の引数定義だけで型を決めない。受け取った値が上流で実際にどう使われるか(分岐・先頭要素だけを使う・無視される条件)まで読む。上流が1つしか見ないなら、配列でなく単数にする
- LLM はイレギュラーな値も渡す前提に立つ。型で表せない組み合わせは、安全側に倒すか、理由を添えて弾く。通常の利用で起きないレアケースは追わない

## 案内は届く相手全部で実行できるように

- 手順を含む案内(エラー文言・説明)は、届くクライアントを全部並べて、全部で実行できるかを確かめる。相手によって実行できる手順が違うなら、出し分けを1つの関数に集め、判定の根拠(capability など)をコメントに残す
- 同じ案内を2か所に持たない。出し分ける側に寄せ、もう一方は「返ってきた案内をそのまま伝える」に留める

## 禁止事項

- 参照実装でできることを、LLM 向けに削ること
- 要件をスキーマで伝えず、実行時の検証エラーで事後に弾く設計
- 上流 API の引数をそのまま写したツール定義
- 一部のクライアントで実行できない手順を、全員向けの案内に書くこと
