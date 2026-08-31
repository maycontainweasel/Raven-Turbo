import type { AccountRef, AccountSummary } from "@raven/domain";

export type RavenAction = {
  id: string;
  label: string;
  description: string;
  icon: string;
  group: "Navigate" | "Create" | "Account";
  run: () => void | Promise<void>;
};

export function useRavenActions() {
  const router = useRouter();
  const pendingCommand = useState<RavenPendingCommand | null>(
    "raven-pending-command",
    () => null,
  );
  const commandAccount = useState<AccountRef | null>(
    "raven-command-account",
    () => null,
  );
  const dataVersion = useState<number>(
    "raven-account-control-data-version",
    () => 0,
  );
  const accountDirectory = useState<AccountSummary[]>(
    "raven-account-directory",
    () => [],
  );

  const openCommand = (
    command: RavenPendingCommand,
    account: AccountRef | null = null,
  ) => {
    commandAccount.value = account;
    pendingCommand.value = command;
  };

  const actions = computed<RavenAction[]>(() => [
    {
      id: "route.today",
      label: "Today",
      description: "Open daily financial control",
      icon: "i-lucide-layout-dashboard",
      group: "Navigate",
      run: async () => {
        await router.push("/");
      },
    },
    {
      id: "route.accounts",
      label: "Accounts",
      description: "View balances and freshness",
      icon: "i-lucide-landmark",
      group: "Navigate",
      run: async () => {
        await router.push("/accounts");
      },
    },
    {
      id: "route.upcoming",
      label: "Upcoming",
      description: "Review scheduled inflows and outflows",
      icon: "i-lucide-calendar-range",
      group: "Navigate",
      run: async () => {
        await router.push("/upcoming");
      },
    },
    {
      id: "route.clients",
      label: "Clients",
      description: "Open relationships, retainers and opportunity",
      icon: "i-lucide-contact-round",
      group: "Navigate",
      run: async () => {
        await router.push("/clients");
      },
    },
    {
      id: "route.buckets",
      label: "Buckets",
      description: "Model future allocation plans",
      icon: "i-lucide-git-branch",
      group: "Navigate",
      run: async () => {
        await router.push("/buckets");
      },
    },
    {
      id: "create.account",
      label: "Create account",
      description: "Track another financial account",
      icon: "i-lucide-plus",
      group: "Create",
      run: async () => {
        if (router.currentRoute.value.path !== "/accounts")
          await router.push("/accounts");
        openCommand("create-account");
      },
    },
    {
      id: "create.cashflow",
      label: "Schedule cashflow",
      description: "Add an upcoming inflow or outflow",
      icon: "i-lucide-calendar-plus",
      group: "Create",
      run: async () => {
        if (router.currentRoute.value.path !== "/upcoming")
          await router.push("/upcoming");
        openCommand("create-cashflow");
      },
    },
    {
      id: "create.upcoming-payment",
      label: "Upcoming payment",
      description: "Schedule a committed outgoing payment",
      icon: "i-lucide-calendar-minus-2",
      group: "Create",
      run: async () => {
        if (router.currentRoute.value.path !== "/upcoming")
          await router.push("/upcoming");
        openCommand("create-upcoming-payment");
      },
    },
    {
      id: "create.expected-income",
      label: "Expected income",
      description: "Schedule expected incoming money",
      icon: "i-lucide-calendar-plus-2",
      group: "Create",
      run: async () => {
        if (router.currentRoute.value.path !== "/upcoming")
          await router.push("/upcoming");
        openCommand("create-expected-income");
      },
    },
    {
      id: "create.expense",
      label: "Record expense",
      description: "Add observed account outflow",
      icon: "i-lucide-arrow-up-right",
      group: "Create",
      run: () => openCommand("record-expense"),
    },
    {
      id: "create.income",
      label: "Record income",
      description: "Add observed account inflow",
      icon: "i-lucide-arrow-down-left",
      group: "Create",
      run: () => openCommand("record-income"),
    },
    {
      id: "create.transfer",
      label: "Record transfer",
      description: "Move money between tracked accounts",
      icon: "i-lucide-arrow-left-right",
      group: "Create",
      run: () => openCommand("record-transfer"),
    },
  ]);

  const paletteActions = computed<RavenAction[]>(() => [
    ...actions.value,
    ...accountDirectory.value.map((account) => ({
      id: `route.account.${account.spaceKey}.${account.accountKey}`,
      label: account.name,
      description: `Open ${account.spaceKey} account detail`,
      icon: "i-lucide-landmark",
      group: "Account" as const,
      run: async () => {
        await router.push(
          `/accounts/${account.spaceKey}/${account.accountKey}`,
        );
      },
    })),
    ...accountDirectory.value.map((account) => ({
      id: `statement.import.${account.spaceKey}.${account.accountKey}`,
      label: `Import statement · ${account.name}`,
      description:
        "Stage and preview bank source without creating transactions",
      icon: "i-lucide-file-input",
      group: "Account" as const,
      run: async () => {
        await router.push(
          `/accounts/${account.spaceKey}/${account.accountKey}/statements/import`,
        );
      },
    })),
  ]);

  return {
    actions,
    paletteActions,
    pendingCommand,
    commandAccount,
    dataVersion,
    accountDirectory,
    openCommand,
  };
}

export type RavenPendingCommand =
  | "create-account"
  | "create-cashflow"
  | "create-upcoming-payment"
  | "create-expected-income"
  | "record-expense"
  | "record-income"
  | "record-transfer";
