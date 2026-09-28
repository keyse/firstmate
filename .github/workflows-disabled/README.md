# Disabled GitHub Actions workflows

These workflows were moved out of `.github/workflows/` to turn off CI/CD.
GitHub Actions only runs files under `.github/workflows/`, so nothing here triggers.

To re-enable one, move it back:

    git mv .github/workflows-disabled/<name>.yml .github/workflows/
