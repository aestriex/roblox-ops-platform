# Roblox Ops Platform

An open-source, modular internal operations platform originally built for [Studio Provisio](https://www.roblox.com/communities/1057378673/Studio-Proviso#!/about), a Roblox game studio. It provides a permission-driven admin system with toggleable modules for hiring, personnel management, and project/work tracking.

## Modules

- **Hiring** — Build custom multi-section job applications, publish them publicly, and review submissions.
- **Personnel** — Maintain HR records independent of user accounts (survives Roblox account changes/bans).
- **Workspace** — Project/Milestone/Feature/Deliverable/Work Item tracking, inspired by real studio production pipelines.

Modules can be individually enabled/disabled app-wide via **Configuration** (Super Admin only).

## Tech Stack

- Ruby on Rails 8.1, PostgreSQL, UUID primary keys throughout.
- Turbo + Stimulus (no heavy JS framework).
- Tailwind CSS v4.
- shadcn-inspired component library (Dialog, Sheet, Combobox, Tabs, etc.).
- Devise + a custom Roblox OmniAuth strategy for authentication.
- A custom, code-driven permission system (`permission` DSL + Role/Permission management UI -- does not use Pundit/CanCan).

## Getting Started

### Prerequisites
- Ruby (see `.ruby-version`)
- PostgreSQL
- Node not required — JS is managed via importmap

### Setup
```bash
git clone <this repo>
cd roblox-ops-platform
bundle install
bin/rails db:create db:migrate db:seed
bin/rails permissions:sync   # required after any new/changed `permission` declarations
bin/dev
```

#### First-time login
Sign in via Roblox OAuth once to create your first User record, then grant yourself Super Admin via the Rails console:

```ruby
user = User.find_by(username: "your_roblox_username")
user.roles << Role.find_by(name: "Super Admin")
```

#### Application Permissions
Controllers declare permissions inline:

```ruby
permission :edit, desc: "Edit job postings", auto_assign: ["Staff", "Manager", "Super Admin"]
```

After adding or changing permission delcarations, run:

```bash
bin/rails permissions:sync
```

This eager-loads the app and syncs Permission/Role records in the database to match your code.

#### Configuration
Org name, module toggles, and external footer links (Discord, Roblox Group, etc.) are managed via Configuration, editable in-app by Super Admins — no code changes or redeploys needed to rebrand for a different studio.

## License
Licensed under the Apache License 2.0 — see LICENSE.

## Status
This is an actively evolving internal tool. Automated test coverage is currently minimal; the project has been built and verified through extensive manual testing. Contributions/issues are welcome, but expect breaking changes as the application continues to evolve.
