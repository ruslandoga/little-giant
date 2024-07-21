# Prometheus on S3

A small program that performs many functions:

1. Scrape Prometheus endpoints and save the data in a compact format to S3
1. Act as S3 proxy for ClickHouse queries, e.g.:

   ```sql
   select `timestamp`, `value` as 'http_requests_total{job=webserver}'
   from s3('https://little-giant.fly.dev/http_requests_total?job=webserver')
   where `timestamp` > now() - interval '7 days';
   ```
   
1. Render markdown reports and dashboards by visiting <kbd>/report/base64url(url)</kbd> e.g.:

   ```
   -- gist
   https://gist.github.com/ruslandoga/aa30d466655846701c6e8ace2915a196
   -- raw markdown
   https://gist.githubusercontent.com/ruslandoga/aa30d466655846701c6e8ace2915a196/raw/f2e50e8d29d6946d7e56a0b58b796c1157911b39/report.md
   -- report
   https://little-giant.fly.dev/report/aHR0cHM6Ly9naXN0LmdpdGh1YnVzZXJjb250ZW50LmNvbS9ydXNsYW5kb2dhL2FhMzBkNDY2NjU1ODQ2NzAxYzZlOGFjZTI5MTVhMTk2L3Jhdy9mMmU1MGU4ZDI5ZDY5NDZkN2U1NmEwYjU4Yjc5NmMxMTU3OTExYjM5L3JlcG9ydC5tZA
   ```

1. Subscribe for [alerts](https://prometheus.io/docs/alerting/latest/overview/) using [Web Push notifications](https://web.dev/explore/notifications) by visiting <kbd>/alert/base64url(promql)</kbd> e.g.:

   ```
   -- promql
   avg(rate(network_bytes_total[1h])) > 10000000
   -- subscribe link
   https://little-giant.fly.dev/alert/YXZnKHJhdGUobmV0d29ya19ieXRlc190b3RhbFsxaF0pKSA-IDEwMDAwMDAw
   ```
