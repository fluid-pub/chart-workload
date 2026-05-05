# Helm chart — fluid-workload

In the **`fluid`** monorepo this chart lives under `code/charts/fluid-workload/`; standalone Git (**`fluid-pub/chart-workload`**) uses the same layout at the repository root.

**Release (standalone repo)** — **`helm lint`** runs on PRs and `main` / `develop`; pushing a semver tag **without `v`** runs **`helm push … oci://ghcr.io/<GitHub-owner>/fluid-workload`** when the tag equals **`version`** in **`Chart.yaml`**.

**Install / pull from GHCR** — Helm OCI on GitHub stores the chart under a path that repeats the chart **`name:`** (see the package page `fluid-workload/fluid-workload`). Use **`--version`** with the full OCI prefix, for example:

```text
helm pull oci://ghcr.io/fluid-pub/fluid-workload/fluid-workload --version 0.1.0
```

or the equivalent tag form **`oci://ghcr.io/fluid-pub/fluid-workload/fluid-workload:0.1.0`**. The shorter reference **`oci://ghcr.io/fluid-pub/fluid-workload`** (without the second **`fluid-workload`**) does **not** resolve with **`helm pull` / `helm install`** against this registry layout.

Generic chart for **one** Fluid agent or probe image: ConfigMap-mounted YAML config, optional Secret-mounted credentials, extra env.

## Typical values

- `image.repository` / `image.tag` — GHCR image built for that workload.
- `config.content` — YAML passed to `-config` (default mount directory `/etc/fluid/config`, filename `config.yaml`).
- `args` — often `["-config", "/etc/fluid/config/config.yaml"]` for agents (adjust for probes).
- `credentialsSecret` — enable and set `secretName` when the binary reads credential files from disk.

Set `service.enabled` only if the workload exposes a TCP port you need to expose via a Service.