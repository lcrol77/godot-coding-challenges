from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import re

# ------------------------------------------------------------
# Repo setup
# ------------------------------------------------------------

REPO_ROOT = Path(__file__).resolve().parent

EXCLUDE_DIRS = {
    ".git",
    ".github",
    ".idea",
    ".vscode",
    "__pycache__",
}

PROJECT_MARKER_DIR = ".godot"
VIDEO_EXTS = (".mp4", ".mov", ".webm")


# ------------------------------------------------------------
# Models
# ------------------------------------------------------------

@dataclass
class Project:
    rel_path: str
    title: str
    desc: str
    demo: str | None


# ------------------------------------------------------------
# Utilities
# ------------------------------------------------------------

def is_project_root(p: Path) -> bool:
    return (p / PROJECT_MARKER_DIR).is_dir() and (p / "project.godot").exists()


def clean_md(s: str) -> str:
    return re.sub(r"\s+", " ", s).strip()


def make_repo_relative(project_dir: Path, raw_path: str) -> str | None:
    raw_path = raw_path.strip()

    # Ignore URLs
    if raw_path.startswith(("http://", "https://")):
        return raw_path

    abs_path = (project_dir / raw_path).resolve()
    if not abs_path.exists():
        return None

    return str(abs_path.relative_to(REPO_ROOT)).replace("\\", "/")


# ------------------------------------------------------------
# Demo discovery
# ------------------------------------------------------------

def find_demo_video(project_dir: Path) -> str | None:
    # Prefer media/demo.mp4
    media_dir = project_dir / "media"
    if media_dir.exists():
        for ext in VIDEO_EXTS:
            candidate = media_dir / f"demo{ext}"
            if candidate.exists():
                return str(candidate.relative_to(REPO_ROOT)).replace("\\", "/")

        for f in sorted(media_dir.iterdir()):
            if f.suffix.lower() in VIDEO_EXTS:
                return str(f.relative_to(REPO_ROOT)).replace("\\", "/")

    # Fallback: demo.mp4 in root
    for ext in VIDEO_EXTS:
        candidate = project_dir / f"demo{ext}"
        if candidate.exists():
            return str(candidate.relative_to(REPO_ROOT)).replace("\\", "/")

    return None


# ------------------------------------------------------------
# README parsing
# ------------------------------------------------------------

def parse_project_readme(project_dir: Path) -> tuple[str, str, str | None]:
    readme = project_dir / "README.md"
    demo = find_demo_video(project_dir)

    if not readme.exists():
        return project_dir.name, "", demo

    text = readme.read_text(encoding="utf-8", errors="replace")
    lines = text.splitlines()

    # Title
    title = project_dir.name
    for line in lines:
        m = re.match(r"^\s*#\s+(.+?)\s*$", line)
        if m:
            title = clean_md(m.group(1))
            break

    # Description
    desc_lines = []
    seen_title = False

    for line in lines:
        if not seen_title:
            if line.startswith("#"):
                seen_title = True
            continue

        if not line.strip():
            if desc_lines:
                break
            continue

        if line.startswith("#"):
            break

        if line.lstrip().startswith("!"):
            continue

        desc_lines.append(line.strip())
        if len(" ".join(desc_lines)) > 200:
            break

    desc = clean_md(" ".join(desc_lines))

    # Prefer first linked mp4 in README
    link_match = re.search(r"\((.*?\.(mp4|mov|webm))\)", text, re.IGNORECASE)
    if link_match:
        rewritten = make_repo_relative(project_dir, link_match.group(1))
        if rewritten:
            demo = rewritten

    return title, desc, demo


# ------------------------------------------------------------
# Discovery
# ------------------------------------------------------------

def discover_projects() -> list[Project]:
    projects: list[Project] = []

    for p in REPO_ROOT.rglob("project.godot"):
        project_dir = p.parent

        if any(part in EXCLUDE_DIRS for part in project_dir.parts):
            continue

        if not is_project_root(project_dir):
            continue

        title, desc, demo = parse_project_readme(project_dir)
        rel_path = str(project_dir.relative_to(REPO_ROOT)).replace("\\", "/")

        projects.append(Project(
            rel_path=rel_path,
            title=title,
            desc=desc,
            demo=demo,
        ))

    projects.sort(key=lambda p: p.rel_path.lower())
    return projects


# ------------------------------------------------------------
# Rendering
# ------------------------------------------------------------

def render_root_readme(projects: list[Project]) -> str:
    lines = []
    lines.append("# Godot Coding Challenges\n")
    lines.append("A collection of small, focused Godot experiments.\n")
    lines.append("> Generated automatically. Edit individual project READMEs instead.\n")
    lines.append("## Projects\n")
    lines.append("| Project | Description | Demo |")
    lines.append("|---|---|---|")

    for p in projects:
        link = f"[{p.title}]({p.rel_path}/)"
        desc = p.desc if p.desc else "—"
        demo = f"[🎥 demo]({p.demo})" if p.demo else "—"
        lines.append(f"| {link} | {desc} | {demo} |")

    lines.append("")
    return "\n".join(lines)


# ------------------------------------------------------------
# Entry point
# ------------------------------------------------------------

def main() -> None:
    projects = discover_projects()
    out = render_root_readme(projects)

    target = REPO_ROOT / "README.md"
    target.write_text(out, encoding="utf-8")

    print(f"Wrote README.md with {len(projects)} projects.")


if __name__ == "__main__":
    main()
