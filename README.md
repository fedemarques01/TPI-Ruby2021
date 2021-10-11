
## Introducción

Este es una herramienta para gestionar la agenda de turnos de un policonsultorio, en el cual atienden profesionales de diferentes especialidades.

Esta herramienta fue implementada como proyecto para el Taller de Tecnologias de Producción de Software Opcion Ruby
de la Universidad Nacional de La Plata.


## Decisiones de diseño


Para implementar los modelos se creo un modulo Models dentro de Polycon que englobe el modelado de clases Professionals y Appointments, estas clases pueden encontrarse en `lib/polycon/models` en los archivos
`professionals.rb` y `appointments.rb` respectivamente.

Ademas, se creo también el modulo Utils, el cual puede encontrarse en `lib/polycon/utils.rb` que posee distintos metodos de utilidad que son llamados en distintos lugares del programa, como para devolver la ruta hasta polycon o el asegurarse de que la misma carpeta exista.


# El modulo Utils


Como se mencionó antes, este modulo implementa distintas funciones que son de utilidad en distintas partes de la herramienta. Estos metodos son:
  
  >ensure_polycon_exist
  Este metodo se asegura de que la carpeta .polycon exista en el directorio home del usuario, en caso de que no exista avisa en la terminal que no existe y que fue creada en el directorio home, y es llamado al principio de cada call de comando ya que es necesario que la carpeta exista siempre para que la herramienta funcione correctamente.
  
  >path
  Este metodo devuelve la ruta desde el directorio home hasta la carpeta .polycon, se utiliza para que en caso de cambiar la locacion del directorio, en lugar de cambiarlo en cada parte del programa, solo se cambia la ruta de este metodo. Ademas, simplifica el obtener la ruta absoluta en los distintos metodos de la herramienta.
  
  >blank_string?
  Este metodo se encarga de validar el string recibido por parametro de forma tal que no sea un string vacio, es decir que no posea solo "" o solo espacios ("    ").
  
  >valid_string?
  Este metodo se encarga de revisar que el string recibido por parametro no sea un string en blanco (mediante el uso de la funcion blank_string?) y también se encarga de que el string no lleve el caracter / , ya que los nombres de archivo en Unix  no pueden llevar este caracter. Es utilizado para validar que el nombre del profesional recibido sea valido para poder crear un directorio en el sistema.

  >valid_date?
  Se encarga de validar de que la fecha recibida por parametro sea del formato AAAA-MM-DD_HH-II , para asi poder crear los archivos de los appointments de la herramienta.

  >check_options
  Este metodo recibe un hash por parametro ( puede ser explicito o implicito ) y valida elemento por elemento que no sean strings vacios, devolviendo un mensaje que contiene las claves que no cumplieron esta condicion, para luego informarlas al usuario y que pueda saber que parametro ingresado no fue valido. Se opto por un hash con un metodo each en lugar de un select o inject por las siguientes razones:
    Hacer un select solo devolveria un nuevo hash con los elementos que eran vacios y lo que se queria era devolver
    algo mas personalizado y mas entendible para el usuario.
    Hacer un inject causaba que si un elemento no era un string vacio el acumulador se volveria nil, causando un
    error ya que el resto de metodos para validar aplican para strings y no para nil.

  Este metodo es utilizado para validar las opciones recibidas en los comandos de appointments, ya que son varias y todas deben cumplir la misma condicion.

  Todas estas funciones estan declaradas en este modulo ya que son metodos de un uso mas general y no exclusivos del comportamiento de una clase como professionals y appointments.


# Sobre la clase Professionals


Para la implementacion de la clase se definió que como comportamiento de clase que se pueda: 

  >Verificar la existencia de un profesional en el sistema, esto se hace en el metodo exist? 
  >Listar los profesionales del sistema (metodo list_professionals)
  >Definir instancias de la clase en base a un nombre recibido por parametro (initialize)

Se mantuvo como comportamiento de las instancias de la clase lo relacionado a la logica de archivos, ya que resultaba mas coherente que un profesional sea el responsable de manejar su persistencia en el sistema.

Los siguientes metodos son comportamientos de la instancia de professionals:

  >create_professional_folder , que crea una carpeta con el nombre del profesional, tambien retornando un mensaje de operacion exitosa o fallida
  >rename(newName), renombra la carpeta del professional por el nombre recibido por parametro, siguiendo la logica de devolver un mensaje segun el resultado de la operacion
  >delete, elimina la carpeta del profesional, retornando un mensaje en caso de que sea exitosa o fallida la operacion, una carpeta no puede borrarse si el profesional posee turnos

Estos metodos devuelven un mensaje de tipo string segun el resultado de la operacion ya que se esperaba simular algo parecido a los codigos de ejecucion de salida de los programas en bash o C,pero de una forma mas amigable y entendible para el usuario.

