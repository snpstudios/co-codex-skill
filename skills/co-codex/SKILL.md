---
name: co-codex
description: Start or reconnect the local co-codex agent and return a device-scoped mobile URL for monitoring the current machine from a phone. Use when the user asks to "执行co-codex", "远程连接发给我", "给我手机入口", "让我在手机上看 Codex 进度", or otherwise wants the co-codex mobile link for this Mac.
---

# co-codex

Use this skill when the user wants a phone-ready monitoring link for the local Codex work running on this machine.

## What to run

If the local agent binary is missing, install it first:

```bash
"$HOME/.codex/bin/co-codex-agent-install"
```

Then return the device-scoped mobile URL:

```bash
"$HOME/.codex/bin/co-codex-agent" ensure
```

That command will:

- read `RELAY_AGENT_KEY` from the environment, or from `~/.codex/co-codex.config.json`
- start or reconnect the local agent
- wait until the relay has issued a device-scoped mobile URL
- print only the resulting URL

## Expected response

Return the resulting URL directly to the user as the phone entry for the current device.

Example:

```text
https://worker.aipage.asia/?token=...
```

## Config file

If the environment does not already provide `RELAY_AGENT_KEY`, this skill expects:

```json
{
  "relayAgentKey": "agent-secret"
}
```

at:

```text
~/.codex/co-codex.config.json
```

## Notes

- The URL is device-scoped. It should only open the current machine's co-codex view.
- If the user asks to keep working while they are away, this skill only returns the monitoring or control URL. It does not by itself change the Codex task.
