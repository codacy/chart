# Collecting logs for Support

To help troubleshoot issues, obtain the logs from your Codacy instance and send them to Codacy's Support:

1.  Collect logs from your Codacy instance using Fluentd:

    ```bash
    --set fluentdoperator.enabled=true
    ```

    After executing this command the Fluentd daemonset will send the logs to MinIO, which is also installed by the Codacy chart.

2.  Download the logs by running the following command locally, replacing `<namespace>` with the namespace in which Codacy was installed:

    ```bash
    bash <(curl -fsSL https://raw.githubusercontent.com/codacy/chart/master/docs/extra/extract-codacy-logs.sh) -n <namespace>
    ```

    The script compresses the logs in an archive file with the name `codacy_logs_<timestamp>.zip`.
    
    You can also [download the script](extract-codacy-logs.sh) to run it manually.

3.  Send the archive file containing the logs to Codacy's support team for analysis.
