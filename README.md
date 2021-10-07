
## Introducción

Este es una herramienta para gestionar la agenda de turnos de un policonsultorio, en el cual atienden profesionales de diferentes especialidades
Esta herramienta fue implementada como proyecto para el Taller de Tecnologias de Producción de Software Opcion Ruby
de la Universidad Nacional de La Plata

## Decisiones de diseño

Para implementar los modelos se creo un modulo Models dentro de Polycon que englobe el modelado de clases Professionals y Appointments, estas clases pueden encontrarse en `lib/polycon/models` en los archivos
`professionals.rb` y `appointments.rb` respectivamente

# Sobre la clase Professionals

Para la implementacion de la clase se definió que como comportamiento de clase que se pueda: 
  >Verificar la existencia de un profesional en el sistema, esto se hace en el metodo exist? 
  >Listar los profesionales del sistema (metodo list_professionals)
  >Definir instancias de la clase en base a un nombre recibido por parametro (initialize)
Se mantuvo como comportamiento de las instancias de la clase lo relacionado a la logica de archivos, ya que resultaba mas coherente que un profesional sea el responsable de manejar su persistencia en el sistema
Los siguientes metodos son comportamientos de la instancia de professionals
  >create_professional_folder , que crea una carpeta con el nombre del profesional
  >rename(newName), renombra la carpeta del professional por el nombre recibido por parametro
  >delete, elimina la carpeta del profesional, retornando un mensaje en caso de que sea exitosa o fallida la operacion, una carpeta no puede borrarse si el profesional posee turnos

# Sobre las validaciones del nombre de los profesionales

Para las validaciones de profesionales, se definio un metodo validate_string(name) el cual se asegura de que el nombre pasado por parametro a la hora de renombrar o crear profesionales sea valido. Que sea valido implica que no este vacio, que no sea solo espacios y que no posea el caracter "/" ya que los archivos en sistemas Unix no pueden poseer este caracter en su nombre.
Este metodo se encuentra en un modulo aparte denominado "Utils", el cual puede encontrarse en `lib/polycon/utils.rb`, junto a otras funciones diseñadas como "helpers" para la validacion de distintas cosas para la herramienta (el resto de funciones serán explicadas mas adelante)
Se decidio que este metodo se encuentre aquí y no como un comportamiento de la clase Professionals ya que el validar que un string sea correcto es un metodo mas general y no algo limitado solo a los profesionales.

# El codigo de los commands de profesionales

En las funciones llamadas a la hora de ejecutar las operaciones con profesionales, se decidio que la funcion ejecutada llame a los validadores necesarios para asegurarse que los parametros ingresados son correctos.
Esto esta hecho de esta forma para que si se dejase de usar la terminal, los validadores pueden seguirse llamando donde sean requeridos sin necesidad de la misma.
 >Puede ver la implementacion de estos llamados a los validadores en `/lib/polycon/commands/professionals.rb`

 



## Uso de `polycon`

Para ejecutar el comando principal de la herramienta se utiliza el script `bin/polycon`,
el cual puede correrse de las siguientes manera:

```bash
$ ruby bin/polycon [args]
```

O bien:

```bash
$ bundle exec bin/polycon [args]
```

O simplemente:

```bash
$ bin/polycon [args]
```

Si se agrega el directorio `bin/` del proyecto a la variable de ambiente `PATH` de la shell,
el comando puede utilizarse sin prefijar `bin/`:

```bash
# Esto debe ejecutarse estando ubicad@ en el directorio raiz del proyecto, una única vez
# por sesión de la shell
$ export PATH="$(pwd)/bin:$PATH"
$ polycon [args]
```

> Notá que para la ejecución de la herramienta, es necesario tener una versión reciente de
> Ruby (2.6 o posterior) y tener instaladas sus dependencias, las cuales se manejan con
> Bundler. Para más información sobre la instalación de las dependencias, consultar la
> siguiente sección ("Desarrollo").

### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias. Si aún no sabés qué es eso
o cómo usarlo, no te preocupes: ¡lo vamos a ver en breve en la materia! Mientras tanto,
todo lo que necesitás saber es que Bundler se encarga de instalar las dependencias ("gemas")
que tu proyecto tenga declaradas en su archivo `Gemfile` al ejecutar el siguiente comando:

```bash
$ bundle install
```

> Nota: Bundler debería estar disponible en tu instalación de Ruby, pero si por algún
> motivo al intentar ejecutar el comando `bundle` obtenés un error indicando que no se
> encuentra el comando, podés instalarlo mediante el siguiente comando:
>
> ```bash
> $ gem install bundler
> ```

Una vez que la instalación de las dependencias sea exitosa (esto deberías hacerlo solamente
cuando estés comenzando con la utilización del proyecto), podés comenzar a probar la
herramienta y a desarrollar tu entrega.
