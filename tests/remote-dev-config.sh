#!/usr/bin/env bash

set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cli="${root}/bin/remote-dev"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

mkdir -p "${tmp}/bin" "${tmp}/example-feature"
git -C "${tmp}/example-feature" init -q
git -C "${tmp}/example-feature" checkout -q -b feature/foo
git -C "${tmp}/example-feature" remote add origin git@example.com:org/example-app.git

cat >"${tmp}/bin/rsync" <<'EOF'
#!/usr/bin/env bash
printf 'rsync:%s\n' "$*" >>"${REMOTE_DEV_TEST_LOG}"
exit 0
EOF

cat >"${tmp}/bin/ssh" <<'EOF'
#!/usr/bin/env bash
printf 'ssh:%s\n' "$*" >>"${REMOTE_DEV_TEST_LOG}"
exit 0
EOF

chmod +x "${tmp}/bin/rsync" "${tmp}/bin/ssh"
touch "${tmp}/commands.log"

PATH="${tmp}/bin:${PATH}" \
REMOTE_DEV_HOST_ID="test-host" \
REMOTE_DEV_TEST_LOG="${tmp}/commands.log" \
"${cli}" doctor >/dev/null

(
  cd "${tmp}/example-feature"
  PATH="${tmp}/bin:${PATH}" \
    REMOTE_DEV_HOST_ID="test-host" \
    REMOTE_DEV_TEST_LOG="${tmp}/commands.log" \
    "${cli}" >/dev/null
)

grep -q -- 'ssh:-o BatchMode=yes nixos-remote-dev true' "${tmp}/commands.log"
grep -q -- "ssh:nixos-remote-dev mkdir -p -- 'workspace/remote-dev/test-host/example-app/feature-foo'" "${tmp}/commands.log"
grep -q -- 'rsync:.*--delete' "${tmp}/commands.log"
grep -q -- 'rsync:.*--exclude node_modules' "${tmp}/commands.log"
grep -q -- 'rsync:.*--exclude \.remote-dev-local' "${tmp}/commands.log"
grep -q -- 'rsync:.*nixos-remote-dev:workspace/remote-dev/test-host/example-app/feature-foo/' "${tmp}/commands.log"

if grep -q -- '--exclude \.env' "${tmp}/commands.log"; then
  echo ".env files must not be excluded by default" >&2
  exit 1
fi

if (
  cd "${tmp}/example-feature"
  PATH="${tmp}/bin:${PATH}" \
    REMOTE_DEV_TEST_LOG="${tmp}/commands.log" \
    "${cli}" up >/dev/null 2>&1
); then
  echo "obsolete up command unexpectedly succeeded" >&2
  exit 1
fi

echo "remote-dev rsync tests passed"
