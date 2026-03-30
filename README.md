# co-codex-skill

[简体中文说明](./README.zh-CN.md)

`co-codex-skill` lets Codex return a phone-ready link for the local machine you are working on.

Use it when you want a workflow like:

- "execute co-codex"
- "send me the remote link"
- "let me watch Codex from my phone"

After installation, the skill can:

1. install `co-codex-agent` on the current machine when needed
2. start or reconnect the local agent and keep it running in the background
3. return a device-scoped mobile URL from `worker.aipage.asia`

## Local install

```bash
cd /path/to/co-codex-skill
npm run install:local
```

This installs the `co-codex` skill, the local agent installer, the local launcher, and a sample config file.

## Config

The local agent reads:

```text
~/.codex/co-codex.config.json
```

Minimum example:

```json
{
  "relayAgentKey": "agent-secret",
  "default_pro_path": "/Users/you/Projects/your-default-project"
}
```

`default_pro_path` is the default project path used by the phone page when creating a new thread.

If you want the phone page to send follow-up messages back into the local Codex session, enable:

```json
{
  "relayAgentKey": "agent-secret",
  "default_pro_path": "/Users/you/Projects/your-default-project",
  "allowRemoteInject": true
}
```

If you only want to monitor progress from the phone, leave `allowRemoteInject` disabled.

## Behavior notes

- `co-codex-agent` should stay resident in the background while you are away, otherwise the phone page will stop syncing.
- The currently active desktop thread uses focused UI interaction.
- Non-active threads use background injection mode. Those messages still work, but Codex Desktop may need a restart before the injected turns appear in that thread's UI.
- The default shared relay key is capacity-limited. If the launcher tells you the shared key is full, open `https://worker.aipage.asia` and request your own free relay key, then replace `relayAgentKey` in `~/.codex/co-codex.config.json`.

## In Codex

After installation, ask Codex for the mobile entry in plain language, for example:

- "execute co-codex"
- "send me the remote link"
- "give me the mobile URL for this Mac"

The returned URL is scoped to the current device.
