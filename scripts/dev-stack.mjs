#!/usr/bin/env node

import { spawn, spawnSync } from 'node:child_process'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const scriptDirectory = dirname(fileURLToPath(import.meta.url))
const repoRoot = resolve(scriptDirectory, '..')
const typesenseComposeFile = resolve(repoRoot, 'apps/raven/docker-compose.typesense.yml')

export function redactDevOutput(value) {
  return String(value)
    .replace(/(--pass(?:=|\s+))(?:"[^"]*"|'[^']*'|\S+)/g, '$1[redacted]')
    .replace(/(NUXT_SURREALDB_PASS=)\S+/g, '$1[redacted]')
}

export function processGroupTarget(pid, platform = process.platform) {
  return platform === 'win32' ? pid : -pid
}

function pipeRedacted(stream, target) {
  let pending = ''
  stream.setEncoding('utf8')
  stream.on('data', (chunk) => {
    pending += chunk
    const lines = pending.split(/\r?\n/)
    pending = lines.pop() ?? ''
    for (const line of lines) {
      target.write(`${redactDevOutput(line)}\n`)
    }
  })
  stream.on('end', () => {
    if (pending) target.write(redactDevOutput(pending))
  })
}

function ensureNginx() {
  const result = spawnSync('brew', ['services', 'start', 'nginx'], {
    cwd: repoRoot,
    encoding: 'utf8',
  })

  if (result.error) {
    throw new Error(`Unable to start Nginx: ${result.error.message}`)
  }
  if (result.status !== 0) {
    const detail = redactDevOutput(result.stderr || result.stdout || 'unknown error').trim()
    throw new Error(`Unable to start Nginx: ${detail}`)
  }
}

function stopTypesense() {
  spawnSync(
    'docker',
    ['compose', '-p', 'raven-dev', '-f', typesenseComposeFile, 'stop', 'typesense'],
    { cwd: repoRoot, stdio: 'ignore', timeout: 10_000 },
  )
}

function signalProcessGroup(child, signal) {
  if (!child?.pid) return
  try {
    process.kill(processGroupTarget(child.pid), signal)
  } catch (error) {
    if (error?.code !== 'ESRCH' && error?.code !== 'EPERM') throw error
  }
}

export async function runDevStack() {
  ensureNginx()

  process.stdout.write(
    [
      'Raven development stack',
      '  App:       https://raven:4443',
      '  Studio:    http://127.0.0.1:9275',
      '  SurrealDB: http://127.0.0.1:2993',
      '  Typesense: http://127.0.0.1:8110',
      '  Stop:      Ctrl+C',
      '',
    ].join('\n'),
  )

  const child = spawn('sm', ['up', '.'], {
    cwd: repoRoot,
    detached: process.platform !== 'win32',
    env: process.env,
    stdio: ['inherit', 'pipe', 'pipe'],
  })

  pipeRedacted(child.stdout, process.stdout)
  pipeRedacted(child.stderr, process.stderr)

  let stopping = false
  let intendedExitCode = 0
  let forceTimer

  const finishShutdown = () => {
    signalProcessGroup(child, 'SIGKILL')
    stopTypesense()
    process.exit(intendedExitCode)
  }

  const requestShutdown = (signal, exitCode = 0) => {
    if (stopping) {
      finishShutdown()
      return
    }

    stopping = true
    intendedExitCode = exitCode
    process.stdout.write(`\nStopping Raven development stack...\n`)
    signalProcessGroup(child, signal)
    forceTimer = setTimeout(finishShutdown, 5_000)
  }

  for (const signal of ['SIGINT', 'SIGTERM', 'SIGHUP']) {
    process.on(signal, () => requestShutdown(signal))
  }

  child.once('error', (error) => {
    process.stderr.write(`Unable to start the Raven development stack: ${error.message}\n`)
    requestShutdown('SIGTERM', 1)
  })

  child.once('exit', (code, signal) => {
    if (stopping) return

    if (signal) {
      requestShutdown('SIGTERM', 1)
      return
    }

    requestShutdown('SIGTERM', code ?? 1)
  })

  process.on('exit', () => {
    if (forceTimer) clearTimeout(forceTimer)
    signalProcessGroup(child, 'SIGKILL')
  })
}

const invokedDirectly = process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)
if (invokedDirectly) {
  runDevStack().catch((error) => {
    process.stderr.write(`${redactDevOutput(error.message)}\n`)
    process.exitCode = 1
  })
}
