## [Unreleased]

## [0.1.2] - 2026-03-25
### Changed
- Refactored `Models` namespace wrapper classes to invoke resource dependencies through a global lazy `DeltaExchange.client` factory, enforcing Dependency Injection boundaries natively and patching `ArgumentError` crashes.
- Hardened WebSockets `Faye` bindings and stabilized internal EventMachine reactor loops bridging payload sockets directly over Testnet domain gateways.
- Expanded core client capabilities utilizing dynamic `set_leverage` modifiers, VCR-tested Dry-Validation wrappers, and exhaustive test coverage matrices shielding internal `raise ApiError` resolutions.

## [0.1.1] - 2026-03-21

- Initial release
