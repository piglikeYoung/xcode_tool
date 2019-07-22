#! /bin/bash
# mv ~/Library/Developer/Xcode/UserData/CodeSnippets ~/Library/Developer/Xcode/UserData/CodeSnippets.backup

# rm ~/Library/Developer/Xcode/UserData/CodeSnippets

# 拷贝代码块到 Xcode
cp -R ./CodeSnippets ~/Library/Developer/Xcode/UserData/
echo "done"

