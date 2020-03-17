# Release Process

## Requirements

Please make sure you have these tools installed before starting this process:

-   git
-   [ytool](https://github.com/codacy/ytool)
-   [helm 2.x](https://v2.helm.sh/docs/using_helm/#installing-helm)

## Prepare a new release

-   [ ] 1.  Clone this project on master branch

-   [ ] 2.  Decide the new version

    Go to the [releases page](https://github.com/codacy/chart/releases) to find the latest version, and decide on the version for the new release.

    We try to follow the [semver](https://semver.org/) specification.

-   [ ] 3.  Create a new branch

    With the following pattern: `release-x.x.x`. Example:

    ```bash
    $ git checkout -b 'release-6.0.0'
    ```

-   [ ] 4.  Update Dependencies

    Let's assume that `requirements.yaml` file should have the correct dynamic versions configured.

    Run the following command:

    ```bash
    $ make update_dependencies
    ```

    This will update the `requirements.lock` with the latest versions and freeze the `worker-manager.config.codacy.worker.image` version on `./codacy/values.yaml`.

-   [ ] 5.  Commit

    Commit the updated `requirements.lock` and `./codacy/values.yaml` to the branch. Example:

    ```bash
    $ git commit -m 'release: prepare 6.0.0'
    ```

-   [ ] 6.  Tag with RC

    Make sure you tag the commit with a release candidate \[RC]  version.

    ```bash
    $ git tag '6.0.0-RC-0'
    ```

    This version will be published to the [incubator](https://charts.codacy.com/incubator/api/charts) channel in the next step.

-   [ ] 7.  Push

    ```bash
    $ git push --tag && git push --set-upstream origin 'release-6.0.0'
    ```

    This will automatically trigger a build which will be pushed to the [incubator](https://charts.codacy.com/incubator/api/charts) channel.

    Your chart will be deployed to [the release environment described in this table](./README.md)

-   [ ] 8.  Test

    -   Validate that the features present in changelog generated during the circleci pipeline work according to the requirements.

    -   Do [exploratory tests](https://handbook.dev.codacy.org/product/engineering/QA/levels.html#exploratory-testing) around the functionalities your feature impacted to make sure everything is running as it should.

    -   If you find any critical path that might have been affected, make sure you add/edit the tests in our [automation test suite](https://bitbucket.org/qamine/qa-automation-tests/).

    -   Run the regression tests with our [automation test suite](https://bitbucket.org/qamine/qa-automation-tests/src/8aa6640db54f8cf3ac4f07b70647d66a0ec49739/docs/getting-started.md#run-the-tests). 

    -   Validate the Results from the Regression tests. 

-   [ ] 9.  Manual Approval

    Click on Manual Approval on CircleCI to promote the RC to the [stable](https://charts.codacy.com/incubator/api/charts) channel.

    The final version will be `6.0.0`.

## Patch

-   [ ] 1.  Checkout the correct branch on this project

    ```bash
    $ git checkout 'release-6.0.1'
    ```

-   [ ] 2.  Freeze a specific component

    Update the `requirements.yaml` file to use the patched version of a given component.

-   [ ] 3.  Follow up with a normal release

    Continue directly from the step 4 of the [Prepare a new release](#prepare-a-new-release) secion.
