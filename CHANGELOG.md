# Changelog

All notable changes to this project will be documented in this file.

This project is in active early development. Versioning follows [Semantic Versioning](https://semver.org/) once a stable 1.0 release is reached — until then, minor versions may include breaking changes as the core architecture (permissions, modules, Workspace) continues to stabilize.

## [Unreleased]
- Ongoing work on multiple different modules and systems (primarily Workspace and Personnel modules).
- Tamper-evident audit logging system.
- Additional documentation and setup guides.

## [0.1.0] - 2026-08-XX
- Initial public release.
- Hiring module: job postings, multi-section application builder, public apply flow, submissions review.
- Personnel module: HR records decoupled from user accounts.
- Workspace module: Projects, Milestones, Features, Deliverables, Work Items with Table/Kanban views.
- Custom permission system with per-role, per-action authorization.
- Toggleable modules via app-wide Configuration.
- Tamper-evident audit log with cryptographic hash chaining.
