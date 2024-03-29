# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Made RemoteConfiguration a protocol and created a BasicConfiguration struct
- APIClient now has a mutable configuration
- Added swiftformat and pre-commit hook which can be setup with ./scripts/git_hooks/setup
- Removed content type and base url from Routable
- Changed RemoteClient protocol
- Added APIClient async/await support
- Reduced number of KantanError types
- Upgrade swift tools version to 5.7
- Removed remote image
- Support package editing in vscode

## [0.0.1] - 2020-09-13

### Added

- Created the project on GitHub

[unreleased]: https://github.com/flexaargo/KantanNetworking/compare/v0.0.1...HEAD
[0.0.1]: https://github.com/flexaargo/KantanNetworking/releases/tag/v0.0.1
