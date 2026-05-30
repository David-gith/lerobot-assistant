# Contributing

Thanks for improving `lerobot-assistant`.

## Development Setup

```bash
python3 -m pip install -r requirements-dev.txt
```

## Checks

```bash
python3 -m pytest
bash tests/shell_env_check.sh
```

## Knowledge Base Guidelines

- Prefer Hugging Face LeRobot v0.5.1 docs as the source for stable local knowledge.
- Add a `来源：` source marker to every knowledge file.
- Keep each knowledge file concise and task-oriented.
- Do not paste long upstream documentation verbatim.
- Update `references/knowledge_index.md` and tests if the knowledge file count changes.

## Skill Guidelines

- Keep `SKILL.md` focused on routing, workflow, safety, and answer style.
- Put detailed domain notes in `references/knowledge/`.
- Put deterministic repeated logic in `scripts/`.
