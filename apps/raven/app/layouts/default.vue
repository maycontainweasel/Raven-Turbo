<template>
  <div class="raven-shell">
    <div class="raven-shell__mesh" aria-hidden="true" />
    <div class="raven-shell__orb raven-shell__orb--one" aria-hidden="true" />
    <div class="raven-shell__orb raven-shell__orb--two" aria-hidden="true" />
    <main class="raven-shell__frame">
      <NuxtPage />
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

.raven-shell__frame {
  position: relative;
  z-index: 1;
  width: min(100%, 90rem);
  margin: 0 auto;
  padding: 1.25rem 1rem 2.5rem;
}

@media (min-width: 640px) {
  .raven-shell__frame {
    padding: 1.5rem 1.5rem 3rem;
  }
}

@media (min-width: 1024px) {
  .raven-shell__frame {
    padding: 2rem 2.25rem 3.5rem;
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
