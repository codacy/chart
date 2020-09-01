# Release Process

This documentation guides you on how to release a new version of the Codacy Chart.

The release process consists of the following stages:

1.  **Deciding to release a new version**

    Decide that we're ready to release a new version of the Codacy Chart and elect who will be the Release Manager.

2.  **Preparing the release for testing**

    The Release Manager creates a release candidate branch that will be used to test the new release.

3.  **Testing and stabilizing the release**

    The Release Manager involves the QA team and relevant stakeholders in testing the new release, and applies fixes for bugs that are detected.

4.  **Launching the new release**

    The Release Manager releases and announces the new version.

The next sections include detailed instructions on how to complete each step of the release process. Make sure that you complete each step before advancing to the next one.

## 1. Deciding to release a new version

-   [ ] 1.  Inform the engineering team that you are the release manager for a new release in the Slack channel #team-engineering (tag @engineers) and get a status from each squad on any changes that may be on the master branch of components that may be deal breakers for the release.

-   [ ] 2.  Confirm with every squad if the release can go ahead.

-   [ ] 3.  Decide the new version number.

    Go to the [releases page](https://github.com/codacy/chart/releases) to find the latest version, and decide on the version for the new release.

    We follow the [semver](https://semver.org/) specification so, given a version number MAJOR.MINOR.PATCH, increment the:

    -   **MAJOR version** when you make changes that are incompatible with old values.yaml files or integrations
    -   **MINOR version** when you add functionality in a backwards compatible manner
    -   **PATCH version** when you make backwards compatible bug fixes

## 2. Preparing the release for testing

The Release Manager must create a release candidate branch:

-   [ ] 1.  Make sure that you have the following tools installed:

    -   git
    -   [ytool](https://github.com/codacy/ytool)
    -   [helm >=3.x](https://helm.sh/docs/intro/install/)

-   [ ] 2.  Clone this project on master branch

    **If you're releasing a patch version**, checkout the previous release branch that you will be patching. For example:

    ```bash
    git checkout 'release-6.0.1'
    ```

-   [ ] 3.  Create a new branch with the pattern `release-x.x.x`, where `x.x.x` is the new version number

    For example:

    ```bash
    git checkout -b 'release-6.0.0'
    ```

-   [ ] 4.  Update Dependencies

    Let's assume that `requirements.yaml` file should have the correct dynamic versions configured.

    Run the following command:

    ```bash
    make update_dependencies
    ```

    This will update the `requirements.lock` with the latest versions and freeze the `worker-manager.config.codacy.worker.image` version on `./codacy/values.yaml`.

    **If you're releasing a patch version**, update the `requirements.yaml` file to use the patched version of a given component. If you need any changes that are already merged to the master branch, you should cherry-pick them as described in the step 7.1 below.

-   [ ] 5.  Commit the updated `requirements.lock` and `./codacy/values.yaml` to the branch

    For example:

    ```bash
    git commit -m 'release: prepare 6.0.0'
    ```

-   [ ] 6.  Tag the commit with a release candidate version following the pattern `x.x.x-RC-0`

    For example:

    ```bash
    git tag '6.0.0-RC-0'
    ```

    This version will be published to the [incubator](https://charts.codacy.com/incubator/api/charts) channel in the next step.

-   [ ] 7.  Push the commit

    ```bash
    git push --tag && git push --set-upstream origin 'release-6.0.0'
    ```

    This will automatically trigger a build which will be pushed to the [incubator](https://charts.codacy.com/incubator/api/charts) channel.

    Your chart will be deployed to [the release environment described in this table](./README.md#development-installations)

    -   [ ] 7.1.  Cherry-pick fixes

        At this stage, it is possible for the build to have failed. The fixes for this failure should have been merged to `master` following a successfully approved Pull Request.

        You can cherry-pick the required changes with:

        ```bash
        git cherry-pick <commit-hash>
        ```

        Ensure the cherry-pick commit is free from any conflicts.

    -   [ ] 7.2.  Push new Release Candidate tag

        Since there are new hotfix changes to the release, you must then add another release candidate tag to your release branch and push it again.

        ```bash
        git tag '6.0.0-RC-<n>' && git push --tag && git push --force-with-lease
        ```

## 3. Testing and stabilizing the release

The Release Manager must involve the QA team and relevant stakeholders in testing the new release candidate.

Then, the QA team and the stakeholders test the new release:

-   [ ] 1.  Validate that the features present in changelog generated during the circleci pipeline work according to the requirements.

-   [ ] 2.  Run the regression tests with our [automation test suite](https://bitbucket.org/qamine/qa-automation-tests/src/master/docs/getting-started.md#markdown-header-run-the-tests), case some tests fail involve QA and Eng team to help debug the problem.

-   [ ] 3.  Validate the Results from the Regression tests.

-   [ ] 4.  Test the CLI, Client Side Tools, and Coverage Reporter

-   [ ] 5.  Do [exploratory tests](https://handbook.dev.codacy.org/engineering/guidelines/quality/levels.html#exploratory-testing) around the functionalities your feature impacted to make sure everything is running as it should,  raise bugs or concerns if any. give feedback with the identified bugs that are blocking the release with the stakeholders

-   [ ] 6.  No known blockers bugs should be released, ideally no known bugs should be released. If a blocker bug is found during exploratory testing create a new task/test to cover that situation.

-   [ ] 7.  If necessary address different stakeholders and ask for help testing the new release.

-   [ ] 8.  Sync with solution engineers to do acceptance testing, a clean installation on this phase is recommended.

-   [ ] 9.  If you find any critical path that might have been affected, make sure you add/edit the tests in our [automation test suite](https://bitbucket.org/qamine/qa-automation-tests/).

-   [ ] 10. Inform the Release Manager on #enterprise-releases about the progress/findings of the testing on the release.

-   [ ] 11. Approval by QA

    Involve the QA stakeholders in the release process.

    Remind them that this release candidate is available for testing in the [release environment](./README.md#Development).

    Should all of these stakeholders be happy, a go-ahead of the release should be given by clicking the Manual Approval step for QA in the CircleCI workflow of your release branch.

-   [ ] 12. Approval by Solutions Engineers

    Involve the Solutions Engineers stakeholders in the release process.

    Inform them that this release candidate is available for testing in the [release environment](./README.md#Development). At this point the Solutions Architects should:

    -   [ ] 12.1.  Perform a fresh installation of the release candidate

    -   [ ] 12.2.  Perform an upgrade on an existing installation

    -   [ ] 12.3.  Should all of these stakeholders be happy, a go-ahead of the release should be given by clicking the Manual Approval step for the Solutions Engineers in the CircleCI workflow of your release branch.

    After this Manual Approval on CircleCI the workflow will promote the RC to the [stable](https://charts.codacy.com/stable/api/charts) channel.

## 4. Launching the new release

The Release Manager must ensure that we have a stable release candidate and that both the QA team and relevant stakeholders have approved the release.

Then, the Release Manager releases and announces the new version:

-   [ ] 1.  If all is good give a public OK to the release

-   [ ] 2.  Tag the CLI, Client Side Tools, and Coverage Reporter with the version of the release being done.

-   [ ] 3.  Inform all stakeholders the release is finished 

The final version will be `6.0.0`.
