## Introducción

Este es una herramienta para gestionar la agenda de turnos de un policonsultorio, en el cual atienden profesionales de diferentes especialidades.

Esta herramienta fue implementada como proyecto para el Taller de Tecnologias de Producción de Software Opcion Ruby
de la Universidad Nacional de La Plata.

### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias. Bundle se encarga de instalar las dependencias ( gemas ) del archivo gemfile al ejecutar el comando:

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

### Pasos para utilizar la aplicacion

1. Instalar rails, puede hacerse con el siguiente comando:

```bash
$ gem install rails
```

2. Actualizar las dependencias, esto se hace mediante bundle install

```bash
$ bundle install
```

3. Ejecutar las migraciones, esto generara la estructura de la base de datos que necesitara la pagina. Puede hacerse mediante el comando

```bash
$ rails db:migrate
```

4. Ejecutar el seed, este comando lo que hará sera crear unos datos de prueba para la base de datos. La misma contiene:
 .3 usuarios de prueba
 .3 profesionales
 .Luego se asignan entre 5 y 10 turnos a los profesionales elegidos al azar. Los datos de estos turnos son genericos

 Comando:

 ```bash
$ rails db:seed
```   
5. Las credenciales para iniciar sesion con cada uno de los usuarios son:

> ADMINISTRACION: 
>         Usuario: admin, contraseña: admin123
>
> ASISTENCIA:
>         Usuario: asistente, contraseña: asistente123
>
> CONSULTA:
>         Usuario: consultor, contraseña: consultor123

6. Ejecutar la aplicacion rails de manera local en tu pc

```bash
$ rails server
```

7. Por defecto, la aplicacion estará corriendo en el servidor http:127.0.0.1:3000

8. Permisos de los usuarios

> ADMINISTRACION: Puede crear editar, ver y eliminar usuarios, profesionales y turnos. Tambien puede exportar grillas de turnos.

> ASISTENCIA: Puede gestionar los turnos, pero no puede ver los usuarios, y tampoco puede eliminar y editar profesionales. Puede tambien exportar grillas de turnos

> CONSULTA: Puede ver los turnos y profesionales, pero no puede editar ni eliminar nada. Tambien tiene disponible la opcion de exportar grillas de turnos.


# Decisiones de diseño de la tercer entrega

  Para la autenticacion, manejo de permisos y de sesiones de los usuarios se utilizo la gema bcrypt, esta gema ya viene en el gemfile de la app rails pero comentada. Presenta utilidad para la autenticacion ya que posee un metodo para ello y a su vez provee encriptado de contraseñas automatico, dandole una capa de seguridad a la bd.

  Para el manejo de permisos se opto por verificar que los usuarios posean el rol permitido a la hora de ejecutar ciertas acciones, (como una baja o una edicion). Además, se definieron un par de helpers para el determinar que botones se muestran en el html segun el rol del usuario.

  En cuanto a las validaciones de turnos:

  - Los turnos solo son validos dentro del rango de 9 a 19:30hs y solo son validos a su vez aquellos que tienen el minuto 0 o 30. Esto esta hecho de esta manera para respetar el horario de la grilla de turnos y de los bloques de tiempo de la misma.
  - En el campo telefono de un turno solo deben ingresarse numeros.
  - Además, no pueden haber 2 turnos para un mismo profesional a la misma hora.
  - Respecto a los profesionales, no se añadió ninguna validacion a la hora de crearlos, ya que al poseer solo el nombre y apellido y el hecho de que un nombre y apellido no suele ser unico, se permitió la carga de profesionales
  con mismo nombre y apellido. Sin embargo, si se presenta una validacion a la hora de eliminarlos, ya que en caso de tener turnos asignados no podrá ser eliminado.
  - Los usuarios de la aplicacion tienen un nombre de usuario unico y su contraseña debe ser de al menos 8 caracteres.

  En cuanto a los estilos de la aplicacion, se añadieron unos estilos basicos mediante el uso del framework css bulma, no son estilos muy trabajados pero estan con el proposito de que el contenido de la aplicacion se vea menos "crudo".

  Para exportar las planillas de turnos de los profesionales se utilizaron las mismas gemas que en la entrega pasada, siendo estas prawn y prawn-table. El modulo Export que anterioirmente se encontraba en la carpeta polycon fue ubicado en la carpeta services, dentro del sub-directorio app de la aplicacion rails. Tambien fue adecuado a las corecciones de la entrega anterior, excepto por el generar una lista de horarios del policonsultorio de forma mas programatica.

  Para la base de datos de la aplicacion se utilizo SQLite, principalmente debido a que como el tamaño en general que posee la pagina web es relativamente poco, la perdida de performance al tenes qees algo aceptable con el fin de no perder tanto tiempo 

