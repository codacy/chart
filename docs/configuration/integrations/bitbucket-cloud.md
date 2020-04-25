# Bitbucket Cloud

Follow the instructions below to set up the Codacy integration with Bitbucket Cloud.

## Create an OAuth consumer

To integrate Codacy with Bitbucket Cloud, you must register an OAuth consumer for Codacy on Bitbucket.

You can create a consumer on any existing individual or team account. To create a consumer, do the following:

1.  On Bitbucket, click on your avatar on the bottom left-hand corner and select **Bitbucket settings**.

2.  Select **OAuth** on the left sidebar and click the button **Add consumer**.

3.  Fill in the fields to create the OAuth consumer:

    - **Name:** Name of the OAuth consumer. For example, `Codacy`.

    - **Callback URL:** Copy the URL below, updating the HTTP protocol, hostname, and port to the correct values of your Codacy instance.
    
        ```
        http://<codacy hostname>:<codacy port>/login/Bitbucket?codacy_skip_ga=1
        ```

    - **This is a private consumer:** Enable the check box.

    - Add the permissions:

        - **Account:** Write
        - **Team membership:** Read
        - **Projects:** Read
        - **Repositories:** Admin
        - **Pull requests:** Write
        - **Issues:** Write
        - **Webhooks:** Read and write

    ![Bitbucket consumer configuration](images/bitbucket-consumer-configuration.png)
    ![Bitbucket consumer permissions](images/bitbucket-consumer-permissions.png)

4. Click Save, and then click the name of the new OAuth consumer to take note of the generated key and secret.

   ![Bitbucket consumer key and secret](images/bitbucket-consumer-key-and-secret.png)

## Configure Bitbucket Cloud on Codacy

After creating the OAuth consumer on Bitbucket Cloud, you must configure it on Codacy:

1.  Edit the file `values-production.yaml` that you used to [install Codacy](../../index.md#helm-upgrade).

2.  Set `global.bitbucket.enabled: "true"` and define the remaining values as described below using the information obtained when you created the OAuth consumer:

   ```yaml
   global:
     bitbucket:
       enabled: "true"
       login: "true" # Show login button for Bitbucket
       key: "10000000000" # OAuth consumer key
       secret: "a0000000000000000000" # OAuth consumer secret
   ```

3.  Apply the new configuration by performing a Helm upgrade. To do so execute the command [used to install Codacy](../../index.md#helm-upgrade):

    !!! important
        **If you are using MicroK8s** you must use the file `values-microk8s.yaml` together with the file `values-production.yaml`.
        
        To do this, uncomment the last line before running the `helm upgrade` command below.

    ```bash
    helm upgrade (...options used to install Codacy...) \
                 --values values-production.yaml \
                 # --values values-microk8s.yaml
    ```

After this is done you will be able to use Bitbucket Cloud to authenticate to Codacy.
