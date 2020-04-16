# Bitbucket Server Application Link

**NOTE:** Since Bitbucket Server uses OAuth1, you'll need to create a key pair to sign and validate the requests between Codacy and the Bitbucket Server instance:

## Generating the secrets

1. Create a key pair using the RSA algorithm in the PKCS#8 format by running the following commands below, making sure that you don't define a passphrase:

   ```bash
   bash <(curl -fsSL https://raw.githubusercontent.com/codacy/chart/master/docs/configuration/git-providers/generate-bitbucket-server-secrets.sh)
   ```

1.  Store the keys in a safe place for usage in the next steps and as a backup

![Stash Application Link](./images/stash-application-link.png)

## Bitbucket Server Application Link

To set up Bitbucket Server you need to create an application link on your Bitbucket Server installation.

### Application Link Creation

Open `<bitbucket server base url>/plugins/servlet/applinks/listApplicationLinks`, where `<bitbucket server base url>` is the base url of your own Bitbucket Server instance.

Create the link, use your Codacy installation URL for this

![Stash Application Link](./images/stash-application-link.png)

### Name the link

_Application Name_: You can name the application (ex: Codacy)

_Application Type_: The application type is Generic Application

The rest of the configuration should be left blank.

![Stash Link Naming](./images/stash-link-naming.png)

After the link is created, click edit to add an incoming connection.

### Add incoming connection

_Consumer Key_: This value should be copied from the `consumerKey` generated previously.

_Consumer Name_: You can choose any name (ex: Codacy).

_Public Key_: This value should be copied from the `consumerPublicKey` generated previously.

The rest of the fields should be left blank.

![Stash Incoming Connection](./images/stash-incoming-connection.png)

After the application link is created, you will be able to add Bitbucket Server as an integration in the repository settings.
