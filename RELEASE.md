# Release Process

## Requirements

Please make sure you have these tools installed before starting this process:

-   git
-   [ytool](https://github.com/codacy/ytool)
-   [helm >=3.x](https://helm.sh/docs/intro/install/)

## Prepare a new release

-   [ ] 1.  Clone this project on master branch

-   [ ] 2.  Decide the new version

    Go to the [releases page](https://github.com/codacy/chart/releases) to find the latest version, and decide on the version for the new release.

    We try to follow the [semver](https://semver.org/) specification.

-   [ ] 3.  Create a new branch

    With the following pattern: `release-x.x.x`. Example:

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

-   [ ] 5.  Commit

    Commit the updated `requirements.lock` and `./codacy/values.yaml` to the branch. Example:

    ```bash
    git commit -m 'release: prepare 6.0.0'
    ```

-   [ ] 6.  Tag with RC

    Make sure you tag the commit with a release candidate \[RC]  version.

    ```bash
    git tag '6.0.0-RC-0'
    ```

    This version will be published to the [incubator](https://charts.codacy.com/incubator/api/charts) channel in the next step.

-   [ ] 7.  Push

    ```bash
    git push --tag && git push --set-upstream origin 'release-6.0.0'
    ```

    This will automatically trigger a build which will be pushed to the [incubator](https://charts.codacy.com/incubator/api/charts) channel.

    Your chart will be deployed to [the release environment described in this table](./README.md)

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
    git tag '6.0.0-RC-<n>' && git push --tag
    ```

-   [ ] 8.  Test

Involve both the QA and Solutions Engineers stakeholders in the release process.



    -  Sync with the release manager to identify critical areas of the product affected by the release.

    -   Validate that the features present in changelog generated during the circleci pipeline work according to the requirements.

    -   Run the regression tests with our [automation test suite](https://bitbucket.org/qamine/qa-automation-tests/src/master/docs/getting-started.md#markdown-header-run-the-tests), case some tests fail involve QA and Eng team to help debug the problem.

    -   Validate the Results from the Regression tests.

    -   Do [exploratory tests](https://handbook.dev.codacy.org/product/engineering/QA/levels.html#exploratory-testing) around the functionalities your feature impacted to make sure everything is running as it should,  raise bugs or concerns if any. give feedback with the identified bugs that are blocking the release with the stakeholders

    - No known blockers bugs should be released, ideally no known bugs should be released. If a blocker bug is found during exploratory testing create a new task/test to cover that situation.

    - If necessary address different stakeholders and ask for help testing the new release.

    - Sync with solution engineers to do acceptance testing, a clean installation on this phase is recommended.

    -  If you find any critical path that might have been affected, make sure you add/edit the tests in our [automation test suite](https://bitbucket.org/qamine/qa-automation-tests/).

    - Inform the release manager "#enterprise-releases" on the progress/findings of the testing on the release.

    


-   [ ] 9.  Approval by stakeholders

    Involve both the QA and Solutions Engineers stakeholders in the release approval.

    Remind them that this release candidate is available for testing in the [release environment](./README.md#Development).

    At this point, it may be relevant to test a fresh installation of the release candidate as well as an upgraded installation.

    Should all of these stakeholders be happy with the go-ahead of the release, proceed to the next step.

    If all is good give a public OK to the release.

-   [ ] 10.  Manual Approval

    Click on Manual Approval on CircleCI to promote the RC to the [stable](https://charts.codacy.com/incubator/api/charts) channel.

    The final version will be `6.0.0`.

## Patch

-   [ ] 1.  Checkout the correct branch on this project

    ```bash
    git checkout 'release-6.0.1'
    ```

-   [ ] 2.  Freeze a specific component

    Update the `requirements.yaml` file to use the patched version of a given component.

-   [ ] 3.  Follow up with a normal release

    Continue directly from the step 4 of the [Prepare a new release](#prepare-a-new-release) secion.
