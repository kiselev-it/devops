# Задача 3. Написание кода.
## 1. Напишите программу для перевода метров в футы
```sh
package main

import (
        "fmt"
)

func main() {
        fmt.Print("Pls enter m: ")
        var input float64
        fmt.Scanf("%f", &input)
        output := input / 0.3048
        fmt.Println("Funt = ",output)
}
```
## 2. Напишите программу, которая найдет наименьший элемент в любом заданном списке
```sh
package main

import (
        "fmt"
        "sort"
)

func main() {
        x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,5,7896}
        sort.Ints(x)
        fmt.Println("Minimum is:", x[0])
}

```
##  3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3
```sh
package main

import (
        "fmt"
        "bytes"
        "strconv"
)

func main() {
        var buffer bytes.Buffer
        for i :=1; i <= 100; i++ {
                k := i % 3
                if i == 99 {
                        t := strconv.Itoa(i)
                        buffer.WriteString(t)
                        continue
                }
                if k == 0 {
                        t := strconv.Itoa(i)
                        buffer.WriteString(t + ", ")
                }
        }
        fmt.Println(buffer.String())
}
```


