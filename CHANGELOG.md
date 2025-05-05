# k8s-velero Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- [#22] Plugin for restore exclude

## [v5.0.2-10] - 2025-04-30

### Changed
- [#20] Set sensible resource requests and limits

## [v5.0.2-9] - 2024-12-05
### Fixed
- [#18] change label of podSelector to match k8s-velero

## [v5.0.2-8] - 2024-12-05
### Added
- [#16] add deny all NetworkPolicy

## [v5.0.2-7] - 2024-10-28
### Changed
- [#13] Use `ces-container-registries` secret for pulling container images as default.

## [v5.0.2-6] - 2024-09-19
- Relicense to AGPL-3.0-only

## [v5.0.2-5] - 2024-01-03
### Changed
- [#9] Use existing secret for backup-storage

## [v5.0.2-4] - 2023-12-13
### Fixed
- [#7] Add volumemounts for init containers in patch templates.

## [v5.0.2-3] - 2023-12-08
### Added
- [#5] Add patch templates for images for mirroring this chart in airgapped environments.

## [v5.0.2-2] - 2023-10-24
### Added
- [#3] Add ces labels like `app: ces` or `k8s.cloudogu.com/part-of: backup` to deployment and pod resources.

## [v5.0.2-1] - 2023-10-06
### Added
- [#1] Add initial version of the velero component.