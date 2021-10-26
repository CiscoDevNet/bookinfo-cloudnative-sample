## Bookinfo Demo Helm Chart

This directory contains a simplified helm chart for deploying the Bookinfo demo application.

This helm chart includes the following manifests
- /platform/bookinfo.yaml
- /platform/appd.yaml

These have been modified for helm variables.  These are defined in the value.yaml file.

By default, the product page service will be exposed as a LoadBalancer for external acccess while the remaining services will be deployed as ClusterIP services.

### Deployment
The Bookinfo demo can be deployed using the following helm command.  Please substitute your AppDynamics account name and key.

```
helm install bookinfo ./fso-bookinfo-demo-0.0.1.tgz --set appDynamics.account_name=XXXXXXX --set appDynamics.account_key=YYYYYYY --namespace=bookinfo
```
