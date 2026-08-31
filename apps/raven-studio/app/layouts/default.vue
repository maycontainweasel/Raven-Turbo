<script setup lang="ts">
import type { ListAccountsOutput } from "@raven/domain";

const route = useRoute();
const paletteOpen = useState("raven-command-palette-open", () => false);
const api = useAccountControlApi();
const { dataVersion, accountDirectory } = useRavenActions();
const { data: accountData, refresh: refreshAccounts } =
  await useAsyncData<ListAccountsOutput>(
    "account-control-global-accounts",
    () => api.listAccounts(),
    { server: false },
  );
const accounts = computed(
  () => accountData.value?.spaces.flatMap((space) => space.accounts) ?? [],
);
const spaces = computed(
  () =>
    accountData.value?.spaces.map((space) => ({
      key: space.key,
      name: space.name,
      currency: space.currency,
    })) ?? [],
);
watchEffect(() => {
  accountDirectory.value = accounts.value;
});
watch(dataVersion, () => refreshAccounts());
const completeMovement = () => {
  dataVersion.value += 1;
};

const title = computed(() => {
  if (route.path === "/") return "Today";
  if (route.path.startsWith("/accounts")) return "Accounts";
  if (route.path.startsWith("/activity")) return "Activity";
  if (route.path.startsWith("/upcoming")) return "Upcoming";
  if (route.path.startsWith("/recurring")) return "Recurring";
  if (route.path.startsWith("/clients")) return "Clients";
  if (route.path.startsWith("/merchants")) return "Merchants";
  if (route.path.startsWith("/meaning")) return "Meaning";
  if (route.path.startsWith("/buckets")) return "Buckets";
  if (route.path.startsWith("/debt")) return "Debt";
  if (route.path.startsWith("/plan")) return "Plan";
  if (route.path.startsWith("/analysis")) return "Analysis";
  if (route.path.startsWith("/worldview")) return "Worldview";
  return "Raven";
});
</script>

<template>
  <div class="raven-shell">
    <header class="raven-topbar">
      <NuxtLink class="raven-brand" to="/" aria-label="Raven Today">
        <span class="raven-brand__mark">R</span>
        <span>Raven</span>
      </NuxtLink>
      <div class="raven-topbar__context">
        <div class="raven-breadcrumb">
          <span>/</span>
          <strong>{{ title }}</strong>
        </div>
        <nav class="raven-primary-nav" aria-label="Primary navigation">
          <NuxtLink to="/"> Today </NuxtLink>
          <NuxtLink to="/accounts"> Accounts </NuxtLink>
          <NuxtLink to="/activity"> Activity </NuxtLink>
          <NuxtLink to="/upcoming"> Upcoming </NuxtLink>
          <NuxtLink to="/recurring"> Recurring </NuxtLink>
          <NuxtLink to="/clients"> Clients </NuxtLink>
          <NuxtLink to="/merchants"> Merchants </NuxtLink>
          <NuxtLink to="/meaning"> Meaning </NuxtLink>
          <NuxtLink to="/buckets"> Buckets </NuxtLink>
          <NuxtLink to="/debt"> Debt </NuxtLink>
          <NuxtLink to="/plan"> Plan </NuxtLink>
          <NuxtLink to="/analysis"> Analysis </NuxtLink>
          <NuxtLink to="/worldview"> Worldview </NuxtLink>
        </nav>
      </div>
      <div class="raven-topbar__actions">
        <RavenQuickCreateMenu />
        <button
          class="raven-command-button"
          type="button"
          aria-label="Open command palette"
          title="Command palette"
          @click="paletteOpen = true"
        >
          <span class="i-lucide-search" aria-hidden="true" />
          <span>Search Raven</span>
          <kbd>⌘ K</kbd>
        </button>
        <RavenOverflowMenu />
      </div>
    </header>
    <main
      :class="[
        'raven-main',
        {
          'raven-main--wide':
            route.path === '/' ||
            route.path.startsWith('/activity') ||
            route.path.startsWith('/recurring') ||
            route.path.startsWith('/clients') ||
            route.path.startsWith('/merchants') ||
            route.path.startsWith('/meaning') ||
            route.path.startsWith('/buckets') ||
            route.path.startsWith('/debt') ||
            route.path.startsWith('/plan') ||
            route.path.startsWith('/analysis') ||
            route.path.startsWith('/worldview'),
        },
      ]"
    >
      <slot />
    </main>
    <RavenCommandPalette />
    <TransactionEntryDialog :accounts="accounts" @complete="completeMovement" />
    <TransferEntryDialog :accounts="accounts" @complete="completeMovement" />
    <CashflowCreateDialog
      :accounts="accounts"
      :spaces="spaces"
      @complete="completeMovement"
    />
  </div>
