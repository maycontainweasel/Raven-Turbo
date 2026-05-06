#!/usr/bin/env node

import { existsSync, mkdirSync, readdirSync, realpathSync, statSync, unlinkSync } from 'node:fs'
import { dirname, isAbsolute, join, relative, resolve, sep, basename } from 'node:path'
import { spawnSync } from 'node:child_process'

const DEFAULT_SKIP_DIRS = new Set([
  '.git',
  'node_modules',
  '.nuxt',
  '.output',
  '.next',
  '.turbo',
  '.cache',
  '.pnpm-store',
  '.vercel',
  'dist',
  'build',
  'coverage',
  'out',
])

function printHelp() {
  console.log(`Usage:
  pnpm run zip [-- --output <file.zip>]
  pnpm run zip [-- --name <archive-name>]
  pnpm run zip [-- --list]
  pnpm run zip [-- --exclude <path[,path...]>]
  pnpm run zip [-- --max-depth <n>]

What it does:
  - Zips tracked files plus untracked, non-ignored files.
  - Respects each repo's .gitignore recursively.
  - Also discovers nested git repos, such as apps/schema, even if the outer
    repo ignores them.
  - Writes the archive to the repo root by default.

Examples:
  pnpm run zip
  pnpm run zip -- --output /tmp/raven-share.zip
  pnpm run zip -- --name raven-ai-share
  pnpm run zip -- --list
  pnpm run zip -- --exclude apps/schema/.nuxt,apps/raven/.output
`)
}

function parseArgs(argv) {
  const options = {
    listOnly: false,
    output: '',
    name: '',
    maxDepth: 6,
    excludes: [],
    help: false,
  }

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index]

    if (arg === '--') {
      continue
    }

    if (arg === '--help' || arg === '-h') {
      options.help = true
      continue
    }

    if (arg === '--list' || arg === '--dry-run') {
      options.listOnly = true
      continue
    }

    if (arg === '--output') {
      options.output = argv[++index] ?? ''
      continue
    }

    if (arg === '--name') {
      options.name = argv[++index] ?? ''
      continue
    }

    if (arg === '--max-depth') {
      const parsed = Number(argv[++index] ?? '')
      if (Number.isFinite(parsed) && parsed >= 0) {
        options.maxDepth = parsed
      }
      continue
    }

    if (arg === '--exclude') {
      const raw = argv[++index] ?? ''
      const values = raw
        .split(',')
        .map((value) => value.trim())
        .filter(Boolean)
      options.excludes.push(...values)
      continue
    }

    throw new Error(`Unknown argument: ${arg}`)
  }

  return options
}

function runGit(args, cwd, description) {
  const result = spawnSync('git', args, {
    cwd,
    encoding: 'utf8',
    maxBuffer: 1024 * 1024 * 50,
  })

  if (result.error) {
    throw new Error(`Failed to run git for ${description}: ${result.error.message}`)
  }

  if (result.status !== 0) {
    const stderr = (result.stderr ?? '').trim()
    throw new Error(
      `git ${description} failed with exit code ${result.status}${stderr ? `: ${stderr}` : ''}`,
    )
  }

  return (result.stdout ?? '').trimEnd()
}

function getRepoRoot(startDir) {
  let current = runGit(['rev-parse', '--show-toplevel'], startDir, 'rev-parse --show-toplevel').trim()

  while (true) {
    const parent = dirname(current)
    if (parent === current) break
    if (!existsSync(join(parent, '.git'))) break
    current = parent
  }

  return current
}

function safeRealpath(pathName) {
  try {
    return realpathSync(pathName)
  } catch {
    return pathName
  }
}

function isInsideRoot(root, candidate) {
  const rel = relative(root, candidate)
  return rel !== '' && !rel.startsWith(`..${sep}`) && rel !== '..'
}

function toPosixPath(pathName) {
  return pathName.split(sep).join('/')
}

function normalizeRelative(root, absolutePath) {
  return toPosixPath(relative(root, absolutePath))
}

function resolvePathRelativeToRoot(root, value) {
  if (!value) return ''
  return isAbsolute(value) ? value : resolve(root, value)
}

function resolveOutputPath(root, options) {
  if (options.output) {
    return resolvePathRelativeToRoot(root, options.output)
  }

  const archiveName = options.name
    ? options.name.endsWith('.zip')
      ? options.name
      : `${options.name}.zip`
    : `${basename(root)}-ai-share-${new Date().toISOString().replace(/[:]/g, '-')}.zip`

  return join(root, archiveName)
}

