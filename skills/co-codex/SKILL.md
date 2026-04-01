---
name: co-codex
description: Start or reconnect the local co-codex agent and return a device-scoped mobile URL for monitoring the current machine from a phone. Use when the user asks to "执行co-codex", "远程连接发给我", "给我手机入口", "让我在手机上看 Codex 进度", or otherwise wants the co-codex mobile link for this Mac.
---

# co-codex

Use this skill when the user wants a phone-ready monitoring link for the local Codex work running on this machine.

## What to run

Use the local launcher:

```bash
"$HOME/.codex/bin/co-codex"
```

That command will:

- install `co-codex-agent` when needed
- read config from `~/.codex/co-codex.config.json`
- start or reconnect the local agent inside the current Codex session
- print the device-scoped mobile URL as soon as the relay issues it
- keep running in that thread so the agent stays alive

## Expected response

Return the resulting URL directly to the user as the phone entry for the current device.
The shell command itself is expected to keep running in that thread after the URL appears.

Example:

```text
https://worker.aipage.asia/?token=...
```

## Config file

If the environment does not already provide `RELAY_AGENT_KEY`, this skill expects:

```json
{
  "relayAgentKey": "agent-secret",
  "default_pro_path": "/Users/you/Projects/your-default-project"
}
```

at:

```text
~/.codex/co-codex.config.json
```

Users can get their own `relayAgentKey` from `https://worker.aipage.asia` after signing in with GitHub. Each personal key currently binds one agent.

## Notes

- The URL is device-scoped. It should only open the current machine's co-codex view.
- The `co-codex` command should stay running in its own Codex thread after it prints the URL. If that thread is interrupted or the agent exits, the phone page will stop updating and command delivery will fail.
- Viewing progress from the phone works by default.
- Sending follow-up messages back into the local Codex session requires `allowRemoteInject` to be enabled in `~/.codex/co-codex.config.json`.
- For desktop UI interaction, macOS also needs to grant the local terminal / launcher process Accessibility-style system control permission. Without that permission, monitoring can still work, but remote message injection may fail.
- Keep `allowRemoteInject` off if the user only wants monitoring.
- `default_pro_path` in `~/.codex/co-codex.config.json` is used as the default project path when the phone page creates a new thread.
- For non-active threads, co-codex uses background injection mode. The message still works, but Codex Desktop may need a restart before that thread shows the new turns in the UI.
- If the shared relay key has reached its device limit, tell the user to open `https://worker.aipage.asia` and get their own free relay key, then update `relayAgentKey` in `~/.codex/co-codex.config.json`.
- If the user is already using a personal key, remember that each personal key currently supports one agent binding.
- If the user asks to keep working while they are away, this skill only returns the monitoring or control URL. It does not by itself change the Codex task.
