# Release notes

## [1.0.0](https://github.com/codacy/chart/releases/tag/1.0.0)

This is the initial release for Codacy Self-hosted running on Kubernetes.

### Product enhancements

-   Streamlined the configuration of Git providers and improved the onboarding flow that guides the user while performing the initial Codacy setup. (CY-468)

### Bug fixes

-   Fixed an issue that could cause pull requests to not be analyzed by improving the robustness of how Codacy fetches Git repositories. (CY-1542)
-   Fixed an issue that caused Codacy to fail to display the information for the pull request tabs Hotspots and Diff. (CY-1690)
-   Fixed an issue that prevented Codacy from analyzing repositories in synced organizations if the repositories had the state "OwnerNotCommiter". (CY-1611)
-   Fixed an issue that prevented using the Codacy configuration file to exclude files from the coverage analysis. (CY-229)
