# Helm chart unit tests (`fluid-workload`)

Unit tests for this chart live under [`tests/`](tests/) and run with [helm-unittest](https://github.com/helm-unittest/helm-unittest).

## Install plugin

```bash
helm plugin install https://github.com/helm-unittest/helm-unittest --version v0.6.3 --verify=false
```

## Run tests

From the chart root:

```bash
helm unittest .
```

## Coverage

| Suite | Templates |
|-------|-----------|
| `deployment_test.yaml` | `deployment.yaml` |
| `configmap_test.yaml` | `configmap.yaml` |
| `service_test.yaml` | `service.yaml` |

Fixtures: [`tests/data/test_values.yaml`](data/test_values.yaml), [`tests/data/test_values_files.yaml`](data/test_values_files.yaml).

CI runs `helm lint` and `helm unittest .` on every pull request (see [`.github/workflows/ci.yml`](../.github/workflows/ci.yml)).

When you add or change a template or a values branch, add or update tests in the same change.