# Decisiones de diseño de la segunda entrega

Este apartado contempla las modificaciones que se le hicieron al codigo tanto para agregar funcionalidades como para mejorar la funcionalidad existente, correspondiente a la segunda entrega del trabajo

## Corecciones de la primer entrega

Se modificaron distintos metodos para aplicar las corecciones que fueron marcadas en la primer entrega, la más importante es que se cambio el que los metodos retornasen un string como mensaje de exito o error, sino que ahora devuelven un booleano true o false dependiendo del resultado de la operacion realizada, y en base al resultado obtenido se genera un mensaje distinto en el modulo de comandos, ya que es el encargado de generar y mostrar los mensajes al usuario.

Los metodos modificados son los metodos de creacion, edicion y borrado de archivos de los modulos de appointments y profesionals, asi como el metodo `list_professionals` que devuelve un arreglo vacio y se actua en consecuencia a ese.En el modulo de Utils se modificó el metodo `check_options` para que devuelva un hash con los parametros recibidos que sean cadenas vacias, y se actua en los comandos donde se utiliza en base al contenido del hash.

## Los metodos list-all-day y list-all-week

En el modelo de appointments, se agregaron las 2 nuevas funcionalidades solicitadas para esta entrega, se encuentran en el modelo de appointments como un metodo de clase, principalmente porque tenia sentido que el poder devolver todos los turnos de una fecha o semana particular sea un comportamiento correspondiente a la clase, este metodo reutiliza metodos ya implementados en la primer etapa de la entrega, generando un arreglo de turnos en el caso de un dia particular, y un hash con los turnos de cada dia de la semana para la segunda funcionalidad.

## Modificaciones del modulo Utils

En el modulo utils se implementaron nuevos metodos de utilidad para la realizacion de las nuevas funcionalidades solicitadas.

Entre estos se encuentran un metodo para validar la fecha a utilizar para filtrar (`valid_date?`), principalmente para que el usuario pueda conocer el formato de fecha que debe utilizar para filtrar efectivamente los turnos.

Además, se implemento un metodo llamado `get_week_as_string` cuyo objetivo es retornar un arreglo con las fechas de la semana a la cual corresponde la fecha recibida por parametro, es decir, que si yo envio la fecha Jueves 28 de octubre, recibire un arreglo de fechas que comprende desde el dia Lunes 25 de octubre hasta el dia Domingo 31 de octubre.

Tambien se agrego el metodo `report_path` que devuelve la ruta hacia la carpeta donde se guardan los documentos que se exportan

## Concesiones respecto al formato de la grilla de turnos

Para generar las grillas de turnos, se tuvieron en cuenta las siguientes conseciones:
  - La grilla muestra informacion en bloques de duracion fija, estos bloques son de 30 minutos, cada turno no dura más de 30 minutos, es decir, que no se superpone con el turno siguiente.
  - De igual forma, los turnos de un mismo profesional no se solapan entre ellos, no hay sobreturnos. Si esta contemplado el caso donde hayan varios turnos de distintos profesionales en el mismo bloque de tiempo.
  - Los turnos se dan siempre respetando el horario de comienzo de cada bloque de la grilla
  - Se asumió que el horario de apertura del policonsultorio es de 9hs a 20hs, por eso los bloques de tiempo de la grilla solo contemplan desde las 9hs hasta las 19.30hs (ya que el ultimo turno dura de 19:30 a 20hs).