Cada metodo que se encarga de manipular los datos del sistema, posee una sentencia rescue y else para definir el mensaje a retornar, ya que puede darse el caso donde ocurra un error al ejecutar la operacion de creado,renombrado o borrado de un archivo, ejemplos de esto pueden ser la falta de permisos para escribir, entre otros.
Además, se implementaron algunos metodos de los comandos de appointments en la clase profesional ya que tenia sentido que un profesional posea dicho comportamiento.
Los metodos son:
  >Eliminar todos los turnos de un profesional(cancel_appointments)
  >Listar en pantalla el detalle de todos los turnos de un profesional(list_appointments)


# El codigo de los commands de profesionales


En las funciones llamadas a la hora de ejecutar las operaciones con profesionales, se decidió que la función ejecutada llame a los validadores necesarios para asegurarse que los parametros ingresados son correctos.
Esto esta hecho de esta forma para que si se dejase de usar la terminal, los validadores pueden seguirse llamando donde sean requeridos sin necesidad de la misma.

El modo de validacion de los parametros es mediante el uso de comprobar que los mismos sean de un formato correcto(como el que no esten vacios) y que no permitan que haya informacion repetida en el sistema, es decir, que un nombre de profesional sea unico, o que el nuevo nombre para un profesional no corresponda con alguno ya existente.


# Sobre la clase Appointments


Para la implementacion de la clase se definió que como comportamiento de clase que se pueda: 
  >Verificar la existencia de un turno en el sistema, esto se hace en el metodo exist?.
  >obtener una instancia de la clase a partir de un archivo, esto implica leer los datos del archivo y guardarlos en los atributos de la clase.
  >Definir instancias de la clase en base a los datos recibidos por parametro(initialize).

Respecto a los atributos de la clase, se opto por el uso de un hash para guardar los detalles ya que el guardarlos de esta forma simplificaba la implementacion de varios metodos de la clase, como el guardar la informacion en un archivo, editar ciertos campos de un turno, etc.

Se mantuvo como comportamiento de las instancias de la clase lo relacionado a la logica de archivos, ya que resultaba mas coherente que un turno sea el responsable de manejar su persistencia en el sistema.

Además, a la hora de mostrar la informacion de un turno, se decidió el primero crear una instancia a partir del archivo en lugar de simplemente leerlo, ya que si en un futuro se decide hacer varias cosas con los datos del turno en un mismo metodo, solo es necesario leer el archivo una vez, y no leerlo cada vez que se muestren todos los detalles del turno, haciendolo mas eficiente en general.

Se incluyo tambien un metodo my_path que cumple una funcion parecida al metodo self.path del modulo Utils, ya que simplifica la escritura de la ruta absoluta a seguir a la hora de crear un turno, y se evita repetir codigo en grandes cantidades. 

Al igual que la clase professionals, se decidió que los metodos que incluyeran manipulacion de los archivos contaran con un manejo de excepciones para el caso donde haya un error al ejecutar una operacion sobre el archivo, y devolver un mensaje de exito o fallo de forma similar a los codigos de error de lenguajes como C y bash, pero que a la vez sean mas amigables y explicativos para el usuario de la herramienta.

Los siguientes metodos son comportamientos de la instancia de appointments:
  >save_file , utilizado para guardar los detalles de un turno en un archivo de texto plano de extension .paf, este metodo es necesario tanto para crear como para editar un turno. Devuelve un mensaje segun el resultado de la operacion.
  >show , cuya funcion es imprimir en pantalla los detalles de un turno en un formato clave : valor , de forma que se pueda conocer cual es cada campo.
  >rename , utilizado para renombrar el turno ( reagendar), devolviendo un mensaje tambien segun el resultado de la operacion.
  >edit_file , utilizado para actualizar los campos de un turno, primero cambiando los valores de las claves del hash y posteriormente sobrescribiendo la informacion del archivo.
  >cancel , utilizado para eliminar un turno. Devuelve un mensaje segun el resultado de la operacion al igual que el resto de metodos que manipulan archivos.


# El codigo de los comandos del modulo appointment


Para validar los parametros de las opciones de los comandos del modulo de appointments de la herramienta, se implemento que ante el caso donde no se especifiquen las opciones , se les asigne el valor "". Se asigna este valor en lugar de nil ya que al ser strings simplificaba el validado de los mismos, ya que podia usar solo validado de strings en lugar de implementar tambien validado de que los parametros sean nil.
Para validar las opciones a la vez se uso el metodo check_options( ya explicado en la seccion del modulo utils ) ademas de validar que existan tanto el profesional especificado o el turno en la fecha ingresada.
Al igual que professionals, esta hecho de forma que la funcion del comando llame a los validadores, y no que las implemente, de modo que si se deja de usar la terminal la herramienta sigue proveyendo los validadores de parametros para la misma.


A continuacion estan el uso de la herramienta y la instalacion de dependencias de la misma originales del template provisto, ya que son de utilidad para aquellos usuarios que quieran usar la herramienta y no sepan como poder usarla.


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
