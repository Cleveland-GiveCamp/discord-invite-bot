# discord-role-tools

Scripts for managing Discord server roles via the Discord API.

## Scripts

### `duplicate-role.sh`

Duplicates a role's permissions to another role by name. If the target role
already exists its permissions are updated in place. If it does not exist a new
role is created.

## Setup

### 1. Create a Discord bot

1. Go to [discord.com/developers/applications](https://discord.com/developers/applications)
2. Click **New Application**, give it a name, click **Create**
3. In the left sidebar click **Bot**, then **Reset Token** — save the token
4. Scroll down and disable **Public Bot**
5. In the left sidebar click **OAuth2 → URL Generator**
6. Check the `bot` scope, then check the **Manage Roles** bot permission
7. Copy the generated URL, open it in your browser, and add the bot to your server

### 2. Get your server ID

1. In Discord open **Settings → Advanced** and enable **Developer Mode**
2. Right-click your server name in the sidebar → **Copy Server ID**

### 3. Configure credentials

```bash
cp .env.example .env
```

Edit `.env` and fill in both values:

```
DISCORD_BOT_TOKEN=your_bot_token_here
DISCORD_SERVER_ID=your_server_id_here
```

> **Note:** `.env` is git-ignored. Never commit your bot token.

### 4. Bot role hierarchy

The bot can only manage roles that sit **below its own role** in the server
hierarchy. In **Server Settings → Roles**, drag the bot's role above any roles
you want the script to create or update.

---

## Running with Nix

Requires [Nix](https://nixos.org/download) with flakes enabled. No other
dependencies needed — `curl` and `jq` are provided by the flake.

**Run directly without installing:**

```bash
nix run . -- "2025 Volunteer" "2026 Volunteer"
nix run . -- "2025 Nonprofit" "2026 Nonprofit"
nix run . -- "2025 Organizer" "2026 Organizer"
```

**Install into your profile:**

```bash
nix profile install .
duplicate-role "2025 Volunteer" "2026 Volunteer"
duplicate-role "2025 Nonprofit" "2026 Nonprofit"
duplicate-role "2025 Organizer" "2026 Organizer"
```

**Drop into a dev shell with `curl` and `jq` on your PATH:**

```bash
nix develop
./duplicate-role.sh "2025 Volunteer" "2026 Volunteer"
./duplicate-role.sh "2025 Nonprofit" "2026 Nonprofit"
./duplicate-role.sh "2025 Organizer" "2026 Organizer"
```

---

## Running without Nix

**Dependencies:**

| Tool | Install |
|------|---------|
| `bash` | Pre-installed on macOS and Linux |
| `curl` | `brew install curl` / `apt install curl` |
| `jq` | `brew install jq` / `apt install jq` |

**Make the script executable (first time only):**

```bash
chmod +x duplicate-role.sh
```

**Run:**

```bash
./duplicate-role.sh "2025 Volunteer" "2026 Volunteer"
./duplicate-role.sh "2025 Nonprofit" "2026 Nonprofit"
./duplicate-role.sh "2025 Organizer" "2026 Organizer"
```

---

## Usage

```
duplicate-role <source_role_name> <new_role_name>
```

| Argument | Description |
|----------|-------------|
| `source_role_name` | Name of the existing role to copy permissions from |
| `new_role_name` | Name of the role to create or update |

**What is copied from the source role:**

- Permission bitfield
- Color
- Hoist (whether the role is shown separately in the member list)
- Mentionable

**What is not copied:**

- Channel permission overwrites (stored on channels, not roles)
- Role position in the hierarchy (new roles are created at the bottom)
