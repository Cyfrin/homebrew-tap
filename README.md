# Cyfrin Tap

Homebrew formulae for Cyfrin tools.

## Safe-Hash

Install Safe-Hash with:

```sh
brew install cyfrin/tap/safe-hash
```

## Aderyn retirement

Aderyn has been retired and is no longer maintained. Its formula is disabled as of November 13, 2026, so Homebrew blocks new installations and upgrades once your local tap is updated with `brew update`.

Existing installations are not removed automatically. To uninstall a Homebrew installation of Aderyn, run:

```sh
brew uninstall cyfrin/tap/aderyn
```

The disabled formula is retained to explain its retirement. Safe-Hash remains available from this tap.

## Maintenance

Aderyn's release automation can generate and push `Formula/aderyn.rb` to this repository. Disable that publishing job and its dedicated access so a later release cannot overwrite the retirement status.
