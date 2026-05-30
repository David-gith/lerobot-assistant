# Security Policy

## Scope

This repository is a local Agent Skill. It should not contain credentials, private keys, personal tokens, robot secrets, or production configuration.

## Safe-By-Default Behavior

- `scripts/env_check.sh` performs read-only checks and does not install packages.
- SO-101/S101 templates default to `push_to_hub: false`.
- The skill instructs agents to ask before running package installs, `sudo`, firmware changes, hardware writes, Hub uploads, or long-running training jobs.
- Knowledge files avoid destructive cleanup commands. Prefer read-only inspection commands and manual confirmation for file deletion.

## Before Publishing

Run these checks before pushing:

```bash
python3 scripts/security_scan.py
python3 -m pytest
bash tests/shell_env_check.sh
```

`scripts/security_scan.py` uses Python standard library only. It checks for high-confidence secret patterns and unsafe command examples without requiring `rg`/ripgrep.

## Reporting Issues

If you find a security issue, open a private security advisory on GitHub or contact the maintainer privately. Do not publish exploit details in a public issue before a fix is available.
