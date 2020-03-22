# Collecting logs for Support

To collect logs from your Codacy installation using fluentd change `fluentdoperator.enabled` to true.

```bash
--set fluentdoperator.enabled=true
```

The fluentd daemonset will send the logs to minio which is also installed by this chart.

To extract the logs and send them to Codacy's support team in case of problems, you can run the following command locally (replacing the `<namespace>` with the namespace in which Codacy was installed):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/codacy/chart/master/docs/extra/extract-codacy-logs.sh) -n <namespace>
```

The logs extraction script is also available [here](extract-codacy-logs.sh), for manual downloading.
