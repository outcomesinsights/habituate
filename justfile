# habituate — minimal local CI.
# No build step and no unit tests (deliberately plain files); linting the one
# shell script plus a CLI smoke check is the whole gate. `just ci` is the single
# entry point a pre-push hook (or CI) would run.

# List available recipes
default:
    @just --list

# Static-analyse the shell: shellcheck + a bash syntax parse
lint:
    shellcheck bin/habituate bin/scrub-check bin/install-hooks
    bash -n bin/habituate
    bash -n bin/scrub-check
    bash -n bin/install-hooks

# Smoke-test: the CLI loads and dispatches without error
test:
    ./bin/habituate help >/dev/null
    # `create --from <dir>` lists a parent's git-repo children and scaffolds nothing
    bash -c 'set -e; d=$(mktemp -d); git -C "$d" init -q smokerepo; out=$(./bin/habituate create smoke --from "$d"); rm -rf "$d"; printf "%s" "$out" | grep -q smokerepo; ! test -e habitats/smoke'

# Block a push that would leak sensitive content to the public repo.
# Backstop, not a guarantee: catches KNOWN terms (denylist, gitignored) + generic
# secret/email patterns. A clean run means "no known-bad terms", not "safe".
scrub-check:
    ./bin/scrub-check

# Full local CI equivalent — run this before pushing
ci: lint test scrub-check

# Install git hooks (pre-push -> `just ci`), coexisting with beads. Run once per clone.
install-hooks:
    ./bin/install-hooks
