# Bitbucket Server

Set your configuration values for your Bitbucket instance on the `values.yaml` file.

**NOTE:** Since Bitbucket Server uses OAuth1, you'll need to create a key pair to sign and validate the requests between Codacy and the Bitbucket Server instance:
1. Create the key pair by running the command below, making sure that you don't define a passphrase:

   `ssh-keygen -t rsa -f mykey -q -N ""`

1.  Copy the private key from the `mykey` file and set it in the `consumerPrivateKey`.
1.  Copy the public key from the `mykey.pub` file and set it in the `consumerPublicKey`. 

**Please note that you must go to `http://codacy.example.com/admin/integrations`, select the desired provider and `Test & Save` your configuration for it to be applied.**

Go to `admin/integration` on Codacy and set the **Project Keys** on the Bitbucket Server integration, these should be the keys of the projects you would like to retrieve repositories of.

![Stash Application Link](./images/stash-application-link.png)

## Bitbucket Server Application Link

To set up Bitbucket Server you need to create an application link on your Bitbucket Server installation.
You can click on here and go to the application links list.

### Application Link Creation

Create the link, use your Codacy installation URL for this

![Stash Application Link](./images/stash-application-link.png)

### Name the link

_Application Name_: You can name the application (ex: Codacy)

_Application Type_: The application type is Generic Application

The rest of the configuration should be left blank.

![Stash Link Naming](./images/stash-link-naming.png)

After the link is created, click edit to add an incoming connection.

### Add incoming connection

_Consumer Key_: This value should be copied from the "Client ID" field in the Codacy setup page.

_Consumer Name_: You can choose any name (ex: Codacy).

_Public Key_: This value should be copied from the "Client Secret" field on the Codacy setup page.

The rest of the fields can be left blank.

![Stash Incoming Connection](./images/stash-incoming-connection.png)

After the application link is created, you will be able to add Bitbucket Server as an integration in the repository settings.
