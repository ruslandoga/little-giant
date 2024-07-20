# Prometheus on S3

A small program that performs two functions:

1. Scrape Prometheus endpoints and save the data in a compact format to S3
2. Act as S3 proxy for ClickHouse queries, e.g.

   ```sql
   select avg(value) as 'average http requests for the last 7 days'
   from s3('https://prometheus-on-s3.fly.dev/http_requests_total?job=webserver', Native)
   where timestamp > now() - interval '7 days';
   ```