El horario de apertura del policonsultorio aun asi puede modificarse al horario que se solicite, de momento se estimo ese horario ya que era lo más realista.

## Extension del documento y gemas utilizadas

Para generar las grillas de turnos se utilizo la gema `Prawn`, una gema que se utiliza para generar documentos PDF con distintos elementos dentro, desde texto hasta dibujos, graficos e imagenes. Para obtener el formato de la grilla, se utilizo adicionalmente la gema suboficial `prawn-table`, que brinda soporte para generar tablas en PDFs utilizando Prawn. 

Desde un primer momento se opto por utilizar un documento .pdf para guardar las grillas generadas de los turnos, esto se debe más que nada a una preferencia personal hacia este tipo de formato, más que adicionalmente en la vida cotidiana se suelen utilizar más los PDF a comparacion de los documentos .html como documentos de texto rico.
Una vez decidido el formato, se investigó sobre las distintas gemas que existen para generar documentos PDF utilizando código ruby, llegando a las gemas previamente mencionadas.

Adicionalmente, se movio la logica de generacion del documento PDF a un nuevo modulo llamado Export, el cual se encarga de utilizar la gema Prawn y recibir los turnos ya procesados (esto quiere decir que solo se reciben los turnos de la o las fechas a procesar ya filtrados por profesional si se proveyó uno) para generar un pdf con la grilla de turnos solicitada.

Para el guardado de archivos en el modulo Export ,ya que es parte de la funcionalidad para exportar a un archivo pdf, se incorporaron metodos que generan el nombre del archivo en base al profesional buscado y la fecha a procesar, en el caso de una semana el nombre contendrá solo la fecha de inicio de la semana.

Los grillas generadas son guardadas automaticamente en una nueva carpeta llamada .polycon-schedules, que en caso de no existir se crea. La ruta hacia esta carpeta es informada al usuario una vez que se ha generado la grilla, por lo que siempre se puede saber claramente donde estan guardados los pdfs generados.

Los turnos de la grilla se muestran en el formato `Prof. nombre del profesional - Apellido y nombre del paciente`

## Nuevas dependencias

Ya que se incorporaron nuevas gemas, es necesario hacer un `bundle install` más alla de ya haber clonado el repositorio para la primer entrega para que se puedan instalar las nuevas dependencias necesarias para generar el documento pdf con los turnos para un dia o semana particular.

# Decisiones de diseño de la primer entrega


Para implementar los modelos se creo un modulo Models dentro de Polycon que englobe el modelado de clases Professionals y Appointments, estas clases pueden encontrarse en `lib/polycon/models` en los archivos
`professionals.rb` y `appointments.rb` respectivamente.

Ademas, se creo también el modulo Utils, el cual puede encontrarse en `lib/polycon/utils.rb` que posee distintos metodos de utilidad que son llamados en distintos lugares del programa, como para devolver la ruta hasta polycon o el asegurarse de que la misma carpeta exista.


## El modulo Utils


