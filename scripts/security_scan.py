#!/usr/bin/env python3
"""Small repository safety scan that does not require ripgrep."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

SECRET_PATTERNS = [
    re.compile(r"hf_[A-Za-z0-9]{20,}"),
    re.compile(r"github_pat_[A-Za-z0-9_]{20,}"),
    re.compile(r"ghp_[A-Za-z0-9]{20,}"),
    re.compile(r"BEGIN (?:RSA|OPENSSH|PRIVATE) KEY"),
    re.compile(r"AKIA[0-9A-Z]{16}"),
]

DANGEROUS_PATTERNS = [
    re.compile(r"\brm\s+-rf\b"),
    re.compile(r"curl\s+[^|\n]+\|\s*(?:sh|bash)"),
    re.compile(r"wget\s+[^|\n]+\|\s*(?:sh|bash)"),
    re.compile(r"(?:^|[;&|]\s*)eval\s+"),
    re.compile(r"--privileged\b"),
    re.compile(r"--dataset\.push_to_hub=true"),
    re.compile(r"push_to_hub=true"),
]

SKIP_DIRS = {
    ".git",
    ".pytest_cache",
    "__pycache__",
}

SKIP_SUFFIXES = {
    ".png",
    ".jpg",
    ".jpeg",
    ".webp",
    ".gif",
    ".pyc",
}

# These files contain the scan patterns themselves or test assertions.
ALLOWLIST_FILES = {
    Path("SECURITY.md"),
    Path("scripts/security_scan.py"),
    Path("tests/test_project_metadata.py"),
}


def iter_files() -> list[Path]:
    files: list[Path] = []
    for path in ROOT.rglob("*"):
        relative = path.relative_to(ROOT)
        if not path.is_file():
            continue
        if any(part in SKIP_DIRS for part in relative.parts):
            continue
        if path.suffix.lower() in SKIP_SUFFIXES:
            continue
        files.append(path)
    return files


def scan_file(path: Path) -> list[str]:
    relative = path.relative_to(ROOT)
    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return []

    findings: list[str] = []
    for pattern in SECRET_PATTERNS:
        if pattern.search(text):
            findings.append(f"{relative}: high-confidence secret pattern: {pattern.pattern}")

    if relative not in ALLOWLIST_FILES:
        for pattern in DANGEROUS_PATTERNS:
            if pattern.search(text):
                findings.append(f"{relative}: unsafe command/publish default: {pattern.pattern}")
    return findings


def main() -> int:
    findings: list[str] = []
    for path in iter_files():
        findings.extend(scan_file(path))

    if findings:
        for finding in findings:
            print(finding)
        return 1

    print("security scan passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
