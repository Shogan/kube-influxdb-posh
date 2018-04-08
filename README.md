## kube-influxdb-posh

Initial prototype and PowerShell scripts for querying and retrieving data from an InfluxDB instance deployed as part of the Kubernetes Heapster/InfluxDB/Grafana stack.

Note: If you wish to run this against InfluxDB running in a pod inside your k8s cluster, but from outside, you might want to change the InfluxDB service to NodePort and assign a custom port to expose InfluxDB externally. This would probably only make sense if you're running your cluster on a private network, otherwise you'd be exposing InfluxDB publically, which wouldn't be great.