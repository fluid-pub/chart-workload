# Helm chart — fluid-workload

In the **`fluid`** monorepo this chart lives under `code/charts/fluid-workload/`; standalone Git (**`fluid-pub/chart-workload`**) uses the same layout at the repository root.

**Release (standalone repo)** — semver tag (**no `v`**) must equal **`version`** in `Chart.yaml` for GHCR OCI publishing; **`oci://ghcr.io/<GitHub-owner>/fluid-workload`**.

Generic chart for **one** Fluid agent or probe image: ConfigMap-mounted YAML config, optional Secret-mounted credentials, extra env.

## Typical values

- `image.repository` / `image.tag` — GHCR image built for that workload.
- `config.content` — YAML passed to `-config` (default mount directory `/etc/fluid/config`, filename `config.yaml`).
- `args` — often `["-config", "/etc/fluid/config/config.yaml"]` for agents (adjust for probes).
- `credentialsSecret` — enable and set `secretName` when the binary reads credential files from disk.

Set `service.enabled` only if the workload exposes a TCP port you need to expose via a Service.