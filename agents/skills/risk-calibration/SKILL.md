---
name: risk-calibration
description: Apply strict-by-principle handling to security, auth, and data correctness even for low-probability risks, while deliberately accepting rare functional edge cases when maintenance cost outweighs benefit — and state which regime applies before proposing. Use when assessing risks, deciding how far to harden, reviewing for bugs, or scoping edge-case handling. リスク評価・エッジケース対応の範囲決め・堅牢化の程度の判断・バグ調査のスコープ決めで必ず参照する。
---

# Risk Calibration

すべてのリスクを同じ強度で扱わない。「原則で潰す領域」と「保守コストで割り切る領域」を区別し、どちらの話をしているかを先に宣言する。

## 原則で潰す領域(確率で妥協しない)

- セキュリティ・認証・認可・秘密情報の扱いは、発生確率が低くても原則で潰す。利便性・実装の楽さとトレードしない
- データの正確性(数値・集計・課金に関わる値)の誤りは致命的として扱う。「レアケースだから」で許容しない
- この領域では「リスクは低い」を対応しない理由にしない。認識合わせを省略しない

## 割り切る領域(保守コストと比べる)

- 機能のレアなエッジケースの網羅は、対応コスト・保守コストと比べて割り切ってよい。バグゼロは目標にしない(基本的な対策は必要だが、極端なエッジケース全対応はむしろ保守性を下げる)
- 粗探し的な見直し・局所最適の細かい修正を自発的に積まない。一般的に危ない「ド真ん中」に絞る

## 提案時の作法

- リスク対応を提案するときは、それがどちらの領域の話かを最初に明示する
- 割り切る判断をしたときは「何を許容したか」を理由付きで記録する(scope-boundaries)

## 禁止事項

- セキュリティ・データ正確性の問題を「発生確率が低い」ことを理由に許容すること
- 機能エッジケースの網羅を、保守コストの評価なしに積み上げること
- どちらの領域の話かを示さずにリスク対応を提案すること
- 「完全にバグがない状態」を目標にした粗探しの修正提案
