# Helm chart — fluid-workload

Generic chart for **one** Fluid agent or probe image: ConfigMap-mounted YAML config, optional Secret-mounted credentials, extra env.

## Typical values

- `image.repository` / `image.tag` — GHCR image built for that workload.
- `config.content` — YAML passed to `-config` (default mount directory `/etc/fluid/config`, filename `config.yaml`).
- `args` — often `["-config", "/etc/fluid/config/config.yaml"]` for agents (adjust for probes).
- `credentialsSecret` — enable and set `secretName` when the binary reads credential files from disk.

Set `service.enabled` only if the workload exposes a TCP port you need to expose via a Service.