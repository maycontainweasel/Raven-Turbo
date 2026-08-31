#!/usr/bin/env node
import { readFileSync, existsSync } from 'node:fs'
import { spawn } from 'node:child_process'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const scriptPath = fileURLToPath(import.meta.url)
const appRoot = resolve(dirname(scriptPath), '..')

function decodeCommand(argv) {
  const prefix = '--command-base64='
  const encoded = argv.find((entry) => entry.startsWith(prefix))
  if (!encoded) return null
  try {
    return Buffer.from(encoded.slice(prefix.length), 'base64').toString('utf8').trim()
  } catch {
    return null
  }
}

function stripWrappingQuotes(value) {
  if (
    value.length >= 2 &&
    ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'")))
  ) {
    return value.slice(1, -1)
  }
  return value
}

function readSiteUrlFromDotEnv() {
  const envPath = resolve(appRoot, '.env')
  if (!existsSync(envPath)) return null
  const raw = readFileSync(envPath, 'utf8')
  const lines = raw.split(/\r?\n/)
  for (const line of lines) {
    const trimmed = line.trim()
    if (!trimmed || trimmed.startsWith('#')) continue
    const separator = trimmed.indexOf('=')
    if (separator === -1) continue
    const key = trimmed.slice(0, separator).trim()
    if (key !== 'NUXT_SITEURL') continue
    const value = stripWrappingQuotes(trimmed.slice(separator + 1).trim())
    return value || null
  }
  return null
}

const command = decodeCommand(process.argv.slice(2))
if (!command) {
  console.error('schema-dev: missing --command-base64')
  process.exit(1)
}

const siteUrl = readSiteUrlFromDotEnv()
if (siteUrl) {
  console.log('')
  console.log('Schema dev URL:', siteUrl)
  console.log('')
}

const child = spawn(command, {
  cwd: appRoot,
  stdio: 'inherit',
  shell: true,
  env: process.env,
})

child.on('error', (error) => {
  console.error('schema-dev: failed to start dev command')
  console.error(error instanceof Error ? error.message : String(error))
  process.exit(1)
})

child.on('exit', (code, signal) => {
  if (signal) {
    process.kill(process.pid, signal)
    return
  }
  process.exit(code ?? 0)
})
