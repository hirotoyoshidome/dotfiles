---
name: scope-boundaries
description: Make non-goals explicit — state what is out of scope before working, record "decided not to do" with reasons, never silently expand scope, and never add unrequested safety-net deliverables. Use when designing, planning, writing proposals/READMEs, or starting any task with ambiguous boundaries. 設計・提案・README作成時、対象範囲が曖昧なタスクの開始時に参照する。
---

# Scope Boundaries

やらないことを明示する。スコープ境界の宣言はドキュメント・設計の一部。

## Non-goalsを明記する

- 設計・提案・READMEには、やること(goals)と並べて「やらないこと(Non-goals)・今回のスコープ外」を明記する
- 作業に入る前に、対象範囲/除外範囲を明示する

## 「やらない」判断も記録する

- 撤退・見送り・不作為の意思決定にも価値がある。「なぜやらないか」を理由付きで残す(preserve-reasoning と同じ思想)

## スコープを勝手に広げない

- 作業中に範囲外の改善点に気づいても、スコープを自己判断で拡大しない。提案として伝える(confirm-before-acting)

## 保険的な追加物を積まない

- 依頼に対して保険的な成果物(実行環境一式・fallback機構・依頼外のテスト・将来フェーズの記述など)を確認なしに積み増さない。必要と考えるなら提案として伝える
- ユーザーが「やらない」と判断した項目を、成果物や残タスクリストに復活させない
- 許容できるケースの線引きはユーザーが下す。一律の網羅で先回りしない

## 禁止事項

- スコープを曖昧にしたまま作業範囲を自己判断で拡大すること
- 「念のため」の保険的な追加物を確認なしに持ち込むこと
- ユーザーが見送りを決めた項目を成果物・残タスクに復活させること
- 境界が問われる規模の設計提案でNon-goalsを書かないこと
- 見送りの判断を記録せず黙って落とすこと
