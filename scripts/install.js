const fs = require("fs");
const os = require("os");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");
const CODEX_HOME = process.env.CODEX_HOME || path.join(os.homedir(), ".codex");
const SKILL_SRC = path.join(ROOT, "skills", "co-codex", "SKILL.md");
const INSTALLER_SRC = path.join(ROOT, "templates", "co-codex-agent-install.sh");
const LAUNCHER_SRC = path.join(ROOT, "templates", "co-codex.sh");
const CONFIG_EXAMPLE_SRC = path.join(ROOT, "templates", "co-codex.config.example.json");
const SKILL_DIR = path.join(CODEX_HOME, "skills", "co-codex");
const BIN_DIR = path.join(CODEX_HOME, "bin");
const INSTALLED_SKILL = path.join(SKILL_DIR, "SKILL.md");
const INSTALLED_INSTALLER = path.join(BIN_DIR, "co-codex-agent-install");
const INSTALLED_LAUNCHER = path.join(BIN_DIR, "co-codex");
const CONFIG_EXAMPLE_DEST = path.join(CODEX_HOME, "co-codex.config.example.json");

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function installSkill() {
  ensureDir(SKILL_DIR);
  fs.copyFileSync(SKILL_SRC, INSTALLED_SKILL);
}

function installAgentInstaller() {
  ensureDir(BIN_DIR);
  fs.copyFileSync(INSTALLER_SRC, INSTALLED_INSTALLER);
  fs.chmodSync(INSTALLED_INSTALLER, 0o755);
}

function installLauncher() {
  ensureDir(BIN_DIR);
  fs.copyFileSync(LAUNCHER_SRC, INSTALLED_LAUNCHER);
  fs.chmodSync(INSTALLED_LAUNCHER, 0o755);
}

function installConfigExample() {
  fs.copyFileSync(CONFIG_EXAMPLE_SRC, CONFIG_EXAMPLE_DEST);
}

function main() {
  installSkill();
  installAgentInstaller();
  installLauncher();
  installConfigExample();

  process.stdout.write(
    JSON.stringify(
      {
        skill: INSTALLED_SKILL,
        installer: INSTALLED_INSTALLER,
        launcher: INSTALLED_LAUNCHER,
        configExample: CONFIG_EXAMPLE_DEST,
      },
      null,
      2,
    ) + "\n",
  );
}

main();
