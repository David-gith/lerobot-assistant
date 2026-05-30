from __future__ import annotations

from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def test_skill_references_existing_local_assets() -> None:
    skill = (ROOT / "SKILL.md").read_text(encoding="utf-8")

    expected_paths = [
        "scripts/env_check.sh",
        "config.yaml",
        "references/knowledge_index.md",
        "templates/so101_config.yaml",
    ]
    for relative_path in expected_paths:
        assert relative_path in skill
        assert (ROOT / relative_path).exists()


def test_skill_frontmatter_has_required_fields() -> None:
    skill = (ROOT / "SKILL.md").read_text(encoding="utf-8")
    assert skill.startswith("---\n")
    frontmatter = skill.split("---", 2)[1]
    assert "name: lerobot-assistant" in frontmatter
    assert "description:" in frontmatter


def test_readme_is_platform_neutral_for_github_release() -> None:
    readme = (ROOT / "README.md").read_text(encoding="utf-8")
    assert "Comate" not in readme
    assert "SKILL.md" in readme
    assert "LICENSE" in readme
    assert "SECURITY.md" in readme
    assert "README-ch.md" in readme


def test_readme_assets_exist() -> None:
    for relative_path in [
            "assets/hero-lab-workflow.png",
            "assets/so101-validation.png",
            "assets/workflow-sim2real.png",
            "README.md",
            "README-ch.md",
        ]:
            assert (ROOT / relative_path).exists()


def test_security_scan_script_exists() -> None:
    scan = ROOT / "scripts" / "security_scan.py"
    assert scan.exists()
    assert "ripgrep" in scan.read_text(encoding="utf-8") or "rg" not in scan.read_text(encoding="utf-8")


def test_env_check_does_not_use_eval() -> None:
    script = (ROOT / "scripts" / "env_check.sh").read_text(encoding="utf-8")
    assert "eval " not in script


def test_security_scan_avoids_substring_eval_false_positive() -> None:
    scan = (ROOT / "scripts" / "security_scan.py").read_text(encoding="utf-8")
    assert r"(?:^|[;&|]\s*)eval\s+" in scan


def test_knowledge_base_avoids_destructive_examples() -> None:
    for path in (ROOT / "references" / "knowledge").glob("*/*.md"):
        content = path.read_text(encoding="utf-8")
        assert "rm -rf" not in content, str(path)
        assert "--dataset.push_to_hub=true" not in content, str(path)
        assert "push_to_hub=true" not in content, str(path)


def test_knowledge_index_matches_expanded_directories() -> None:
    index = (ROOT / "references" / "knowledge_index.md").read_text(encoding="utf-8")
    knowledge_files = sorted((ROOT / "references" / "knowledge").glob("*/*.md"))

    assert "Current local knowledge files: 58" in index
    assert len(knowledge_files) == 58
    assert "03_推理/" in index
    assert "08_摄像头/" in index
    assert "10_资源与工具/" in index
    assert "11_关于/" in index


def test_every_knowledge_file_has_source_marker() -> None:
    for path in (ROOT / "references" / "knowledge").glob("*/*.md"):
        content = path.read_text(encoding="utf-8")
        assert "来源：" in content, str(path)
