# k8s-velero Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- [#34] Update Makefiles to 10.2.0
### Added
- [#34] Configure Log-Level via Value-Mapping

## [v10.0.1-3] - 2025-07-11
### Changed
- [#32] Update docs to include restore ecludes and a better sample structure

## [v10.0.1-2] - 2025-06-26
### Changed
- [#30] raise memory for velero up to 300M to prevent OOM kills

## [v10.0.1-1] - 2025-06-05
### Changed
- [#29] Update Chart to 10.0.1, which updates Velero to 1.16.0
- [#29] Update velero-plugin-for-restore-exclude to version 1.0.0
- [#29] Update velero-plugin-for-aws to version 1.12.1

## [v5.0.2-13] - 2025-05-13
### Fixed
- [#26] Restore of an old ecosystem-certificate could make the ecosystem unavailable
### Changed
- [#26] Exclude ecosystem-certificate from restore

## [v5.0.2-12] - 2025-05-08
### Fixed
- [#24] Restore of backup components lead to errors after restore
    - This is because the component operator would detect a downgrade, which is not allowed.
      Or worse, an upgrade during the restore operation would cause it to fail.

### Changed
- [#24] exclude all components of the backup stack in the restore 

## [v5.0.2-11] - 2025-05-07
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