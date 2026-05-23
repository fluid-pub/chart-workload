# Helm chart — fluid-workload

In the **`fluid`** monorepo this chart lives under `code/charts/fluid-workload/`; standalone Git (**`fluid-pub/chart-workload`**) uses the same layout at the repository root.

**Release** — push a semver tag **without `v`** matching **`version`** in **`Chart.yaml`** to publish **`oci://ghcr.io/fluid-pub/fluid-workload/fluid-workload:<tag>`**.

```text
helm pull oci://ghcr.io/fluid-pub/fluid-workload/fluid-workload --version 0.2.0
```

Generic chart for **one** Fluid agent or probe image: ConfigMap-mounted YAML, optional Secret/env credentials.

## Configuration model

| Layer | What | Where |
|-------|------|--------|
| **Cluster (GitOps values)** | Image, mounts, secrets (`envFrom`), minimal bootstrap YAML | Helm values + ESO |
| **Control plane** | `runtime_config` (entities, intervals, `fields.*.rag`, …) | Dashboard → probe record, fetched over WebSocket/HTTP |
| **Secrets** | Tokens, API keys, CP connection | Kubernetes Secret (e.g. AWS SM via ESO) |

**Probes (all):** ship **`config/schema.yml`** in the **image** at `/etc/fluid/config/schema.yml` (same semver as the binary). Set **`config.schemaInImage: true`** so Helm mounts only the main config file (`subPath`); the schema file from the image stays on disk.

Override only when needed: **`config.schemaContent`** or **`config.files.schema.yml`** (full-directory mount, hides the image schema).

**Control plane:** operational YAML (`data.entities`, intervals, `fields.*.rag`, …) via **`runtime_config`**; schema contract is pushed at connect from the probe (`PushSchema`).

**GitOps:** keep bootstrap in **`config.content`** (state dir, probe name, CP env placeholders, non-secret endpoints).

## Typical values

```yaml
configMount:
  mountPath: /etc/fluid/config
  fileName: config.yaml

config:
  schemaInImage: true
  content: |
    probe:
      name: confluence
    # bootstrap only — entities/tuning → control plane runtime_config

args:
  - -config
  - /etc/fluid/config/config.yaml

extraEnvFrom:
  - secretRef:
      name: my-probe-connection
```

- `image.repository` / `image.tag` — workload image (GHCR).
- `credentialsSecret` — optional file-based credentials mount.
- `service.enabled` — only if the workload exposes HTTP.

## Chart tests

```bash
helm plugin install https://github.com/helm-unittest/helm-unittest --version v0.6.3 --verify=false
helm unittest .
```

See [`tests/README.md`](tests/README.md). CI runs `helm lint` and `helm unittest .` on pull requests.
