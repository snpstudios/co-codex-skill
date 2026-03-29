# co-codex-skill

[简体中文说明](./README.zh-CN.md)

`co-codex-skill` lets Codex return a phone-ready link for the local machine you are working on.

Use it when you want a workflow like:

- "execute co-codex"
- "send me the remote link"
- "let me watch Codex from my phone"

After installation, the skill can:

1. install `co-codex-agent` on the current machine when needed
2. start or reconnect the local agent
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
  "relayAgentKey": "agent-secret"
}
```

If you want the phone page to send follow-up messages back into the local Codex session, enable:

```json
{
  "relayAgentKey": "agent-secret",
  "allowRemoteInject": true
}
```

If you only want to monitor progress from the phone, leave `allowRemoteInject` disabled.

## In Codex

After installation, ask Codex for the mobile entry in plain language, for example:

- "execute co-codex"
- "send me the remote link"
- "give me the mobile URL for this Mac"

The returned URL is scoped to the current device.
