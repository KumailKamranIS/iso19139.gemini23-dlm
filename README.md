# GeoNetwork 4.2 + GEMINI 2.3 custom schema plugin

This repository builds a runnable Docker image based on the official `geonetwork:4.2` image and injects the custom `iso19139.gemini23` schema plugin from this repository.

## Run with Docker Compose

```bash
docker compose up -d --build
```

Services:

- `geonetwork` on `http://localhost:8080/geonetwork`
- `elasticsearch` on the internal compose network

The compose stack includes Elasticsearch as the search dependency required by GeoNetwork.

## Export the built plugin JAR to your local directory

The Dockerfile now exposes a dedicated build stage (`plugin-jar-export`) so you can write the built plugin JAR directly to the directory where you run the build:

```bash
docker build --target plugin-jar-export --output type=local,dest=. .
```

This will create:

- `./schema-iso19139.gemini23-4.2.4-SNAPSHOT.jar`


## Manual verification

1. Open `http://localhost:8080/geonetwork`.
2. Login with default credentials:
   - username: `admin`
   - password: `admin`
3. Open **Admin console** → **Metadata & templates**.
4. Confirm `GEMINI 2.3` appears in the schema/template list.

## Automated verification with Playwright

Install dev dependencies and run the test:

```bash
npm install
npx playwright install --with-deps chromium
scripts/run-e2e.sh
```

Or if GeoNetwork is already running:

```bash
GN_BASE_URL=http://127.0.0.1:8080 npx playwright test
```


## Troubleshooting Elasticsearch connection errors

If you see errors like `Could not connect to index 'gn-records' ... Connection refused`:

1. Ensure Elasticsearch is healthy:

   ```bash
   docker compose ps
   docker compose logs elasticsearch
   ```

2. Restart with a clean Elasticsearch volume if needed:

   ```bash
   docker compose down -v
   docker compose up -d --build
   ```

3. If startup logs still show repeated Jetty warnings similar to `oeja.AnnotationParser ... scanned from multiple locations` (for example Groovy or BouncyCastle classes), set Jetty annotation-parser logging to `ERROR` (already configured in this compose file):

   ```bash
   JAVA_OPTS="-Xms512m -Xmx1024m -Dorg.eclipse.jetty.annotations.AnnotationParser.LEVEL=ERROR" docker compose up -d --build
   ```

   These warnings are typically non-fatal duplicate-class scan notices from upstream image libraries.

4. If Elasticsearch keeps restarting or never becomes healthy, check host kernel limits (common on Linux):

   ```bash
   docker compose logs elasticsearch
   sudo sysctl -w vm.max_map_count=262144
   ```

   Then restart: `docker compose down -v && docker compose up -d --build`.

5. Validate connectivity from inside the GeoNetwork container:

   ```bash
   docker compose exec geonetwork sh -lc 'getent hosts elasticsearch && curl -fsS http://elasticsearch:9200'
   ```

   If this fails, the issue is container networking / Elasticsearch availability rather than the schema plugin.

6. Note: The `ESAPI` warnings about missing `/var/lib/jetty/ESAPI.properties` and `validation.properties` are expected fallback lookups. GeoNetwork then loads ESAPI from the classpath; those lines are noisy but not the Elasticsearch root cause.

This compose file follows the official GeoNetwork 4.2 image behavior and uses `ES_HOST`, `ES_PORT`, and `ES_PROTOCOL` (the variables consumed by the 4.2 entrypoint). It also keeps reduced JVM heap defaults (`512m`) to avoid common local-memory startup failures.



### GeoNetwork 4.2 vs 4.4+ Elasticsearch configuration

- GeoNetwork **4.2** images use `ES_HOST`, `ES_PORT`, `ES_PROTOCOL` (and optional `ES_INDEX_RECORDS`, `ES_USERNAME`, `ES_PASSWORD`) in the container entrypoint.
- GeoNetwork **4.4+** examples often use `GN_CONFIG_PROPERTIES` with `-Des.*` Java properties.

This repository targets `geonetwork:4.2`, so Compose is intentionally configured with `ES_*` variables.
