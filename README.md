A little program that:

1. Scrapes Prometheus /metrics and saves the samples in a compact format to S3:
   
   ```shell
   # target
   https://little-giant.fly.dev/metrics
   # scrape itself
   POST https://little-giant.fly.dev/scrape/little-giant.fly.dev/metrics
   ```
   <sup>can be used as a sidecar container?</sup>
   
1. Acts as S3 proxy with predicate pushdown:

   ```shell
   # clickhouse
   $ curl https://clickhouse.com | sh
   $ ./clickhouse local
   ```
   ```sql
   select `timestamp`, `value`
   from s3('https://little-giant.fly.dev/http_requests_total.native?job=webserver')
   where `timestamp` > now() - interval '7 days';
   ```
   ```shell
   # duckdb
   $ brew install duckdb
   $ duckdb
   ```
   ```sql
   select timestamp, value
   from 'https://little-giant.fly.dev/http_requests_total.parquet?job=webserver'
   where timestamp > now() - interval '7 days';
   ```

   > [!NOTE]
   > duckdb-wasm is used in markdown reports (see below)
   
1. Renders markdown reports and dashboards:

   ```shell
   # gist
   https://gist.github.com/ruslandoga/aa30d466655846701c6e8ace2915a196
   # markdown
   https://gist.githubusercontent.com/ruslandoga/aa30d466655846701c6e8ace2915a196/raw/f2e50e8d29d6946d7e56a0b58b796c1157911b39/report.md
   # generated report
   GET https://little-giant.fly.dev/render/gist.githubusercontent.com/ruslandoga/aa30d466655846701c6e8ace2915a196/raw/f2e50e8d29d6946d7e56a0b58b796c1157911b39/report.md
   ```

1. Subscribes your browser for [alerts](https://prometheus.io/docs/alerting/latest/overview/) using [Web Push API:](https://web.dev/explore/notifications)

   ```shell
   # promql
   avg(rate(network_bytes_total[1h])) > 10000000
   # base64url(promql)
   YXZnKHJhdGUobmV0d29ya19ieXRlc190b3RhbFsxaF0pKSA-IDEwMDAwMDAw
   # subscribe at /alerts/<base64url(promql)>
   GET https://little-giant.fly.dev/alerts/YXZnKHJhdGUobmV0d29ya19ieXRlc190b3RhbFsxaF0pKSA-IDEwMDAwMDAw
   # current alerts and subscriptions
   GET https://little-giant.fly.dev/alerts
   ```
