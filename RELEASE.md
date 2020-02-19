# Preparing the release

1. Checkout the `releases` branch.
2. Freeze the versions of each component on the requirements.yaml file to this branch.
The following sample script will output all the latest versions of the codacy owned components from the `STABLE` charts museum:
```bash
#!/bin/bash
DEPENDENCIES=$(yq r codacy/requirements.yaml dependencies -j | jq ".[].name" | sed "s/\"//g" | grep -v "minio\|rabbitmq-ha\|postgresql\|log-router")
for key in $DEPENDENCIES
do
    version=$(curl -s https://charts.codacy.com/stable/api/charts/$key | jq '. | sort_by(.created) | .[-1].version' | sed "s/\"//g")
    printf "%30s %10s\n" $key $version
done
```

Which should produce some pretty output like:
```
                        portal     4.32.3
                      ragnaros     15.2.2
                    activities      1.3.0
       remote-provider-service     2.44.0
                  hotspots-api      1.4.1
               hotspots-worker      1.4.1
                      listener     7.11.0
                          core      3.0.0
                        engine     5.58.0
                    codacy-api    4.128.1
                worker-manager     8.13.0
                          crow      4.4.0
```
Please note you must have `jq` and `yq` installed.
On MacOS:
> brew install jq yq

Otherwise, you can find instructions here:
* https://stedolan.github.io/jq/download/
* https://github.com/mikefarah/yq

3. Run `helm dep up`.
4. Commit both `requirements.yaml` and `requirements.lock` to the branch. The commit message must be "`release: start release [DD-MM-YYYY]`".
5. Tag the commit with `release-[DD-MM-YYYY].[buildversion]` and push.
6. This tag will automatically trigger a release candidate build. You chart will be deployed to [the release environment described in this table](./README.md) (`codacy-doks-cluster-release` cluster in digital ocean).
7. Follow the `release` workflow of the `chart` project on circleci.

## During the release

If there are things that need to be fixed:
1. After the components have been fixed, update the versions on the requirements.yaml file.
2. Run `helm dep up`.
3. Commit both `requirements.yaml` and `requirements.lock` to the branch. The commit message shoul contain something such as "`bump: updated [component] version`".
4. Repeat steps 5. to 7. from the section above.

## After the release

After the release is complete:
1. There will be a `x.y.z` tag if the release has been successful.
2. We adopt a long-lived `releases` branch approach so there is nothing you need to do in particular.
   1. Optionally, you can delete the `release-[DD-MM-YYYY].[buildversion]` you have created.

## Something went wrong

If you would like to abandon the current release:
1. Delete the `release-[DD-MM-YYYY].[buildversion]` tag that you have pushed.
2. Run `helm rollback codacy-release 0` on the `codacy-doks-cluster-release`. This will roll back the release to its previous successful deployment.
