# co-codex-skill

[English README](./README.md)

`co-codex-skill` 的作用是：让 Codex 把当前这台机器的手机入口直接返回给你。

适合这种使用方式：

- “执行 co-codex”
- “把远程连接发给我”
- “我要在手机上看 Codex 进度”

安装后，这个 skill 会：

1. 在需要时自动安装 `co-codex-agent`
2. 在当前 Codex 会话里启动或重连本地 agent
3. 在手机入口就绪后立刻输出当前设备专属的访问 URL，入口来自 `worker.aipage.asia`

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

后续你可以直接在 `https://worker.aipage.asia` 用 GitHub 登录，获取你自己的 `relayAgentKey`。目前每把个人 key 只支持绑定 1 个 agent。

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

- 启动 `co-codex` 的那个 Codex 线程需要保持打开。这条长会话本身就是本地 agent 的存活载体。
- 只要该线程被打断，或者 agent 退出，手机端就会停止同步，也无法继续发命令。
- 如果你希望手机端把 follow-up 回发到本地 Codex Desktop，macOS 还需要给本地终端 / launcher 对应的进程授予辅助功能这类系统操作权限。没有这类权限时，手机端查看进度仍然可用，但回发消息到桌面 UI 可能失败。
- 当前激活线程继续走桌面 UI 交互。
- 非激活线程会走后台注入模式。消息仍然会生效，但该线程在 Codex Desktop 里的新增对话，可能要重启后才会显示出来。
- 默认共享的 relay key 有设备数量上限。如果启动时提示共享 key 已满，请打开 `https://worker.aipage.asia` 获取你自己的免费 relay key，然后替换 `~/.codex/co-codex.config.json` 里的 `relayAgentKey`。
- 当前每把个人 `relayAgentKey` 只支持 1 个 agent 绑定。如果你要换机器，请先回收或更换这把 key。
- 如果你发现 co-codex 的行为和当前说明不一致，先重新安装 skill，或对照这个 GitHub 仓库里的最新说明再继续排查。

## 在 Codex 里使用

安装完成后，直接对 Codex 说：

- “执行 co-codex”
- “把远程连接发给我”
- “给我这台 Mac 的手机入口”

返回的链接只对应当前这台设备。
