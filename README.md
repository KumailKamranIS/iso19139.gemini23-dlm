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


## Run on a local kubernetes cluster

```sh
minikube start --memory=8192 --cpus=4

eval $(minikube docker-env)
# IRL this will be on a ACR
minikube image load geonetwork-dlm:latest

minikube ssh "sudo sysctl -w vm.max_map_count=262144"


# order is important here. It shouldn't matter, but Geonetwork and ogc-records-api 
# are written this way.
kubectl apply -f manifests/geonetwork-config.yml
kubectl apply -f manifests/elasticsearch.yml
kubectl apply -f manifests/postgis.yml
kubectl apply -f manifests/geonetwork-dlm.yml

# To check the IP the cluster is running on:
minikube ip

# cleanup
minikube delete --all
```

To restart an app after config changes:

```sh
kubectl rollout restart deployment ogc-records-api-deployment
```

### Settings while running locally

You will need to change a setting in the configuration to get geonetwork to work properly when using its UI. In production, this would be set once, stored in the DB and then shared between geonetwork instances.

Login as admin, go to settings. Look for `Catalog server` and change it to the url and port of the geonetwork instance.

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
