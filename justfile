# habituate — minimal local CI.
# No build step and no unit tests (deliberately plain files); linting the one
# shell script plus a CLI smoke check is the whole gate. `just ci` is the single
# entry point a pre-push hook (or CI) would run.

# List available recipes
default:
    @just --list

# Static-analyse the shell: shellcheck + a bash syntax parse
lint:
    shellcheck bin/habituate
    bash -n bin/habituate

# Smoke-test: the CLI loads and dispatches without error
test:
    ./bin/habituate help >/dev/null
    # `create --from <dir>` lists a parent's git-repo children and scaffolds nothing
    bash -c 'set -e; d=$(mktemp -d); git -C "$d" init -q smokerepo; out=$(./bin/habituate create smoke --from "$d"); rm -rf "$d"; printf "%s" "$out" | grep -q smokerepo; ! test -e habitats/smoke'

# Full local CI equivalent — run this before pushing
ci: lint test