Como se mencionó antes, este modulo implementa distintas funciones que son de utilidad en distintas partes de la herramienta. Estos metodos son:
  
  >ensure_polycon_exist :
  Este metodo se asegura de que la carpeta .polycon exista en el directorio home del usuario, en caso de que no exista avisa en la terminal que no existe y que fue creada en el directorio home, y es llamado al principio de cada call de comando ya que es necesario que la carpeta exista siempre para que la herramienta funcione correctamente.
  
  >path :
  Este metodo devuelve la ruta desde el directorio home hasta la carpeta .polycon, se utiliza para que en caso de cambiar la locacion del directorio, en lugar de cambiarlo en cada parte del programa, solo se cambia la ruta de este metodo. Ademas, simplifica el obtener la ruta absoluta en los distintos metodos de la herramienta.
  
  >blank_string? :
  Este metodo se encarga de validar el string recibido por parametro de forma tal que no sea un string vacio, es decir que no posea solo "" o solo espacios ("    ").
  
  >valid_string? :
  Este metodo se encarga de revisar que el string recibido por parametro no sea un string en blanco (mediante el uso de la funcion blank_string?) y también se encarga de que el string no lleve el caracter / , ya que los nombres de archivo en Unix  no pueden llevar este caracter. Es utilizado para validar que el nombre del profesional recibido sea valido para poder crear un directorio en el sistema.

  >valid_date? :
  Se encarga de validar de que la fecha recibida por parametro sea del formato AAAA-MM-DD_HH-II , para asi poder crear los archivos de los appointments de la herramienta.

  >check_options :
  Este metodo recibe un hash por parametro ( puede ser explicito o implicito ) y valida elemento por elemento que no sean strings vacios, devolviendo un mensaje que contiene las claves que no cumplieron esta condicion, para luego informarlas al usuario y que pueda saber que parametro ingresado no fue valido.Este metodo es utilizado para validar las opciones recibidas en los comandos de appointments, ya que son varias y todas deben cumplir la misma condicion.

  Todas estas funciones estan declaradas en este modulo ya que son metodos de un uso más general y no exclusivos del comportamiento de una clase como professionals y appointments.


## Sobre la clase Professionals


Para la implementacion de la clase se definió que como comportamiento de clase que se pueda: 

  -Verificar la existencia de un profesional en el sistema, esto se hace en el metodo exist?

  -Listar los profesionales del sistema (metodo list_professionals)

  -Definir instancias de la clase en base a un nombre recibido por parametro (initialize)

Se mantuvo como comportamiento de las instancias de la clase lo relacionado a la logica de archivos, ya que resultaba más coherente que un profesional sea el responsable de manejar su persistencia en el sistema.

Los siguientes metodos son comportamientos de la instancia de professionals:

  -create_professional_folder , que crea una carpeta con el nombre del profesional, tambien retornando un mensaje de operacion exitosa o fallida

  -rename(newName), renombra la carpeta del professional por el nombre recibido por parametro, siguiendo la logica de devolver un mensaje segun el resultado de la operacion

  -delete, elimina la carpeta del profesional, retornando un mensaje en caso de que sea exitosa o fallida la operacion, una carpeta no puede borrarse si el profesional posee turnos


Estos metodos devuelven un mensaje de tipo string segun el resultado de la operacion ya que se esperaba simular algo parecido a los codigos de ejecucion de salida de los programas en bash o C,pero de una forma más amigable y entendible para el usuario.

Cada metodo que se encarga de manipular los datos del sistema, posee una sentencia rescue y else para definir el mensaje a retornar, ya que puede darse el caso donde ocurra un error al ejecutar la operacion de creado,renombrado o borrado de un archivo, ejemplos de esto pueden ser la falta de permisos para escribir, entre otros.
Además, se implementaron algunos metodos de los comandos de appointments en la clase profesional ya que tenia sentido que un profesional posea dicho comportamiento.
Los metodos son:

  -Eliminar todos los turnos de un profesional(cancel_appointments)

  -Listar en pantalla el detalle de todos los turnos de un profesional(list_appointments)


## El codigo de los commands de profesionales


En las funciones llamadas a la hora de ejecutar las operaciones con profesionales, se decidió que la función ejecutada llame a los validadores necesarios para asegurarse que los parametros ingresados son correctos.
Esto esta hecho de esta forma para que si se dejase de usar la terminal, los validadores pueden seguirse llamando donde sean requeridos sin necesidad de la misma.

El modo de validacion de los parametros es mediante el uso de comprobar que los mismos sean de un formato correcto(como el que no esten vacios) y que no permitan que haya informacion repetida en el sistema, es decir, que un nombre de profesional sea unico, o que el nuevo nombre para un profesional no corresponda con alguno ya existente.


## Sobre la clase Appointments


