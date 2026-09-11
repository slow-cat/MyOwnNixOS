# Codex widget

Lua widget and mask splitter imported from `../codex_widget`.
The bar shows the original rotating usage indicator and primary reset clock.
Green and red fills represent the remaining primary and secondary quotas.
Usage refreshes every five minutes using the current user's Codex login.
Authentication is read only at runtime, never copied into the Nix store.

## SVG source

The logo is fetched by `../codex.nix` with a fixed SHA-256 hash; the seven hole
masks are derived during the build, rather than checked into this repository.

- File: https://upload.wikimedia.org/wikipedia/commons/6/66/OpenAI_logo_2025_%28symbol%29.svg
- Description: https://commons.wikimedia.org/wiki/File:OpenAI_logo_2025_(symbol).svg
- Author listed by Commons: OpenAI
- Retrieved: 2026-09-12
- Commons copyright tag: PD-textlogo (simple geometric shapes or text).
- Commons also lists a trademark notice; its public-domain label is not a
  trademark license.

The splitter assumes this pinned SVG's subpath order: outer contour, then seven
holes, with hole 4 being the center. Recheck the masks when updating the hash.
