# GeoNetwork 4.2.14-0 + GEMINI 2.3 + GEMINI 2.3 dlm custom schema plugins

This repository builds a runnable Docker image based on the official `geonetwork:4.2.14-0` image and injects the custom `iso19139.gemini23` and `iso19139.gemini23-dlm` schema plugins from this repository.

## Run with Docker Compose

```bash
docker compose up -d --build
```

Services:

- `geonetwork` on `http://localhost:8081/geonetwork`
- `elasticsearch` on the internal compose network

The compose stack includes Elasticsearch as the search dependency required by GeoNetwork.

## Manual verification

1. Open `http://localhost:8081/geonetwork`.
2. Login with default credentials:
   - username: `admin`
   - password: `admin`
3. Open **Admin console** → **Metadata & templates**.
4. Confirm `GEMINI 2.3` appears in the schema/template list.

## Automated verification

You can verify the custom plugins have been loaded by running the `test-schemas.sh` script present in the `scripts` folder after the geonetwork container is healthy.

You can also run the `run-e2e.sh` script to run the geonetwork container along with its dependency (elasticsearch) and verify that the custom plugins have loaded successfully.

## Notes

- The warning logs present when you first run the geonetwork container are expected as they are referencing the package conflicts in the upstream image. There is no elegant way to remove them at the moment and given they only occur when you first run the geonetwork container these are safe to ignore.
- The `ESAPI` warnings about missing `/var/lib/jetty/ESAPI.properties` and `validation.properties` are expected fallback lookups. GeoNetwork then loads ESAPI from the classpath; those lines are noisy but not the Elasticsearch root cause.
- While the `ES_*` vairables are required by the geonetwork image they do not actually pass on the parameters to connect to elasticsearch to the geonetwork instance. To do that please fill out the `JAVA_OPTS` environment variable with `-Des.host=elasticsearch -Des.port=9200 -Des.protocol=http`.