Para la implementacion de la clase se definió que como comportamiento de clase que se pueda: 

  -Verificar la existencia de un turno en el sistema, esto se hace en el metodo exist?.

  -obtener una instancia de la clase a partir de un archivo, esto implica leer los datos del archivo y guardarlos en los atributos de la clase.

  -Definir instancias de la clase en base a los datos recibidos por parametro(initialize).

Respecto a los atributos de la clase, se opto por el uso de un hash para guardar los detalles ya que el guardarlos de esta forma simplificaba la implementacion de varios metodos de la clase, como el guardar la informacion en un archivo, editar ciertos campos de un turno, etc.

Se mantuvo como comportamiento de las instancias de la clase lo relacionado a la logica de archivos, ya que resultaba más coherente que un turno sea el responsable de manejar su persistencia en el sistema.

Además, a la hora de mostrar la informacion de un turno, se decidió el primero crear una instancia a partir del archivo en lugar de simplemente leerlo, ya que si en un futuro se decide hacer varias cosas con los datos del turno en un mismo metodo, solo es necesario leer el archivo una vez, y no leerlo cada vez que se muestren todos los detalles del turno, haciendolo más eficiente en general.

Se incluyo tambien un metodo my_path que cumple una funcion parecida al metodo self.path del modulo Utils, ya que simplifica la escritura de la ruta absoluta a seguir a la hora de crear un turno, y se evita repetir codigo en grandes cantidades. 

Al igual que la clase professionals, se decidió que los metodos que incluyeran manipulacion de los archivos contaran con un manejo de excepciones para el caso donde haya un error al ejecutar una operacion sobre el archivo, y devolver un mensaje de exito o fallo de forma similar a los codigos de error de lenguajes como C y bash, pero que a la vez sean más amigables y explicativos para el usuario de la herramienta.

Los siguientes metodos son comportamientos de la instancia de appointments:

  -save_file , utilizado para guardar los detalles de un turno en un archivo de texto plano de extension .paf, este metodo es necesario tanto para crear como para editar un turno. Devuelve un mensaje segun el resultado de la operacion.

  -show , cuya funcion es imprimir en pantalla los detalles de un turno en un formato clave : valor , de forma que se pueda conocer cual es cada campo.

  -rename , utilizado para renombrar el turno ( reagendar), devolviendo un mensaje tambien segun el resultado de la operacion.

  -edit_file , utilizado para actualizar los campos de un turno, primero cambiando los valores de las claves del hash y posteriormente sobrescribiendo la informacion del archivo.

  -cancel , utilizado para eliminar un turno. Devuelve un mensaje segun el resultado de la operacion al igual que el resto de metodos que manipulan archivos.


## El codigo de los comandos del modulo appointment


Para validar los parametros de las opciones de los comandos del modulo de appointments de la herramienta, se implemento que ante el caso donde no se especifiquen las opciones , se les asigne el valor "". Se asigna este valor en lugar de nil ya que al ser strings simplificaba el validado de los mismos, ya que podia usar solo validado de strings en lugar de implementar tambien validado de que los parametros sean nil.
Para validar las opciones a la vez se uso el metodo check_options( ya explicado en la seccion del modulo utils ) ademas de validar que existan tanto el profesional especificado o el turno en la fecha ingresada.
Al igual que professionals, esta hecho de forma que la funcion del comando llame a los validadores, y no que las implemente, de modo que si se deja de usar la terminal la herramienta sigue proveyendo los validadores de parametros para la misma.


A continuacion estan el uso de la herramienta y la instalacion de dependencias de la misma originales del template provisto, ya que son de utilidad para aquellos usuarios que quieran usar la herramienta y no sepan como poder usarla.


> Notá que para la ejecución de la herramienta, es necesario tener una versión reciente de
> Ruby (2.6 o posterior) y tener instaladas sus dependencias, las cuales se manejan con
> Bundler. Para más información sobre la instalación de las dependencias, consultar la
> siguiente sección ("Desarrollo").


