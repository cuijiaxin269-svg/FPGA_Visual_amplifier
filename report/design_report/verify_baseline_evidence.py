"""Read-only verification of the report's fixed baseline against build receipts.

This does not run project tests, synthesis, implementation, programming or board
operations. It writes only the resulting baseline_validation.json audit record.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import io
import json
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parent
BASELINE = "a9ab041021c269b446be4e5aa00ae3141f01ec8d"
GROUPS = [
    ("hardware_inputs", "build/reports/vivado_2025_2/input_sha256.json", "files", 825),
    ("host_test_inputs", "sim/results/current_host/result.json", "input_sha256", 58),
    ("rtl_comparison_inputs", "sim/results/vivado_2025_2/result.json", "source_sha256", 6),
    ("arm_firmware_inputs", "build/reports/firmware_2025_2/result.json", "source_sha256", 43),
]


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def git_objects(git: str, repo: Path, paths: list[str]) -> list[bytes | None]:
    query = "".join(f"{BASELINE}:{p}\n" for p in paths).encode("utf-8")
    result = subprocess.run(
        [git, "-C", str(repo), "cat-file", "--batch"],
        input=query, capture_output=True, check=True,
    )
    stream = io.BytesIO(result.stdout)
    output = []
    for path in paths:
        header = stream.readline().decode("utf-8").rstrip("\n")
        if header.endswith(" missing"):
            output.append(None)
            continue
        parts = header.split()
        if len(parts) != 3 or parts[1] != "blob":
            raise RuntimeError(f"Unexpected Git object header for {path}: {header}")
        size = int(parts[2])
        data = stream.read(size)
        if len(data) != size or stream.read(1) != b"\n":
            raise RuntimeError(f"Incomplete Git object for {path}")
        output.append(data)
    return output


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=Path, default=ROOT.parents[1] / "submission/fpga_visual_amplifier")
    parser.add_argument("--release-dir", type=Path)
    parser.add_argument("--output", type=Path, default=ROOT / "baseline_validation.json")
    parser.add_argument("--git")
    args = parser.parse_args()
    fallback = Path.home() / ".cache/codex-runtimes/codex-primary-runtime/dependencies/native/git/cmd/git.exe"
    git = args.git or shutil.which("git") or str(fallback)
    repo = args.repo.resolve()
    release_dir = (args.release_dir or repo.parent / "release_assets/vivado_2025_2").resolve()
    resolved = subprocess.check_output([git, "-C", str(repo), "rev-parse", BASELINE + "^{commit}"], text=True).strip()
    if resolved != BASELINE:
        raise RuntimeError("Unexpected baseline commit resolution")

    groups = []
    for name, relative, key, expected_count in GROUPS:
        receipt_blob = git_objects(git, repo, [relative])[0]
        if receipt_blob is None:
            raise RuntimeError(f"Missing baseline receipt: {relative}")
        receipt = json.loads(receipt_blob.decode("utf-8-sig"))
        entries = receipt[key]
        if isinstance(entries, dict):
            entries = [{"path": p, "sha256": value} for p, value in entries.items()]
        paths = []
        for entry in entries:
            path = entry["path"].replace("\\", "/")
            prefix = repo.as_posix() + "/"
            if path.startswith(prefix):
                path = path[len(prefix):]
            paths.append(path)
        blobs = git_objects(git, repo, paths)
        mismatches = []
        missing = []
        for entry, path, blob in zip(entries, paths, blobs):
            if blob is None:
                missing.append(path)
            elif sha256(blob) != entry["sha256"]:
                mismatches.append({"path": path, "receipt_sha256": entry["sha256"], "git_object_sha256": sha256(blob)})
        disk_path = repo / relative
        disk_hash = sha256(disk_path.read_bytes()) if disk_path.is_file() else None
        group = {
            "id": name,
            "source_receipt_path": str(disk_path),
            "source_receipt_git_path": relative,
            "source_receipt_sha256": sha256(receipt_blob),
            "workspace_receipt_sha256": disk_hash,
            "workspace_receipt_matches_baseline": disk_hash == sha256(receipt_blob),
            "recorded_test_status": receipt.get("status"),
            "expected_inputs": expected_count,
            "inputs_checked": len(entries),
            "exact_matches": len(entries) - len(mismatches) - len(missing),
            "missing": missing,
            "mismatches": mismatches,
            "passed": len(entries) == expected_count and not missing and not mismatches and disk_hash == sha256(receipt_blob),
        }
        groups.append(group)

    release_receipt_path = release_dir / "release_receipt.json"
    release_bytes = release_receipt_path.read_bytes()
    release = json.loads(release_bytes.decode("utf-8-sig"))
    artifacts = []
    for name in ("capture.bit", "boot.bin"):
        path = release_dir / name
        data = path.read_bytes()
        expected = release["files"][name]
        artifacts.append({
            "file": name,
            "path": str(path),
            "bytes": len(data),
            "sha256": sha256(data),
            "receipt_sha256": expected["sha256"],
            "matches_release_receipt": sha256(data) == expected["sha256"] and len(data) == expected["bytes"],
        })
    release_record = {
        "source_receipt_path": str(release_receipt_path),
        "source_receipt_sha256": sha256(release_bytes),
        "status": release["status"],
        "toolchain": release["toolchain"],
        "board_runtime_validated": release["board_runtime_validated"],
        "physical_flash_boot_validated": release["physical_flash_boot_validated"],
        "artifacts": artifacts,
    }
    passed = all(g["passed"] for g in groups) and all(a["matches_release_receipt"] for a in artifacts)
    passed = passed and release["toolchain"] == "2025.2" and release["status"] == "built_and_statically_validated"
    passed = passed and release["board_runtime_validated"] is False and release["physical_flash_boot_validated"] is False
    record = {
        "checked_at_utc": datetime.now(timezone.utc).isoformat(),
        "baseline_commit": BASELINE,
        "repository": str(repo),
        "status": "passed" if passed else "failed",
        "method": "Exact SHA256 comparison of Git blob bytes at the fixed baseline against recorded input hashes; no line-ending normalization.",
        "scope": "Evidence correspondence only; existing project tests, synthesis, implementation, deployment and board tests were not rerun.",
        "script_sha256": sha256(Path(__file__).read_bytes()),
        "groups": groups,
        "release": release_record,
        "limitations": [
            "Current working-tree MAGROI changes are not covered by this baseline record.",
            "Historical v18 performance and v19 cold-boot results remain bound to their respective historical artifacts.",
            "Baseline 2025.2 hardware and boot validation are host-side build/static checks, not new board validation.",
        ],
    }
    args.output.write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"output": str(args.output), "status": record["status"], "baseline_commit": BASELINE, "inputs": {g["id"]: g["exact_matches"] for g in groups}, "artifact_hashes_verified": len(artifacts)}, ensure_ascii=False))
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