function findRepoRoots(root, maxDepth) {
  const discovered = new Set([root])
  const visited = new Set()

  const visit = (dir, depth) => {
    if (depth > maxDepth) return

    const real = safeRealpath(dir)
    if (visited.has(real)) return
    visited.add(real)

    let entries = []
    try {
      entries = readdirSync(dir, { withFileTypes: true })
    } catch {
      return
    }

    for (const entry of entries) {
      if (!entry.isDirectory()) continue
      if (DEFAULT_SKIP_DIRS.has(entry.name)) continue

      const child = join(dir, entry.name)
      if (existsSync(join(child, '.git'))) {
        discovered.add(child)
      }

      visit(child, depth + 1)
    }
  }

  visit(root, 0)
  return [...discovered]
}

function listRepoFiles(repoRoot) {
  const output = runGit(
    ['ls-files', '-z', '--cached', '--others', '--exclude-standard'],
    repoRoot,
    'ls-files',
  )

  if (!output) return []
  return output.split('\0').filter(Boolean)
}

function pathMatchesPrefixes(pathName, prefixes) {
  if (!prefixes.length) return false

  const normalized = toPosixPath(pathName)
  return prefixes.some((prefix) => {
    const candidate = toPosixPath(prefix).replace(/\/+$/g, '')
    if (!candidate) return false
    return normalized === candidate || normalized.startsWith(`${candidate}/`)
  })
}

function buildFileSet(root, repoRoots, options) {
  const outputPath = resolveOutputPath(root, options)
  const outputRel = isInsideRoot(root, outputPath) ? normalizeRelative(root, outputPath) : ''
  const explicitExcludes = options.excludes
    .map((value) => resolvePathRelativeToRoot(root, value))
    .map((value) => (isInsideRoot(root, value) ? normalizeRelative(root, value) : toPosixPath(value)))

  const files = new Set()

  for (const repoRoot of repoRoots) {
    const repoFiles = listRepoFiles(repoRoot)
    for (const repoFile of repoFiles) {
      const absoluteFile = join(repoRoot, repoFile)
      if (!existsSync(absoluteFile)) continue

      const relativeFile = normalizeRelative(root, absoluteFile)
      if (!relativeFile || relativeFile.startsWith('..')) continue
      if (relativeFile === outputRel) continue
      if (pathMatchesPrefixes(relativeFile, explicitExcludes)) continue

      files.add(relativeFile)
    }
  }

  return { files: [...files].sort(), outputPath }
}

function totalBytes(root, files) {
  return files.reduce((sum, file) => {
    try {
      return sum + statSync(join(root, file)).size
    } catch {
      return sum
    }
  }, 0)
}

function createZip(root, files, outputPath) {
  const zipArgs = ['-q', '-@', outputPath]
  const result = spawnSync('zip', zipArgs, {
    cwd: root,
    input: `${files.join('\n')}\n`,
    encoding: 'utf8',
    maxBuffer: 1024 * 1024 * 20,
  })

  if (result.error) {
    throw new Error(`Failed to run zip: ${result.error.message}`)
  }

  if (result.status !== 0) {
    const stderr = (result.stderr ?? '').trim()
    throw new Error(
      `zip failed with exit code ${result.status}${stderr ? `: ${stderr}` : ''}`,
    )
  }
}

function main() {
  const options = parseArgs(process.argv.slice(2))

  if (options.help) {
    printHelp()
    return
  }

  const cwd = process.cwd()
  const root = getRepoRoot(cwd)
  const repoRoots = findRepoRoots(root, options.maxDepth)
  const { files, outputPath } = buildFileSet(root, repoRoots, options)

  if (!files.length) {
    throw new Error('No files were selected for the archive.')
  }

  const bytes = totalBytes(root, files)
  const archiveDir = dirname(outputPath)
  if (!existsSync(archiveDir)) {
    mkdirSync(archiveDir, { recursive: true })
  }

  if (options.listOnly) {
    console.log(`Repo root: ${root}`)
    console.log(`Nested repo roots: ${repoRoots.map((repoRoot) => normalizeRelative(root, repoRoot) || '.').join(', ')}`)
    console.log(`Archive path: ${outputPath}`)
    console.log(`Files: ${files.length}`)
    console.log(`Bytes: ${bytes}`)
    console.log('')
    files.forEach((file) => console.log(file))
    return
  }

  if (existsSync(outputPath)) {
    // Remove any previous archive so zip does not prompt or append.
    try {
      unlinkSync(outputPath)
    } catch {
      // Ignore stale output cleanup failures and let zip surface the error.
    }
  }

  createZip(root, files, outputPath)

  console.log(`Created archive: ${outputPath}`)
  console.log(`Included files: ${files.length}`)
  console.log(`Included bytes: ${bytes}`)
  console.log(`Repo roots: ${repoRoots.map((repoRoot) => normalizeRelative(root, repoRoot) || '.').join(', ')}`)
}

try {
  main()
} catch (error) {
  console.error(error instanceof Error ? error.message : String(error))
  process.exitCode = 1
}
