#!/bin/bash

# 目標目錄
TARGET="/srv/se218-share"
LINK_NAME="se218-share"

# 檢查目標目錄是否存在
if [ ! -d "$TARGET" ]; then
    echo "錯誤：目標目錄 $TARGET 不存在。"
    exit 1
fi

echo "開始在每個使用者家目錄建立軟連結..."

# 遍歷 /home 下的所有目錄
for user_dir in /home/*; do
    # 確保是目錄且排除某些特殊情況
    [[ -d "$user_dir" ]] || continue

    username=$(basename "$user_dir")
    link_path="$user_dir/$LINK_NAME"

    # 檢查是否為有效使用者（可選，增加安全性）
    if ! id "$username" >/dev/null 2>&1; then
        echo "跳過：$username 不是有效的系統使用者。"
        continue
    fi

    # 建立軟連結
    # -s: 建立符號連結
    # -f: 如果連結已存在則覆蓋
    ln -sf "$TARGET" "$link_path"

    # 修改連結的擁有者（-h 表示修改連結本身，而非目標）
    chown -h "$username:$username" "$link_path"

    echo "已為 $username 建立連結：$link_path -> $TARGET"
done

echo "完成。"
