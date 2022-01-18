# Задание 1: подготовить приложение для работы через qbec

Все конфиги лежат в директории test здесь в репозитории.

Создал конфигурацию:  
`qbec init test --with-example`

И изменил файлы:

qbec.yaml:

```
apiVersion: qbec.io/v1alpha1
kind: App
metadata:
  name: test
spec:
  environments:
    stage:
      defaultNamespace: stage
      server: https://127.0.0.1:6443
    production:
      defaultNamespace: production
      server: https://127.0.0.1:6443
  vars: {}
```
production.libsonnet:

```
// this file has the baseline default parameters
{
  components: { // required
    front: {
      replicas: 3,
      "name": "production"
    },
  },
}
```

stage.libsonnet:

```
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

```

params.libsonnet:

```
// this file returns the params for the current qbec environment
local env = std.extVar('qbec.io/env');
//local paramsMap = import 'glob-import:environments/*.libsonnet';
//local baseFile = if env == '_' then 'base' else env;
//local key = 'environments/%s.libsonnet' % baseFile;

local production = import './environments/production.libsonnet';
local stage = import './environments/stage.libsonnet';


if std.objectHas(paramsMap, key)
then paramsMap[key]
else error 'no param file %s found for environment %s' % [key, env]

```

front.jsonnet:

```

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
```
Запуск production environments c 3 репликами:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.5/png/1.PNG?raw=true)

Запуск stage environments с 1 репликой:

![alt text](https://github.com/kiselev-it/devops/blob/main/task_13.5/png/2.PNG?raw=true)