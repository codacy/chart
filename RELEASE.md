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

-   [ ] 1.  Inform the engineering team that you are the release manager for a new release in the Slack channel [#team-engineering](https://codacy.slack.com/channels/team-engineering) (tag @engineers). Get a status from each squad on any changes that may be on the master branch of components that may be deal breakers for the release and confirm if the release can go ahead.

-   [ ] 2.  Inform all stakeholders outside the engineering team that a new release proccess is being started, in the Slack channel [#sh_releases](https://codacy.slack.com/channels/sh_releases) (tag @here).

-   [ ] 3.  Decide the new version number.

    Go to the [releases page](https://github.com/codacy/chart/releases) to find the latest version, and decide on the version for the new release.

    We follow the [semver](https://semver.org/) specification so, given a version number MAJOR.MINOR.PATCH, increment the:

    -   **MAJOR version** when you make changes that are incompatible with old values.yaml files or integrations
    -   **MINOR version** when you add functionality in a backwards compatible manner
    -   **PATCH version** when you make backwards compatible bug fixes

## 2. Preparing the release for testing

The Release Manager must create a release candidate branch:

-   [ ] 1.  Make sure that you have the following tools installed:

    -   [git](https://git-scm.com/)
    -   [ytool](https://github.com/codacy/ytool)
    -   [helm >=3.x](https://helm.sh/docs/intro/install/)

-   [ ] 2.  Clone this project on master branch

-   [ ] 3.  Create a new branch with the pattern `release-x.x.x`, where `x.x.x` is the new version number

    For example:

    ```bash
    git checkout -b 'release-x.x.x'
    ```

-   [ ] 4.  Tag the commit with a release candidate version following the pattern `x.x.x-RC-0`

    For example:

    ```bash
    git tag 'x.x.x-RC-1'
    ```

    This is a requirement so that we can fill in values for `engine` and `documentation` versions on the next step.

-   [ ] 5.  Update Dependencies

    Let's assume that `requirements.yaml` file should have the correct dynamic versions configured.

    Run the following command:

    ```bash
    rm .version; make create_version_file update_dependencies
    ```

    These Makefile targets:

    -   Create a `.version` file based on the most recent tag that you created on the previous step.
    -   Update the `requirements.lock` with the latest versions and freeze the `global.workers.config.imageVersion` version on `./codacy/values.yaml`.

    This will also update the `global.codacy.installation.version` and `global.codacy.documentation.version` version on `./codacy/values.yaml`.

-   [ ] 6.  Commit the updated `requirements.lock` and `./codacy/values.yaml` to the branch

    For example:

    ```bash
    git commit -m 'release: prepare x.x.x'
    ```

-   [ ] 7.  Move the the tag to the latest commit you have just done

    For example:

    ```bash
    git tag -f 'x.x.x-RC-1'
    ```

    This version will be published to the [incubator](https://charts.codacy.com/incubator/api/charts) channel in the next steps.

-   [ ] 8.  Push the commit

    ```bash
    git push origin refs/tags/x.x.x-RC-1 && git push --set-upstream origin 'release-x.x.x'
    ```

    This will automatically trigger a build which will be pushed to the [incubator](https://charts.codacy.com/incubator/api/charts) channel.

    Your chart will be deployed to [the release environment described in this table](README.md#development-installations).


    - [ ] 8.1. Cherry-picking fixes on codacy-chart
        
        At this stage, it is possible for the build to have failed. The fixes for this failure should have been merged to `master` following a successfully approved Pull Request.

        You can cherry-pick the required changes with:

        ```bash
        git cherry-pick <commit-hash>
        ```

        Ensure the cherry-pick commit is free from any conflicts.
        
    - [ ] 8.2. Cherry-picking fixes on a specific component
            
        At this stage it is possible for some component to have a bug that needs to be fixed before the release.
            
        If this is the case, you should produce a new version for the component (with chart published in stable repo) that only includes the changes that introduce the fix.
            
        This new version should be set as fixed in the `requirements.lock` file to ensure that other unrelated component changes are not pulled to the release.
            
        After this, update the current version by adding a new tag:
            
        ```bash
        git tag 'x.x.x-RC-<n>'
        ```
            
        and by updating the `.version` file:
            
        ```bash
        rm .version && make create_version_file
        ```

    -   [ ] 8.2.  Push new Release Candidate tag

        Since there are new hotfix changes to the release, you must then add another release candidate tag to your release branch and push it again.

        ```bash
        git tag 'x.x.x-RC-<n>' && git push origin refs/tags/x.x.x-RC-<n> && git push --force-with-lease
        ```

-   [ ] 9.  Generate release notes

    -   [ ] 9.1.  Run the makefile target `get_release_notes` to automatically generate the release notes for the new version:
    
        ```bash
        make get_release_notes
        ```

        This uses [codacy/codacy-tools-release-notes](https://github.com/codacy/codacy-tools-release-notes) to generate a file `self-hosted-vx.x.x.md`.

    -   [ ] 9.2.  Open a pull request with the generated release notes:

        Copy the generated file to the [release notes folder in codacy/docs](https://github.com/codacy/docs/tree/master/docs/release-notes/self-hosted) and open a new pull request. Get all the necessary stakeholders involved in reviewing the release notes on the pull request.

## 3. Testing and stabilizing the release

The Release Manager must announce to the following stakeholders that the new release candidate is available on the [release environment](README.md#development-installations):

-   QA team
-   Engineering teams
-   Solution Engineers
-   Technical Writer
-   Any other relevant stakeholders

The Release Manager is also responsible for ensuring that each stakeholder tests and approves the release candidate. The following sections provide details on the role of each stakeholder and the Release Manager in this process:

### Approval by the QA team

-   [ ] 1.  Validate that the features present in the changelog generated during the CircleCI pipeline work according to the requirements. Also test the CLI, Client Side Tools, and Coverage Reporter.

    No known blocker bugs should be released, and ideally no known bugs should be released. If a blocker bug is found during exploratory testing create a new task/test to cover that situation and give feedback with the identified bugs that are blocking the release to the other stakeholders.

-   [ ] 2.  Run the regression tests with our [automation test suite](https://bitbucket.org/qamine/qa-automation-tests/src/master/docs/getting-started.md#markdown-header-run-the-tests). If you find any critical path that might have been affected, make sure you add/edit the tests in our [automation test suite](https://bitbucket.org/qamine/qa-automation-tests/).

    Validate the results from the regression tests. In case some tests fail debug the problem.

-   [ ] 3.  Inform the Release Manager on #enterprise-releases about the progress/findings of the testing on the release.

### Approval by the Engineering teams

-   [ ] 1.  Do [exploratory tests](https://handbook.dev.codacy.org/engineering/guidelines/quality/levels.html#exploratory-testing) around the functionality the new features impacted to make sure everything is running as it should, and raise bugs or concerns if any.

    No known blocker bugs should be released, and ideally no known bugs should be released. If a blocker bug is found during exploratory testing create a new task/test to cover that situation and give feedback with the identified bugs that are blocking the release to the other stakeholders.

-   [ ] 2.  Inform the Release Manager on #enterprise-releases about the progress/findings of the testing on the release.

### Approval by the Solution Engineers

-   [ ] 1.  Perform a fresh installation of the release candidate

-   [ ] 2.  Perform an upgrade on an existing installation

-   [ ] 3.  Inform the Release Manager on #enterprise-releases about the progress/findings of the testing on the release.

### Approval by the Technical Writer

The Technical Writer must manually curate the generated release notes by making adjustments directly on the corresponding Jira Epics and Bugs, and generating the release notes again to collect the most up-to-date information from Jira. [Read more about the release notes process](https://handbook.dev.codacy.org/product/guidelines/release-notes.html#release-notes-process) on the Handbook.

### Approval by the Release Manager

If there are fixes for bugs identified during the testing stage, you must [patch the current release candidate](#patching-a-release) and restart the testing and stabilization stage with the new release candidate version.

When all stakeholders have approved the release candidate, give a go-ahead of the release by clicking the Manual Approval step for QA and for the Solutions Engineers in the CircleCI workflow of your release candidate branch. After this Manual Approval on CircleCI the workflow will promote the release candidate to the [stable](https://charts.codacy.com/stable/api/charts) channel.

## 4. Launching the new release

The Release Manager must ensure that we have a stable release candidate and that both the QA team and relevant stakeholders have approved the release.

Then, the Release Manager releases and announces the new version:

-   [ ] 1.  If all is good give a public OK to the release

-   [ ] 2.  Tag the CLI and Coverage Reporter with the version of the release being done.

    **Note:** This process will be improved in [REL-51](https://codacy.atlassian.net/browse/REL-51)

    1.  Go to the repository (or clone it)

    2.  Checkout the version that was validated to work with the current release:

         ```bash
         git checkout y.y.y
         ```

    3.  Tag the commit with the current release version prefixed with `self-hosted-`:

         ```bash
         git tag self-hosted-x.x.x
         ```

    4.  Push the new tag:

         ```bash
         git push --tag origin self-hosted-x.x.x
         ```

-   [ ] 3.  Inform all stakeholders that the release is finished

The final version will be `x.x.x`.

## Patching a release

-   [ ] 1.  Checkout the correct branch on this project

    ```bash
    git checkout 'release-6.0.1'
    ```

-   [ ] 2.  Freeze a specific component

    Update the `requirements.yaml` file to use the patched version of a given component.

    If you need any changes that are already merged to the master branch, you can cherry-pick them as described on step 7.1 of the section [Preparing the release for testing](#2.-preparing-the-release-for-testing).

-   [ ] 3.  Follow up with a normal release

    Continue directly from step 4 of the section [Preparing the release for testing](#2.-preparing-the-release-for-testing).
