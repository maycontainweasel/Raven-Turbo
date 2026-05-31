<template>
  <div class="raven-shell">
    <div class="raven-shell__mesh" aria-hidden="true" />
    <div class="raven-shell__orb raven-shell__orb--one" aria-hidden="true" />
    <div class="raven-shell__orb raven-shell__orb--two" aria-hidden="true" />

    <header class="raven-shell__topbar">
      <NuxtLink to="/" class="raven-shell__brand" aria-label="Raven home">
        <span class="raven-shell__brand-mark">R</span>
        <span>Raven</span>
      </NuxtLink>

      <nav class="raven-shell__nav" aria-label="Primary navigation">
        <NuxtLink to="/" class="raven-shell__nav-link">Truth</NuxtLink>
        <NuxtLink to="/future/buckets" class="raven-shell__nav-link">Buckets Lab</NuxtLink>
        <NuxtLink to="/clients" class="raven-shell__nav-link">Clients</NuxtLink>
        <NuxtLink to="/retainers" class="raven-shell__nav-link">Retainers</NuxtLink>
      </nav>
    </header>

    <main class="raven-shell__frame">
      <slot />
    </main>
  </div>
</template>

<style scoped>
.raven-shell {
  position: relative;
  min-height: 100vh;
  overflow: hidden;
  font-family: 'Space Grotesk', sans-serif;
  font-optical-sizing: auto;
  background:
    radial-gradient(circle at top left, rgba(34, 211, 238, 0.16), transparent 34%),
    radial-gradient(circle at 82% 18%, rgba(59, 130, 246, 0.11), transparent 28%),
    radial-gradient(circle at 50% 110%, rgba(16, 185, 129, 0.08), transparent 30%),
    linear-gradient(180deg, #02040a 0%, #040814 46%, #02040a 100%);
  color: #e5eefb;
}

:global(body) {
  margin: 0;
  background: #02040a;
}

.raven-shell__mesh {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(148, 163, 184, 0.08) 1px, transparent 1px),
    linear-gradient(90deg, rgba(148, 163, 184, 0.08) 1px, transparent 1px);
  background-size: 72px 72px;
  mask-image: linear-gradient(180deg, rgba(0, 0, 0, 0.62), transparent 86%);
  opacity: 0.42;
  pointer-events: none;
}

.raven-shell__orb {
  position: absolute;
  border-radius: 9999px;
  filter: blur(72px);
  pointer-events: none;
  animation: raven-float 18s ease-in-out infinite;
}

.raven-shell__orb--one {
  top: -8rem;
  left: -7rem;
  height: 22rem;
  width: 22rem;
  background: radial-gradient(circle, rgba(34, 211, 238, 0.3) 0%, rgba(34, 211, 238, 0.06) 42%, transparent 78%);
}

.raven-shell__orb--two {
  right: -8rem;
  bottom: -10rem;
  height: 28rem;
  width: 28rem;
  background: radial-gradient(circle, rgba(16, 185, 129, 0.22) 0%, rgba(16, 185, 129, 0.05) 42%, transparent 78%);
  animation-duration: 24s;
  animation-direction: reverse;
}

.raven-shell__topbar {
  position: relative;
  z-index: 2;
  display: flex;
  width: min(100%, 90rem);
  margin: 0 auto;
  padding: 1rem 1rem 0;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}

.raven-shell__brand {
  display: inline-flex;
  align-items: center;
  gap: 0.65rem;
  color: #f8fafc;
  font-size: 0.94rem;
  font-weight: 700;
  letter-spacing: -0.03em;
  text-decoration: none;
}

.raven-shell__brand-mark {
  display: inline-grid;
  height: 2rem;
  width: 2rem;
  place-items: center;
  border: 1px solid rgba(103, 232, 249, 0.26);
  border-radius: 0.85rem;
  background: rgba(34, 211, 238, 0.1);
  box-shadow: 0 0 28px rgba(34, 211, 238, 0.12);
}

.raven-shell__nav {
  display: flex;
  flex-wrap: wrap;
  justify-content: flex-end;
  gap: 0.4rem;
}

.raven-shell__nav-link {
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.045);
  color: #cbd5e1;
  padding: 0.55rem 0.8rem;
  font-size: 0.78rem;
  font-weight: 600;
  text-decoration: none;
  transition: border-color 160ms ease, background 160ms ease, color 160ms ease;
}

.raven-shell__nav-link:hover,
.raven-shell__nav-link.router-link-active {
  border-color: rgba(103, 232, 249, 0.32);
  background: rgba(34, 211, 238, 0.1);
  color: #ecfeff;
}

.raven-shell__frame {
  position: relative;
  z-index: 1;
  width: min(100%, 90rem);
  margin: 0 auto;
  padding: 1.25rem 1rem 2.5rem;
}

@media (min-width: 640px) {
  .raven-shell__topbar {
    padding: 1.25rem 1.5rem 0;
  }

  .raven-shell__frame {
    padding: 1.5rem 1.5rem 3rem;
  }
}

@media (min-width: 1024px) {
  .raven-shell__topbar {
    padding: 1.5rem 2.25rem 0;
  }

  .raven-shell__frame {
    padding: 2rem 2.25rem 3.5rem;
  }
}

@media (max-width: 720px) {
  .raven-shell__topbar {
    align-items: flex-start;
    flex-direction: column;
  }

  .raven-shell__nav {
    justify-content: flex-start;
  }
}

@keyframes raven-float {
  0%, 100% {
    transform: translate3d(0, 0, 0) scale(1);
  }

  50% {
    transform: translate3d(0, 24px, 0) scale(1.03);
  }
}
</style>
