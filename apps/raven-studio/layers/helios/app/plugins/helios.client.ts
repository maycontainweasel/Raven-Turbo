import type {
  HeliosNodeCreateInput,
  HeliosNodePatch,
  HeliosNodeRecord,
  HeliosRecordRef,
} from '@helios/protocol'
import { useHeliosRuntimeStore } from '../stores/heliosRuntime'

const SETTINGS_EVENT = 'helios:open-runtime-settings'

export default defineNuxtPlugin(() => {
  const runtime = useHeliosRuntimeStore()

  const isEditingText = (target: EventTarget | null) => {
    if (!(target instanceof HTMLElement)) return false
    const tag = target.tagName.toLowerCase()
    return tag === 'input' || tag === 'textarea' || tag === 'select' || target.isContentEditable
  }

  const onKeydown = async (event: KeyboardEvent) => {
    if (isEditingText(event.target)) return

    if (event.metaKey && !event.altKey && event.key.toLowerCase() === 'c') {
      if (!runtime.active) return
      if (!runtime.selectedNodeId) return
      event.preventDefault()
      runtime.copySelectedFrame()
      return
    }

    if (event.metaKey && !event.altKey && event.key.toLowerCase() === 'v') {
      if (!runtime.active) return
      event.preventDefault()
      if (event.ctrlKey) {
        await runtime.pasteCopiedFrameInsideSelected()
      } else {
        await runtime.pasteCopiedFrame()
      }
      return
    }

    if (event.metaKey || event.ctrlKey || event.altKey) return

    if (event.key === 'f' || event.key === 'F') {
      event.preventDefault()
      runtime.setActive(true)
      runtime.setTool('draw')
      return
    }

    if (event.key === 'v' || event.key === 'V') {
      event.preventDefault()
      runtime.setActive(true)
      runtime.setTool('select')
      return
    }

    if (event.key === 'w' || event.key === 'W') {
      if (!runtime.active) return
      event.preventDefault()
      runtime.setRuntimeMode(runtime.runtimeMode === 'widget' ? 'frame' : 'widget')
      return
    }

    if (event.key === 'y' || event.key === 'Y') {
      if (!runtime.active) return
      event.preventDefault()
      window.dispatchEvent(new CustomEvent(SETTINGS_EVENT, { detail: { section: 'runtime' } }))
      return
    }

    if (event.key === 'Escape') {
      if (!runtime.active) return
      runtime.setDraftRect(null)
      runtime.clearSelection()
      return
    }

    if (event.key === ' ') {
      event.preventDefault()
      runtime.toggleActive()
      return
    }

    if (event.key === 's' || event.key === 'S') {
      if (!runtime.active || !runtime.selectedNodeId) return
      event.preventDefault()
      runtime.toggleFrameOptions()
      return
    }

    if (event.key === 'd' || event.key === 'D') {
      if (!runtime.active || !runtime.selectedNodeId) return
      event.preventDefault()
      await runtime.toggleFrameControlMode()
      return
    }

    if (event.key === 't' || event.key === 'T') {
      if (!runtime.active) return
      event.preventDefault()
      runtime.setRuntimeMode('widget')
      await runtime.createTextNode()
      return
    }

    if (event.key === 'r' || event.key === 'R') {
      event.preventDefault()
      if (event.shiftKey) {
        runtime.cycleBreakpointPrevious()
      } else {
        runtime.cycleBreakpoint()
      }
      return
    }

    if (event.key === 'l' || event.key === 'L') {
      if (!runtime.active) return
      if (!runtime.selectedNodeId) return
      event.preventDefault()
      await runtime.toggleNodeLock()
      return
    }

    if (event.key === 'Delete' || event.key === 'Backspace') {
      if (!runtime.active) return
      if (!runtime.selectedNodeId) return
      event.preventDefault()
      if (runtime.isNodeLocked(runtime.selectedNodeId)) return
      if (window.confirm('Delete selected Helios node?')) {
        await runtime.deleteSelectedNode()
      }
    }
  }

  window.addEventListener('keydown', onKeydown)

  const helios = {
    listNodes(input: { documentId: string; zoneId?: string }) {
      return $fetch<{ ok: boolean; nodes: HeliosNodeRecord[] }>('/api/helios/nodes', {
        query: input,
      })
    },
    createNode(input: HeliosNodeCreateInput) {
      return $fetch<{ ok: boolean; node: HeliosNodeRecord }>('/api/helios/nodes', {
        method: 'POST',
        body: input,
      })
    },
    updateNode(record: string | HeliosRecordRef, patch: HeliosNodePatch) {
      return $fetch<{ ok: boolean; node: HeliosNodeRecord }>('/api/helios/nodes', {
        method: 'PATCH',
        body: { record, patch },
      })
    },
    deleteNode(record: string | HeliosRecordRef) {
      return $fetch<{ ok: boolean }>('/api/helios/nodes', {
        method: 'DELETE',
        body: { record },
      })
    },
    migrate() {
      return $fetch<{ ok: boolean; notes: string[] }>('/api/helios/setup/migrate', {
        method: 'POST',
      })
    },
    agentContext() {
      return $fetch('/api/helios/agent/context')
    },
  }

  return {
    provide: {
      helios,
    },
  }
})
