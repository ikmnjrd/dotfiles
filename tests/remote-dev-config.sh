#!/usr/bin/env bash

set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cli="${root}/bin/remote-dev"
tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

mkdir -p "${tmp}/bin" "${tmp}/repo"
git -C "${tmp}/repo" init -q
cp "${root}/examples/remote-dev/.remote-dev.compose.json" \
  "${tmp}/repo/.remote-dev.json"

cat >"${tmp}/bin/mutagen" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"${REMOTE_DEV_TEST_LOG}"
exit 0
EOF
cat >"${tmp}/bin/ssh" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"${REMOTE_DEV_TEST_LOG}"
exit 0
EOF
chmod +x "${tmp}/bin/mutagen" "${tmp}/bin/ssh"
touch "${tmp}/commands.log"

PATH="${tmp}/bin:${PATH}" \
XDG_STATE_HOME="${tmp}/state" \
REMOTE_DEV_HOST_ID="test-host" \
REMOTE_DEV_TEST_LOG="${tmp}/commands.log" \
"${cli}" doctor >/dev/null

if PATH="${tmp}/bin:${PATH}" "${cli}" init >/dev/null 2>&1; then
  echo "init without a slot unexpectedly succeeded" >&2
  exit 1
fi

(
  cd "${tmp}/repo"
  PATH="${tmp}/bin:${PATH}" \
    XDG_STATE_HOME="${tmp}/state" \
    REMOTE_DEV_HOST_ID="test-host" \
    REMOTE_DEV_TEST_LOG="${tmp}/commands.log" \
    "${cli}" init feature >/dev/null
)

grep -q -- '--mode one-way-replica' "${tmp}/commands.log"
grep -q -- '--ignore node_modules' "${tmp}/commands.log"
test -f "${tmp}/state/remote-dev/slots/test-host/example-app/feature.json"

jq '.runner.type = "invalid"' "${tmp}/repo/.remote-dev.json" \
  >"${tmp}/repo/.remote-dev.json.tmp"
mv "${tmp}/repo/.remote-dev.json.tmp" "${tmp}/repo/.remote-dev.json"
if (
  cd "${tmp}/repo"
  PATH="${tmp}/bin:${PATH}" \
    XDG_STATE_HOME="${tmp}/state" \
    REMOTE_DEV_HOST_ID="test-host" \
    REMOTE_DEV_TEST_LOG="${tmp}/commands.log" \
    "${cli}" init test >/dev/null 2>&1
); then
  echo "invalid config unexpectedly succeeded" >&2
  exit 1
fi

echo "remote-dev host config tests passed"
