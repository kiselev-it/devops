
local p = import '../params.libsonnet';
local params = p.components.front;

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": "front"
    },
    "spec": {
      replicas: params.replicas,
      "selector": {
        "matchLabels": {
          "component": "front"
        }
      },
      "template": {
        "metadata": {
          "labels": {
            "component": "front"
          }
        },
        "spec": {
          "containers": [
            {
              "name": "front",
              "image": "nginx",
              "imagePullPolicy": "IfNotPresent",
              "ports": [
                {
                  "name": "for-nginx",
                  "containerPort": 80
                }
              ]
            }
          ]
        }
      }
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
      "name": "front"
    },
    "spec": {
      "type": "NodePort",
      "selector": {
        "component": "front"
      },
      "ports": [
        {
          "name": "for-nginx",
          "protocol": "TCP",
          "port": 80,
          "targetPort": 80
        }
      ]
    }
  },
  {
    "apiVersion": "v1",
    "kind": "Namespace",
    "metadata": {
     "name": params.name
   }
  },
]