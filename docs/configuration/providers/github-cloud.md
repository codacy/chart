# GitHub Cloud

## GitHub Application

To integrate with GitHub we use a GitHub Application.

To create the application on GitHub, visit `settings/applications/new` and create an application pointing to your local Codacy deployment URL.

![GitHub Application](./images/github-application.png)

You can fill all the fields with the suggested text above or use your own text except for the field `Authorization callback URL` where you must insert your local Codacy deployment URL.

The URL should contain the endpoint/IO, the protocol (HTTP or HTTPS), and, if applicable, the port where it is running.

Correct:

-   <http://your.codacy.url.com>
-   <http://your.codacy.url.com:9000>
-   <http://53.43.42.12gi>
-   <http://53.43.42.12:9000>

Incorrect:

-   your.codacy.url.com
-   your.codacy.url.com:9000
-   53.43.42.12
-   53.43.42.12:9000

    ### Token retrieval

    After the application is created, you should copy both the `Client ID` and the `Client Secret` and paste them in the setup page on your Codacy Self-hosted.

![GitHub Application](./images/github-token-retrieval.png)

 After this is done you will be able to use GitHub Cloud as an authentication method to add repositories and as an integration in the repository settings.
