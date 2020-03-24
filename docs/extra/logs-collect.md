# Collecting logs for Support

To help troubleshoot issues, obtain the logs from your Codacy instance and send them to Codacy's Support:

1.  Download the logs by running the following command locally, replacing `<namespace>` with the namespace in which Codacy was installed:

    ```bash
    bash <(curl -fsSL https://raw.githubusercontent.com/codacy/chart/master/docs/extra/extract-codacy-logs.sh) -n <namespace>
    ```

    The script compresses the logs in an archive file with the name `codacy_logs_<timestamp>.zip`.

    You can also [download the script](extract-codacy-logs.sh) to run it manually.

2.  Send the compressed logs to Codacy's support team at [support@codacy.com](mailto:support@codacy.com) for analysis.

    If the file is too big, please upload the file to either a cloud storage service such as [Google Drive](https://www.google.com/drive/) or to a file transfer service such as [WeTransfer](http://www.wetransfer.com/) and send us the link to the file instead.
