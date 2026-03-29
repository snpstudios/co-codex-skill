# co-codex-skill

[English README](./README.md)

`co-codex-skill` 的作用是：让 Codex 把当前这台机器的手机入口直接返回给你。

适合这种使用方式：

- “执行 co-codex”
- “把远程连接发给我”
- “我要在手机上看 Codex 进度”

安装后，这个 skill 会：

1. 在需要时自动安装 `co-codex-agent`
2. 启动或重连本地 agent
3. 返回当前设备专属的手机访问 URL，入口来自 `worker.aipage.asia`

## 本地安装

```bash
cd /path/to/co-codex-skill
npm run install:local
```

这会安装 `co-codex` skill、本地 agent 安装器、本地 launcher，以及一份示例配置文件。

## 配置

本地 agent 读取：

```text
~/.codex/co-codex.config.json
```

最小配置示例：

```json
{
  "relayAgentKey": "agent-secret"
}
```

如果你希望手机端不仅能看，还能把 follow-up 发回本地 Codex，会话配置里还要打开：

```json
{
  "relayAgentKey": "agent-secret",
  "allowRemoteInject": true
}
```

如果你只想在手机上看进度，不需要回发消息，就不要打开 `allowRemoteInject`。

## 在 Codex 里使用

安装完成后，直接对 Codex 说：

- “执行 co-codex”
- “把远程连接发给我”
- “给我这台 Mac 的手机入口”

返回的链接只对应当前这台设备。
