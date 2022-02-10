# Proyecto Final de Compiladores

## Explicación

### Calculadora Bison

- Para agregar las funciones, cree una función que recibe dos elementos el nombre de la función y el valor de entrada, y retorna el valor real. Esta parecia la forma más intuitiva de agregar funciones trigonometricas a la calculadora.
  
  
  
  Siguiendo esa idea tome un las funciones dentro del IDENTIFICADOR y que el programa lo use como función si lo procede el simbolo `(` (Por la llamda de la función).
- Para agregar variables a la calculadora simplemente tome el IDENTIFICADOR previamente creado y agregue nuevas reglas, la regla de asignación. Ahora un programa puede ser una expresión o una asignación.
  
  Y para guardar las variables utilice la estructura de datos de `map` disponible en la biblioteca estandar de C++. (Se puede utilizar una estrategia inteligente con `malloc` y arrays, pero tomaria mucho para implementar, era mucho más simple utilizar un diccionario que además ya es `O(1)` por su función de hash).
- Asi que para compilar se necesita de la bandera `-lm` por las funciones matematicas y de `g++`.

### XML Bison

- Implemente la gramatica disponible en el documento. Ahora para forzar que las etiquetas sean iguales, utilice el sistema de simplificación de las expresiones e hice una función que al tratar de simplificar la expresión `<a></a>` (para obtener un valor), entra a una comparación, en caso de que sea desigual, inicia la función yyerror.

## Correr el script

### Calculadora Bison

```bash
$ cd bison_calculator
$ flex calc.l
$ bison calc.y -o calc.tab.h
$ g++ lex.yy.cc -o main -lm
$ ./main
```

### XML Bison

```bash
$ cd bison_xml
$ flex xml.l
$ bison xml.y -o y.tab.h
$ gcc lex.yy.c -o main
$ ./main < example.xml
```




