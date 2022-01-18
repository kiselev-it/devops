// this file has the param overrides for the default environment
local production = import './production.libsonnet';

production {
  components +: {
    front +: {
      replicas: 1,
      "name": "stage"
    },
  }
}
