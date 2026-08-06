# install-agents-*.sh から source される共通定義。単独実行しない。

TIMESTAMP="$(date +%Y%m%d%H%M%S)"

# link_path <source> <target> <backup_dir>
# target が既に正しいリンクなら何もしない。実体が存在すれば backup_dir へ退避してからリンクする。
link_path() {
  source_path="$1"
  target_path="$2"
  backup_dir="$3"

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    echo "ok (already linked): $target_path"
    return 0
  fi

  mkdir -p "$(dirname -- "$target_path")" "$backup_dir"

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    backup_path="$backup_dir/$(basename -- "$target_path").$TIMESTAMP.bak"
    mv "$target_path" "$backup_path"
    echo "Backed up: $target_path -> $backup_path"
  fi

  ln -s "$source_path" "$target_path"
  echo "Linked: $target_path -> $source_path"
}
