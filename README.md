#### 起動

```shell script
$vagrant up

# 初回だけ
$vagrant provision
```

http://192.168.33.11:8080 でアプリにアクセスできます。
ユーザ名は `user` です。
パスワードは以下のコマンドで確認してください。

```shell script
$vagrant ssh -c "sudo journalctl -u demoapp"
```
