#!/usr/bin/env node
import {
  applyRavenLocalConnectionConfig,
  loadRavenLocalConnectionConfig,
} from "./local-config.js";

applyRavenLocalConnectionConfig(await loadRavenLocalConnectionConfig());
await import("./index.js");
