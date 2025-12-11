# Changelog

## [1.5.0](https://github.com/rubiin/highlighturl.nvim/compare/v1.4.0...v1.5.0) (2025-12-11)


### Features

* add early return in highlight_debounced to prevent unnecessary timer creation ([e45da36](https://github.com/rubiin/highlighturl.nvim/commit/e45da36c549b5bf9fa96e458ae1d1532eba731b4))
* enhance URL highlighting with buffer-specific checks and cleanup ([c43a900](https://github.com/rubiin/highlighturl.nvim/commit/c43a90067cde60147d61c3dd71eff3953c41aedc))
* improve buffer change tracking in do_highlight function ([3598a75](https://github.com/rubiin/highlighturl.nvim/commit/3598a75c78c66d11230639eb2f8c1ec5fafb205b))
* optimize buffer option checks in do_highlight function ([fb2349f](https://github.com/rubiin/highlighturl.nvim/commit/fb2349f54b9e2ef9490bd9bf05b50e8afd126d0b))
* optimize debounce logic in highlight_debounced function ([bbf9f55](https://github.com/rubiin/highlighturl.nvim/commit/bbf9f55bf1105f6d809e436af391fd6468ae35dd))
* optimize highlight configuration updates to avoid redundant calls ([e98006b](https://github.com/rubiin/highlighturl.nvim/commit/e98006b21393a0a3221724e4a05e96bd253a160b))
* skip hidden/background buffers in highlight logic ([7143804](https://github.com/rubiin/highlighturl.nvim/commit/714380484f10e7f80226905b8aea6261be559f68))
* streamline debounce timer restart logic in highlight_debounced function ([9887c3c](https://github.com/rubiin/highlighturl.nvim/commit/9887c3c84657928e50d4bab0aa49ecf3a87065d0))
* update buffer variable access for enabling/disabling URL highlighting ([d25de18](https://github.com/rubiin/highlighturl.nvim/commit/d25de18373f17f423096569e2003633179e706c9))

## [1.4.0](https://github.com/rubiin/highlighturl.nvim/compare/v1.3.0...v1.4.0) (2025-11-29)


### Features

* add silent option for notifications and update toggle messages ([981c26b](https://github.com/rubiin/highlighturl.nvim/commit/981c26b94d1749a60ccb0cd0dabe70ea26e958ee))
* add underline and silent options to configuration ([4500bad](https://github.com/rubiin/highlighturl.nvim/commit/4500bad39cea5201157990b1a4b0284aafa0beac))


### Bug Fixes

* use configurable underline option for URL highlighting ([d5462dc](https://github.com/rubiin/highlighturl.nvim/commit/d5462dc6fe1ec46bdaaa76cb53ba354c44ee0e24))

## [1.3.0](https://github.com/rubiin/highlighturl.nvim/compare/v1.2.0...v1.3.0) (2025-11-29)


### Features

* add buffer-local control commands for URL highlighting ([54b2d5e](https://github.com/rubiin/highlighturl.nvim/commit/54b2d5e6c7a3c1cf50fc641a75a714b4893a3344))

## [1.2.0](https://github.com/rubiin/highlighturl.nvim/compare/v1.1.1...v1.2.0) (2025-11-28)


### Features

* add .luarc.json for Lua diagnostics and update README with command details ([ee8bdc8](https://github.com/rubiin/highlighturl.nvim/commit/ee8bdc86649087f75f99d3930a5a5f5b7007220b))
* add toggle and enabled state for URL highlighting ([0a8d63d](https://github.com/rubiin/highlighturl.nvim/commit/0a8d63dca066297b3b602be072c56208b42dbc2d))


### Bug Fixes

* update branch reference from master to main in CI workflow ([8e99c75](https://github.com/rubiin/highlighturl.nvim/commit/8e99c7509111532dd334cfa65f0e401c118482b4))
