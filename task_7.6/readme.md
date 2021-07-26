# Задача 1.
## 1. Найдите, где перечислены все доступные resource и data_source, приложите ссылку на эти строки в коде на гитхабе.

https://github.com/hashicorp/terraform-provider-aws/tree/main/aws

## 2.Для создания очереди сообщений SQS используется ресурс aws_sqs_queue у которого есть параметр name
### С каким другим параметром конфликтует name? Приложите строчку кода, в которой это указано
```sh
"name": {
			Type:          schema.TypeString,
			Optional:      true,
			Computed:      true,
			ForceNew:      true,
			ConflictsWith: []string{"name_prefix"},
		}
```
### Какая максимальная длина имени?
```sh
func validateSfnStateMachineName(v interface{}, k string) (ws []string, errors []error) {
	value := v.(string)
	if len(value) > 80 {
		errors = append(errors, fmt.Errorf("%q cannot be longer than 80 characters", k))
	}

```
### Какому регулярному выражению должно подчиняться имя?
```sh
^[a-zA-Z0-9-_]+$
```