The chart is configured to work with multiple platform, please use the following command for different environment:

1. AWS

a. Helm install: use the following command for installing the helm chart on AWS:

helm install dctm-dcc .\dctm-dcc\ -f .\dctm-dcc\platforms\aws.yaml -f .\dctm-dcc\dcc-resources-values-standard.yaml -n <namespace>

b. Helm upgrade: use the following command for upgrading the helm chart on AWS:

helm upgrade dctm-dcc .\dctm-dcc\ -f .\dctm-dcc\platforms\aws.yaml -f .\dctm-dcc\dcc-resources-values-standard.yaml -n <namespace>

2. CFCR

a. Helm install: use the following command for installing the helm chart on CFCR:

helm install dctm-dcc .\dctm-dcc\ -f .\dctm-dcc\platforms\cfcr.yaml -f .\dctm-dcc\dcc-resources-values-standard.yaml -n <namespace>

b. Helm upgrade: use the following command for upgrading the helm chart on CFCR:

helm upgrade dctm-dcc .\dctm-dcc\ -f .\dctm-dcc\platforms\cfcr.yaml -f .\dctm-dcc\dcc-resources-values-standard.yaml -n <namespace>

Note: Please use dcc-resources-values-small.yaml, instead of dcc-resources-values-small.yaml, in the command above if it is required to deploy the application on more resource constraint environment. 
      Similary, please use dcc-resources-values-large.yaml, instead of dcc-resources-values-small.yaml, in the command above if it is required to deploy the application on environment with higher resource availability.