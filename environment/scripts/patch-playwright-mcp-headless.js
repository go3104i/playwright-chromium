#!/usr/bin/env node
const fs = require("fs");
const path = require("path");

const repoRoot = process.env.PW_CHROMIUM_ROOT
  ? path.resolve(process.env.PW_CHROMIUM_ROOT)
  : path.resolve(__dirname, "../..");
const cliPath = path.join(repoRoot, "node_modules", "@playwright", "mcp", "cli.js");
const marker = "playwright-chromium: dynamic __pwRoot";

if (!fs.existsSync(cliPath)) {
  process.exit(0);
}

let src = fs.readFileSync(cliPath, "utf8");
if (src.includes(marker)) {
  process.exit(0);
}

const needle = "void program.parseAsync(process.argv);";
const patch = `// ${marker}
const path = require('path');
const __pwRoot = path.resolve(__dirname, '../../..');
const __pwConfig = path.join(__pwRoot, 'playwright-mcp.json');
const __pwSecrets = path.join(__pwRoot, 'environment', 'playwright-mcp.secrets.env');
if (!process.argv.includes('--headless')) {
  process.argv.push('--headless');
}
if (!process.argv.some((arg) => arg.startsWith('--config'))) {
  process.argv.push('--config', __pwConfig);
}
if (!process.argv.some((arg) => arg.startsWith('--secrets'))) {
  process.argv.push('--secrets', __pwSecrets);
}

void program.parseAsync(process.argv);`;

if (!src.includes(needle)) {
  console.error("playwright-mcp cli.js layout changed; patch not applied");
  process.exit(1);
}

src = src.replace(needle, patch);
fs.writeFileSync(cliPath, src);
