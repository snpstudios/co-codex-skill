# co-codex-skill

[English README](./README.md)

`co-codex-skill` 的作用是：让 Codex 把当前这台机器的手机入口直接返回给你。

适合这种使用方式：

- “执行 co-codex”
- “把远程连接发给我”
- “我要在手机上看 Codex 进度”

安装后，这个 skill 会：

1. 在需要时自动安装 `co-codex-agent`
2. 启动或重连本地 agent，并让它常驻后台
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
  "relayAgentKey": "agent-secret",
  "default_pro_path": "/Users/you/Projects/your-default-project"
}
```

后续你可以直接在 `https://worker.aipage.asia` 用 GitHub 登录，获取你自己的 `relayAgentKey`。

`default_pro_path` 用来指定“新线程”默认的项目路径，手机端创建新线程时会优先带出这个值。

如果你希望手机端不仅能看，还能把 follow-up 发回本地 Codex，会话配置里还要打开：

```json
{
  "relayAgentKey": "agent-secret",
  "default_pro_path": "/Users/you/Projects/your-default-project",
  "allowRemoteInject": true
}
```

如果你只想在手机上看进度，不需要回发消息，就不要打开 `allowRemoteInject`。

## 行为说明

- `co-codex-agent` 需要常驻后台。只要 agent 退出，手机端就会停止同步，也无法继续发命令。
- 当前激活线程继续走桌面 UI 交互。
- 非激活线程会走后台注入模式。消息仍然会生效，但该线程在 Codex Desktop 里的新增对话，可能要重启后才会显示出来。
- 默认共享的 relay key 有设备数量上限。如果启动时提示共享 key 已满，请打开 `https://worker.aipage.asia` 获取你自己的免费 relay key，然后替换 `~/.codex/co-codex.config.json` 里的 `relayAgentKey`。

## 在 Codex 里使用

安装完成后，直接对 Codex 说：

- “执行 co-codex”
- “把远程连接发给我”
- “给我这台 Mac 的手机入口”

返回的链接只对应当前这台设备。