</template>

<style scoped>
.raven-shell {
  min-height: 100dvh;
  background: var(--raven-bg);
}

.raven-topbar {
  position: sticky;
  top: 0;
  z-index: 50;
  height: 64px;
  display: grid;
  grid-template-columns: auto minmax(0, 1fr) auto;
  align-items: center;
  gap: 18px;
  border-bottom: 1px solid var(--raven-border);
  padding: 0 24px;
  background: color-mix(in srgb, var(--raven-bg) 92%, transparent);
  backdrop-filter: blur(12px);
}

.raven-brand,
.raven-breadcrumb {
  display: inline-flex;
  align-items: center;
  gap: 9px;
}

.raven-topbar__context {
  min-width: 0;
  display: flex;
  align-items: center;
  gap: 24px;
}

.raven-brand {
  color: var(--raven-text);
  font-weight: 750;
  text-decoration: none;
}

.raven-brand__mark {
  width: 30px;
  height: 30px;
  display: grid;
  place-items: center;
  border: 1px solid var(--raven-border);
  border-radius: 7px;
  background: var(--raven-text);
  color: var(--raven-bg);
  font-size: 12px;
}

.raven-breadcrumb {
  color: var(--raven-muted);
}

.raven-breadcrumb strong {
  color: var(--raven-text);
  font-weight: 650;
}

.raven-primary-nav {
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

.raven-primary-nav a {
  border-radius: 6px;
  padding: 7px 9px;
  color: var(--raven-faint);
  font-size: 12px;
  font-weight: 650;
  text-decoration: none;
}

.raven-primary-nav a:hover {
  color: var(--raven-muted);
  background: var(--raven-panel);
}

.raven-primary-nav a.router-link-active {
  color: var(--raven-text);
  background: var(--raven-panel-strong);
}

.raven-topbar__actions {
  display: flex;
  align-items: center;
  gap: 7px;
}

.raven-command-button {
  width: min(32vw, 260px);
  min-height: 38px;
  display: grid;
  grid-template-columns: 18px minmax(0, 1fr) auto;
  align-items: center;
  gap: 9px;
  border: 1px solid var(--raven-border);
  border-radius: var(--raven-radius-sm);
  padding: 0 9px 0 12px;
  color: var(--raven-faint);
  background: var(--raven-panel);
  text-align: left;
  cursor: pointer;
}

.raven-command-button:hover {
  border-color: color-mix(in srgb, var(--raven-muted) 55%, var(--raven-border));
  color: var(--raven-muted);
}

.raven-command-button kbd {
  border: 1px solid var(--raven-border);
  border-radius: 5px;
  padding: 2px 6px;
  color: var(--raven-muted);
  font-size: 10px;
}

.raven-main {
  width: min(100%, 1368px);
  margin: 0 auto;
  padding: 40px 24px 80px;
}

.raven-main--wide {
  width: min(100%, 1600px);
}

@media (max-width: 900px) {
  .raven-primary-nav {
    display: none;
  }
}

@media (max-width: 600px) {
  .raven-topbar {
    gap: 10px;
    padding: 0 12px;
  }

  .raven-brand > span:last-child,
  .raven-topbar__add-label,
  .raven-command-button > span:not(:first-child),
  .raven-command-button kbd {
    display: none;
  }

  .raven-command-button {
    width: 38px;
    grid-template-columns: 1fr;
    place-items: center;
    padding: 0;
  }

  .raven-main {
    padding: 22px 12px 48px;
  }
}
</style>
