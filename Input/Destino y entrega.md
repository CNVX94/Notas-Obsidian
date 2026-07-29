---
tipo: transcripcion
fuente: "Destino y entrega.txt"
fecha: 2026-07-29
inicio: "13:21"
fin: "14:15"
turnos: 99
turnos_crudos: 726
relleno_descartado: 82
tags: [transcripcion]
---

# Transcripcion 2026-07-29 (13:21-14:15)

> Hablantes: `Bruno` = quien grabo (Local speaker), `Chris/Michael` = todos los remotos juntos (Online speaker). Teams no separa a los remotos entre si.

**13:21 Chris/Michael** ¿Hola Michael, cómo andas? Mostró.

**13:21 Bruno** Hola Cris.

**13:21 Chris/Michael** Pero 1

**13:21 Bruno** Sí, yo se los escucho

**13:21 Chris/Michael** No, no me ha escuchado gracias a ver. Ahí estás. Está cada Bruno.

**13:21 Bruno** ¿Qué onda

**13:21 Chris/Michael** Andan

**13:21 Bruno** Peleándome con cloud, como que siento que ando muy lenta, ya estoy este trabajando. En paralelo, concursos

**13:21 Chris/Michael** Yo ya lo descarté este claro. Unos cursos de. Como que analiza mejor. Trabajo más rápido, no. Es porque ya está el cloud, como que. Con muchas cosas o. ¿Quién sabe? Ahorita no. O mejor lo voy a desinstalar y ya lo vuelvo a instalar otra vez, no, a lo mejor así funciona. Mejor. Este reciba platicar una situación en la parte de los pedidos. Cuando se ingresan. Dependiendo del tipo de pedido, perdón, dependiendo del tipo de entrega, es cómo se va a registrar. Su información, OK de entrada, pues ya sabemos que tenemos los pedidos de paquetería. Tenemos los pedos directos, no que son eso es lo que está trabajando ahorita Rich. Para ingestar, OK, hasta ahí tienen duda. OK, si revisa la documentación de de de de Del proyecto que que acabo de actualizar, Subí mucho unos cambios en la mañana.

**13:23 Chris/Michael** Van a visualizar que hay dos campos nuevos. Este bueno, hay una estructura y en lo que ustedes revisen. Que son justamente 2 puntos importantes del del. Es el pedido. Destino. Ajá o destino comercial. Y la otra es el punto de entrega o destino de entrega o destino operativo. ¿OK? ¿Cuál es la diferencia? ¿La diferencia es que 1 nos va a decir a dónde va el pedido? Ajá. ¿O sea, dónde? ¿A dónde? ¿Hasta dónde se va a entregar. Y el segundo nos va a decir hasta dónde lo vamos a entregar nosotros. OK, eso es muy importante porque para los pedidos centralizados. Un ejemplo bien fácil como el se lo dije a este Richie en la mañana. Le dije, imaginemos que tenemos. Un pedido que nos piden para Liverpool. Tenemos 100 tiendas, imagínense 100 tiendas alrededor del país una en Cancún, una en Tijuana, una en Chihuahua, una en Nuevo León, una en en en Toluca, etcétera, etcétera. Vale. Imagínense eso. Nos piden 100 piezas para cada tienda de un producto. Pero nosotros lo vamos a entregar todo eso, vamos a armar el pedido y todo eso y cada cajita va a una tienda en específico, pero cada cajita vamos a imaginar que hablamos 100 cajitas. Y adentro trae 100 piezas, ese es el ejercicio. Cada cajita va a una tienda diferente, vale. Pero aquí lo que teníamos nosotros era un problema. Era de que esas 100 cajas, nosotros no las entregamos en Cancún, en Chihuahua, en Baja California, Mexicali, en en todos esos lados no los entregamos ahí. Nosotros armamos un pedido centralizado, ajá

**13:25 Chris/Michael** Que es prácticamente juntar esos pedidos y nosotros sin la lo vamos a ir a entregar a un cedis. Ajá, hagan de cuenta el cedis del Tultitlán. Y hasta ahí. Termina la entrega, pero el pedido cuando llega llega que se va a entregar en en todos esos destinos. Vale a eso es el a lo que se le conoce como pedidos centralizado o consolidado. Vale, esto ya lo tenían en entendido así, claro. Sí, OK, ahora el problema era de que de este lado nosotros teníamos como el pedido final. Ajá, bueno, el el, el pedido, el el perdón, el destino ID marcado como el destino ya. Ya final, o sea el el las tiendas, por así decirlo. Vale, pero lo que lo que se trabajó ahorita es de que vamos a tener dentro del pedido dos. Dos opciones. Bueno, dos dos campos nuevos, que se que se generaron. Que es el pedido. ¿A dónde va a llegar? Finalmente, que en este caso es la tienda de Tijuana. Y el otro campo. En dónde lo vamos a entregar nosotros, que en este caso es el cedis de Tooltiep Tultitlán. Vale. Entonces vamos a tener, por ejemplo, en ese ejercicio de los 100 pedidos. Ajá. Todos los pedidos van a tener sus diferentes destinos iv. Vale playa del Carmen, Cancún, Tijuana, este Chihuahua, etcétera, etcétera, pero en el destino de operativo en el destino de entrega vale, lo vamos a tener de que esos se van. A ser distultitlán. Vale, entonces, qué pasa con el directo. El período directo, ambos campos son iguales. El mismo campo de de de como es directo a tienda.

**13:27 Chris/Michael** El campo de de entrega. Comercial es igual al campo. De entrega con este operativa, vale, ahí no hay diferencia, es un es un directo, vale ruta lecheras, lo mismo. La entrega, ambos campos son iguales. ¿Por qué? Porque eso para nosotros es su última milla. Vale. Ahora pedidos de recolección en Cedis, ahí se resuelve. La entrega va a ser, por ejemplo, en Cancún. Pero buena recolectarlo o vamos a entregarlo nosotros en el cedis, es decir, no va a tener transporte, va a ir el cliente al cedis a recogerlo. La entrega es en el en el propio. La entrega es en el mismo nodo donde se va. AA recoger. Ajá, o sea, recolección y entrega es en el mismo punto. Entonces es una entrega en el mismo series. Ah, eso lo va a meter como regla. Con eso. Punto punto PE. La recolección. Pues ahorita lo lo vale, entonces vean. Hice unos cambios aquí. En la parte de los pedidos. Que quiero que lo tengan de su lado. Voy a crear un pedido, ahora lo voy a armar ya con con con un consolidado, vale. Y bien, por ejemplo, movado. Ajá, el cliente va a. Liverpool o Palacio de Hierro, no si Liverpool porque es el único que lo tengo hoy

**13:29 Chris/Michael** Distribuidora Liverpool. Bien, lo voy a entregar en. Vámonos. En León, Guanajuato, tienda 166 o Sinaloa, Mazatlán este. Vale ese pedido. ¿Ahora dónde lo voy a entregar? Si es igual al documental, quiere decir que es una entregada directa. Ajá, pero si no es igual. Ah, perdón, este destino documental entrega operativa. Donde lo voy a entregar. Lo voy a entregar en. Cedis, por ejemplo, distribuidora Liverpool SA de Serven Ciudad de México. Origen. Sin la vale, es decir, este pedido va a Sinaloa, pero yo lo voy a entregar. En el series de Liverpool. Vale, voy a puedo crear otro pedido. Que vaya a. Guanajuato, pero igual va allá, yo le entregué. En Liverpool. ¿OK? ¿Qué códigos necesitamos que agregue agregar en los en las vistas? Y en el formulario. El número de pedido que estoy, eso ya ese ya lo tienen ustedes en este caso, vamos a ponerle ORD. Vamos a ponerle series. Y 11 o dos. Vale fecha de solicitud ahorita. Bueno, esa es la de la del pedido cuando cuando llego en P 8 Código externo. Este es el código del cliente. Vale, este es muy importante que me lo agreguen también. Vale, entonces vamos a ponerle a su cliente. Imagínense que es en su. Código IP ese también lo necesitamos. Este es el código IP del del ERP. Vale, normalmente es un consecutivo, vamos a ponerle 500. 5004. Número de factura, eso también es muy importante, vale

**13:31 Chris/Michael** Pueden ser campos no los al crearlo, sí. Total de factura. 1600 no este. 680000. Vale, esa es la carga. Que vamos a entregar. Ahora aquí. Tipo de entrega. Centralizado. Vale al Huck del cliente. ¿Cuándo lo vamos a entregar? El lunes. A las 0:0. Va cita. Sí es el 3, entonces sería. Y como lo vamos a entregar en el hub de de aquí, de distribuidoras de aquí, de Ciudad de México, pues entonces es el mismo día, vale. 9 no a las cuatro. El. De de 3 a cuatro. OK, perdón, aquí es este 14. Cuatro son las. 16. Serie de las 17. Pedidos centralizado. Y vamos a agregar, por ejemplo, gracias Bluetooth bien rato 10 piezas. Y después este aquí. Después este aquí. Este aquí vale cuanto cuanto este vale todo esto normalmente es. Es el total de la factura. Pero muchas veces no. Entonces esta carga vale 1000000 y medio de pesos. 1200000. Vale alto valor.

**13:33 Chris/Michael** Guardamos. Aquí. Destino documental. Ah, OK, eso es esto es porque nada más me muestra 1. Porque en los tipos de destino déjenme ver si me voy a los catálogos. En los puntos de entrega. Aquí. Uy. Gratis. De modo. De Liverpool. De Liverpool no, no lo encuentro distribuidora Liverpool. Dos están todos los. Los destinos, pero. Aquí viene el pero. Solamente ten. A ver, eso es playa del Carmen. Operativos. De TI no se ve, no se ve bien, pero bueno. Este este que aparece aquí. Ese está porque está marcado como un. Un destino y una entrega. Ahí revisen en la documentación cuál es la diferencia entre el destino y la entrega. Vale una es el destino es a dónde va a llegar

**13:35 Chris/Michael** El pedido, por ejemplo, un pedido que que diga. Playa del Carmen. Ese es el destino playa del Carmen. Pero la entrega yo, yo, yo la entrega, va a ser en el cedis de Jilotepec, por ejemplo. Vale, entonces mi entrega es aquí. Vale, sí se entiende esa diferencia.

**13:35 Bruno** Y el destino, o sea, se agregó para que no fuera tan grandulado tener los dos de referencia.

**13:35 Chris/Michael** No, el destino ya existía. Se agregó el operativo. Porque el sistema confundía. Tu entrega de destino como la que yo voy a hacer y las y las tarifas se hacía sobre ese destino. Entonces vamos a imaginar que en un en un destino consolidado. Centralizado tú me mandabas un pedido hacia hacia Tijuana. De Liverpool. Vale, entonces, cuando se armaba las tarifas, se calculaba. ¿Ajá OO te te cargaba sobre Tijuana. Cuando en realidad tú vas a entregar ese pedido en un cedis de tultitlán. ¿Quién va a entregar la segunda parte? O sea, tú llegas tú entregas en tultitlán. Hasta ahí sin la acabó. ¿Quién? ¿Quién es el que se encarga de entregar recoger ahí en en el cedis y entregar en Tijuana? El propio cliente. No sé si me explico. Vale, entonces nosotros teníamos que el destino, o sea, sí, sí, sí estaba documentado de que va a Tijuana, pero cuando abrías tú las tarifas te hacía el cálculo sobre Tijuana y no más bien el cálculo se tiene que hacer. Sobre si sin la. Tutitlán. Esa es la diferencia, vale, entonces vean. El folio ahora porque me apareció solamente este ced

**13:37 Chris/Michael** Porque en. En el en el MVP. Tienen la tienen la la la vista, 192 del MVP. Del MBC, perdón

**13:37 Bruno** No está actualizada por ahorita te la paso

**13:37 Chris/Michael** No, no, no importa que no se ha actualizado 20. Es este

**13:37 Bruno** 712. Saludos.

**13:37 Chris/Michael** 71002

**13:37 Bruno** Ay, perdón, este es el transcurso es que lo tengo que abierto en el portal operador, es el 5, perdón

**13:37 Chris/Michael** Mira. ¿Dónde anotamos esta diferencia aquí. Puntos de entrega. Ah, bueno, me voy AA clientes. Clientes clientes a. Llevamos, por ejemplo, a Liverpool. De movado aquí está. Bien aquí en puntos del mapa tenemos el destino. Ajá, pero aquí, por ejemplo, si nosotros ponemos. Liverpool express chalco, ensenada. Estos son tiendas. Mire. Tiene 58868. Sucursal 19. Entonces, pero este, por ejemplo, distribuidora este de aquí. Es una entrega.

**13:39 Chris/Michael** Distribuida Liverpool este también es una entrega. Este de aquí el 1 también es un punto de entrega. Aquí la falta distinguirlo entre 6 punto de entrega. O destino aquí en la vista. Aquí. Pero bien, ahí está. Sucursal. Tapachula. Estos son tiendas. Inculven ventas, teléfono, lógica. Aquí en Guadalajara debe haber un centro de distribución es Guadalajara, Guadalajara, tlax. Acapulco. El full express. Este nuevo CD dos este, por ejemplo, también es un una entrega. En jilotepec de vieron. Plaza las Américas, Oaxaca, Liverpool. Todas esas son tiendas. Sucursal sucursal zumpango

**13:41 Chris/Michael** Estos de aquí, por ejemplo. Son distribuidor, vale, entonces vean. Si yo me me vengo acá. Pero pedido y digo, Ah, mira, va a ser un inteligente de de movado. El Liverpool. Estoy veo a la Liverpool. Ajá y va, por ejemplo, a San Luis Potosí. No es igual al del destino. Ahí está cargando los destinos. Aquí tendré aquí, tendré aquí, tengo un aquí, nada más tendría que ahí está el work. Déjenme separar aquí. ¿Cuáles son destinos y cuáles son entregas para que me muestre esta diferencia? ¿Cómo se llama la herramienta del select Bruno?

**13:42 Bruno** ¿Cuál herramienta del APP Group?

**13:42 Chris/Michael** 1 segundo. Para ayudar esto.

**13:42 Bruno** Sino para agruparlos, no separarlos

**13:42 Chris/Michael** Ajá, sí, lo que quiero es separarlos. Espérame

**13:42 Bruno** Sí, sí, ese es el Lope de

**13:42 Chris/Michael** OPT Gro. OK, pero sí me entiende, no. ¿Cuál es la diferencia? De hecho, creo que mandó los cedis hasta acá arriba. Miren, porque aquí viene administrador y viene APPPYSD, pues como están ordenados. Sí me lo separo, bueno, o sea, no hay solo PT Group, pero se ubica que estos son los que yo acabo de marcar acá. Como puntos de entrega, vale, entonces mi mi, aunque yo cree varios pedidos que van a San Luis a Zapopan, a Puebla, Chihuahua, Guanajuato.

**13:43 Bruno** Entrega, sí

**13:43 Chris/Michael** A ir algo, etcétera, etcétera. Vale la realidad es de que mi cálculo de tarifa va a ser sobre sobre el cedis, OK. Eso a nosotros nos va a ayudar para poder agrupar mejor los pedidos. En función de cómo se van a entregar, aunque tú tengas 20000 destinos. Si todos van al cedis. Los puedes este centralizar. Ajá o consolidar. ¿Ahora, qué información? Bueno, aquí. Ya se ve un poquito más la información. Este de aquí también va en Luis Mosé, dice León. Entonces, con esta información así. ¿Qué puedo yo decirte? Mira, aunque este va Mazatlán y este va a Guadalajara. Los puedo combinar. Sí, porque la porque el el destino real es este. En el que nosotros vamos a armar el viaje. OK, sí se entiende.

**13:44 Bruno** Sí, hermosa.

**13:44 Chris/Michael** Pues bien, qué información tenemos nueva. Tenemos obviamente el el número de orden, que es de P 8. La fecha en la que se creó. Este el número IP, el número de la factura y el valor de la factura. El cliente, perdón, la compañía, el cliente. Y el valor de la carga. Vale, tenemos origen, tenemos el destino y tenemos entrega. Vale, si tienes cita. Cuando no nada más así de. Cita ya no. Cuando se cuando la promesa normalmente la la promesa es esto, es antes de esto y la cita, pues es puede ser un día antes o puede ser. Ese mismo día. Aprobado la carga bueno que esto de de la. Del valor de la carga esto de aquí tendría que ir acá, en en la carga, Eh, aquí. O sea, esto de aquí. Esto valor y todo aquí. Ahorita lo lo corrijo. He estado confirmado, vale, y si nos vamos al detalle. A mira dice que ya lo a ver. El Lopete Group. Vámonos a movado. Vámonos a. Liverpool, distribuidor de Liverpool.

**13:46 Chris/Michael** De verdad de Liverpool están destino, vamos a vamos a crear otro nuevo para que vaya 3. Mérida. Igual que el destino. No, entonces cedes, ahí está. No sé por qué no, no sé si estoy en otra base de datos o por qué no me guarda la los cambios, porque eso es lo que hizo Richie, el cambio que hizo Richie. Pero no me están saliendo los edis que ahorita acabo de registrar

**13:46 Bruno** Es que no Richie todo en otra no, porque nosotros seguimos en la de Cuba. Sí, pero no sé en cual esta según ya estamos en la misma, la de Laxon, este punto QA. Y creo que Richie creó la dequa punto P 8 ingesta. Y la de cuate este es la de. Isaías. Sorteo nada más tenemos

**13:47 Chris/Michael** Sí, yo estoy en axon. Qua entonces se me hace que la de la de aquí esta está apuntando a la ESA Pi que está aquí está apuntando a otro

**13:47 Bruno** No estoy apuntando a la misma a la 20, porque yo estoy haciendo las liberaciones manuales.

**13:47 Chris/Michael** Chivas, pero entonces, por qué no me salen estos acá. Es que me tendrían que salir esto como cedis y este de aquí lo marcó Richie en su base de datos, ahí lo marcó este. Este lo puso.

**13:47 Bruno** A ver cliente perfil distribuidora, déjalo levantar

**13:47 Chris/Michael** Es hasta le puso así

**13:47 Bruno** A ver mismo vista de clientes. La Liverpool lemouvaso

**13:47 Chris/Michael** Y notepec. También más inclusive están mis mal sus sus este. OK, pero bueno, no sé por qué no me salen estas acá. OK, entonces acá cuando hacemos los pedidos. Eso es lo que tiene que que revisar. Que toda esta información la podamos registrar, vale. Entonces ya teníamos la compañía, eso está bien, ajá. El pedido está bien, cliente a ver movado. Eso está perfecto, aquí es donde este. Liverpool. Eso está muy bien. Fecha de solicitud

**13:48 Bruno** Sí, pero ahorrar espacio que fue de los cambios que te decía porque no es que ya me salen un buen y. Tiene que quedar todo dentro. Y este va cargando, o sea, te pone un lote de 50 y cuando vas bajando te vuelve a cargar los otros 50, o sea, no te los carga de golpe.

**13:48 Chris/Michael** Va aquí, nada más para entrega planeada. Ajá, está bien. Fecha de solicitud 29, por ejemplo, vamos a entregarlo. 30 para mañana. Aquí en las horas de las citas. Este vamos a dejarlo entrega planeada solamente como fecha. Y si no era porque normalmente o si déjale ahora, pero que sea, por ejemplo, las de 1 a 24 horas y ceros. 0153045 y ceros va. Así, porque nuevamente las citas no es así como que te voy a citar a la 1,52,52 minutos, no, o sea, ahí es horas cerradas, casi casi. Inteligente ajá aquí el origen, eso está muy

**13:50 Chris/Michael** Y aquí es donde este. Donde ustedes tienen que trabajar esta parte. Una para qué, para que si yo digo sabes qué bueno, yo lo tengo de este lado. Y es directo. Pues este es igual. Calestina. Ajá, sí, centralizado, entonces sí es en el en un hub. Vale, entonces y aquí el el destino, aquí ya a diferencia de esta parte, el documental con el operativo. Vale pes. Del pedido esto no, no lo requerimos aquí, mire.

**13:50 Bruno** De hecho, estaría bueno, no tendría que ser un cele que puedas editar porque eso se calcula con base a los ítems que agregues ent

**13:50 Chris/Michael** O sí dejarlo abierto. Porque a lo mejor ya sabes cuanto es como esto nunca lo van a ocupar, pero la idea es de que ustedes puedan hacer esto registrarlo. En el en la base de datos completamente vale. El valor total, el volumen, pues pueden dejarlo dejarlo cero. Esa es la parte

**13:51 Bruno** Porque es que creo que se van a sobreescribir cuando seleccione su ítem, bueno, al final al único ítem que le añadí peso este y medidas fue hasta abajo 1 de. De latamel un roku Express, pero los demás no tienen esas medidas, claro, YO sea todo. Como no está terminada la la ingesta. Este MP me he metido a editar directamente los productos que con los que he estado probando y como he probado la tamel, nada más hay un recupremier que tiene medidas.

**13:51 Chris/Michael** Va, vamos. Agregarlo así. Vamos a arreglar, así como está. Es unitario. Aquí si lo si lo tienen, si no. Este un peso por default vale y bien agregar partida. ¿Qué información necesitamos? Que se pueda modificar esta parte. Vale, entonces aquí está muy simple. Aquí está más enriquecida, vale y más estructurado. ¿Notas? Pues no, o sea, este este yo creo que lo podemos quitar y aprovechar ese espacio para agregar esta otra parte va. Vamos a agregar, es todos agregar 10 piezas. Y sí, como tú dices, acá se va haciendo el cálculo en función cuando tú vas agregando, no, aquí ya se va sumando esto por esto ya te da aquí, aquí sí funciona así. Bueno, De hecho, todavía. Ah, sí, creo que sí. 10 por sí, pero por ejemplo, si yo le quiero modificar el peso. No puedo a cada pi. Ya estoy asumiendo que esto pesa 400 y acá. Este y esto lo del valor de la mercancía, esos también es importante marcar si es alto valor, vale, eso también agrégueselo. ¿Por qué? Porque

**13:53 Chris/Michael** Es con eso, vamos a definir el el costo, entonces, por ejemplo, si esto nos dice que que cuesta un peso, un peso y un peso si cuesta 3 pesos tu carga así, pero en realidad esto vale 1000000 y medio no. Entonces necesita custodia

**13:53 Bruno** Sí, sí, no nos agregamos los compost que falten del o sea que están en el MP en el ITMS. Ahora sí, lo más que nada más es este agregar y no rehacer.

**13:53 Chris/Michael** Igual aquí código externo. Cliente 9 código IP, vamos a ponerle este 48. Me factura en la 3. Ajá, total de factura. Pues sí, sí, sí, esto, si el valor de la macancia vale 1000000, pues obviamente el valor de la factura, pues a lo mejor es este de 1 punto. 8000000. Centralizado, fecha y hora comprometida. Aquí. 30. 30, ahí está. Bien, ya está perfecto confirmar. ¿Listo, vale? Entonces ya tenemos. Este va Mérida Mazatlán, Guadalajara. Pero en si estos 3 los voy a entregar al mismo lugar. Mañana va. Ahora detalle. ¿Qué más para terminar esta parte? A ver, vamos. Ya me falta aquí por guardar. Ah, este es consolidado. Aquí este se va a zapopan, por ejemplo. Sí, miren, dice que no tiene tarifas. Pero la realidad es de que esto todavía no está bien cableado. Pues aunque que vayas a popa no quiere decir que no lo pueda entregar, sí lo puedo entregar. ¿Por qué? Porque mi mi entrega real es en el cedis

**13:55 Chris/Michael** ¿Y si tengo tarifas para. Para Ciudad de México. Bueno, tú este. Ese es en. Jilotepec no me parece. Vale, entonces, bueno, desde aquí ya vemos que sí está marcable. Vamos a ponerle que esa fopa. Igual. OK, sí, ya debería, vamos a ver si si no aparece acá. Es porque sería mirecista.

**13:55 Bruno** Sí es que tengo que estar raro porque si luego las pruebas que hacias las dejaba para no. Este interferir. Pero si estamos dando la misma base.

**13:55 Chris/Michael** Vale, pero. Lo que sí es que no me guardo. El el destino real. Vean la diferencia, esto también ya lo fíjense. Aquí está lo lo lo que hay que hacer. Y este vea. Ya tenemos aquí el pedido, dice que va que sale de Ciudad de México y va a Mérida, por ejemplo. Pero me entrega operativa es en cedis. Y este nada más me marca dos

**13:56 Bruno** Ajá, sí, sí, del combos que faltan de añadir, sí

**13:56 Chris/Michael** Esta información es muy importante que me la mostremos acá en en el pedido, vale es es este, no. Tenemos la compañía, tenemos el cliente, tenemos la cita que ya tenemos, la promesa, la carga, la el valor de la mercancía. Y aquí no sé por qué dice transporte dedicado. Porque esto todavía en teoría todavía no lo definimos. Vale, entonces este déjenmelo revisar. Pero obviamente aquí ya tendría que decir el el transporte, no. En este caso va a ser 111 transporte de flet. Vale código externo, código Ipefacture total de factura. Vale, entonces, cómo se metió de forma manual cuando se solicitó vean, aquí está todo todo el cabecero del del pedido, vale, entonces ya está bien distribuido. ¿Eh? Y ya está esto, lo del siguiente. Del trabajo es como son como como como ayudas, no que nosotros podemos mostrar las pueden poner si si. Pero si no, esto es esto es no importante. Se los dejo en el emipi porque ustedes pueden venir aquí y ver cuál es el sinte paso, v. Entonces, estatus general. Transporte manifiesto y programa vale

**13:58 Chris/Michael** Carga. Esto prácticamente ya lo tiene en aca. Aquí lo tiene resumido. Él, aquí lo tienen a detalle. Vale y podemos nosotros configurar esto acá en teoría no se podría menos de que yo le de evitar. Pedido. Tenemos este. Las partidas del pedido. Y la distribución. Cuando no hay distribución, entonces en este caso, por ejemplo, todas estas cajas vamos a meterlas en 10 cajas. De este lado. Nuestra en 10 cajas. Ajá y vamos a sellarlas todas extrañky la por cada caja y marchamos a ponerle sello. Y las sellamos todas. Vale, esto lo podríamos hacer aquí. Si hacemos esto aquí de las cajas no se Bruno, tú dime si es necesario tener el menú de empaquetar.

**13:59 Bruno** Es que también ya hay una. Bueno, en el ITMS. Esta es la parte del del empaquetado, pero. Este se supone que ya eso se va a hacer como automático, no. Entonces este, o sea, nada más. Ajá. Es que yo ahí había dejado como ese prototipo de empaquetar to

**13:59 Chris/Michael** OK, es este no

**13:59 Bruno** Pero fue cuando yo tenía la duda de bueno, o sea, porque los vamos a empaquetar si ya vienen en cajas de p 8, no, entonces era cuando yo tenía esa duda y empecé a trabajar eso, pero lo descarté porque en teoría ya iban a llegar este empaquetados. Entonces, como ya se hace aquí, lo que yo hago es que empaqueto todos o ya las distribuya o se distribuye en x cajas

**13:59 Chris/Michael** Ja

**14:00 Bruno** De que las distribuye, te las manda, o sea, de pedidos son, no sé 200 piezas, necesitas este. Tal cantidad de cajas grandes ya me las pone al lado, entonces si lo implementamos sería más por si no pasamos este paso y le damos sin empaquetar, pero creo que ya estaría además porque aquí es donde se hace. O sea, de cualquier forma, todos los pedidos que he estado creando los he estado empaquetando, entonces ya aquí como que ya ya estaría bueno, siento que ya estaría además meterlo porque además es para nuestras pruebas ya desde aquí se hace eso

**14:00 Chris/Michael** No, más bien este Bruno sí está bien. Sí lo vamos a dejar, sí es importante sabes por qué. Porque el proceso de empaquetado, aunque sí, como bien dices, no, ya va a venir impactado, sí. Pero el TMS tiene que tener la posibilidad de hacerlo de forma manual, así como la ingesta de pedidos no es como si me dijeras, es que para qué, para qué le damos claro un pedido, si ya vamos a ingestarlo, sí,. Si nosotros lo podemos crear manualmente, quiere decir que también lo podemos registrar de forma masiva igual para la parte de las cajas. Si si tienes tú un proceso de armado de cajas. Pues el el que vamos a tener. Es este el. El de armado de cajas. Se va a hacer de forma automática, vale, entonces sí es importante entretenerlos y sí, ya vi el mío solamente te soporta empaquetado en caja, pero el tuyo ya en tarima en en en varios tipos y te carga el el el catálogo de tarifas de de cajas que tienes, entonces está está muy bien, hay que validar. Que que que funcione correctamente autoempaquetar esta propuesta, o sea, yo lo

**14:01 Bruno** Si tenía detalles, es que ahí sí, por ejemplo, le implementé que te pusiera como. Cuando son varias, cuando ocupas varias cajas. Le puse que te sugiriera la. El tamaño de la caja que ocupa menos o que gastes menos, o sea, que haga que ocupas menos menos cajas, pero te lo resuelve hasta ahí lo dejé de las pruebas rápidas que hacía. Sí me distribuía bien las cajas y De hecho te avisa cuando ya está una sobrecargada. Entonces, esa parte, pues sí, ya ya está, nada más sería verificar que que. Puesionando, viene y que distribuya mucho, porque si gusta el día que termine eso ya fue cuando me resolviste al lado y dije, bueno, pues ahí lo dejo, no lo descarto, pero pues ya ahí que se quede.

**14:02 Chris/Michael** Va va, OK, perfecto, sí lo veo perfecto. Este ya nada más valida, sí, todos eso se tendría que hacer en sí. Esto ya lo hacen en p 8, pero está bien que lo tengamos acá porque es justamente como vamos a armar. Va

**14:02 Bruno** Sí, ya este en su momento sería validar que Ah, bueno, este ya viene con caja, entonces pues ya no lo puedo meter en otra caja, que eso sí, no, no está validado en. En armar en empaquetar.

**14:03 Chris/Michael** Este esto lo veo bien, vale ya nada más aquí. Eso está perfecto, nos falta. Ese es el el timeline de Estados, pero es el nos falta el el este. El flujo operativo. Vale, son 222. ¿Cómo le va? Dos flujos que vemos el operativo y el tracking. Vale del pedido. Y el historial de la bitácora. Vale, eso lo nos falta de este lado. Vale las cajas

**14:03 Bruno** Ah, bueno, sí, sí está, pues son de las capturas que te había mandado el otro día. ¿De qué está? Es que tenemos la carta este del tracking y el time life de Estados junto con la histórica y bitácora, pero como no se ha llegado, creo que por eso no se muestra. Ya deja tomando captura de las dos, pero esas sí están en el detalle

**14:03 Chris/Michael** Ah, bueno, ya cuando lo tengas quieres, me me los mostramos

**14:03 Bruno** Pedido.

**14:03 Chris/Michael** Y ya lo lo vemos, vale, yo estoy tratando de hacer este MVP lo más más nutrido que se pueda, vale, entonces la idea es de que ustedes se metan y vean toda la información, por ejemplo, lo que sí no van a meter. Es, por ejemplo, este no paquetería compone partidas snapchat, o sea, este esto si no

**14:04 Bruno** Sí, De hecho, ayer que me estaba poniendo con con Claudia en el diseño, me estaba metiendo esas cosas. Y si cambió varias y ahorita lo que yo estoy haciendo. Es este la parte de las este de la asignar el el transportista junto con el operador, o sea, con el botón de ofrecer al transportista, el mismo que está en el MVP, ya sea así, solo que del lado del portal del transportista ya estaba quedando como medio rebuscado, que es lo que estoy arreglando, porque ves que está la bueno, añadiste la vista de programas ofrecidos. Entonces yo lo que hacía es que en mis viajes. Ahí aparecía el botón como de asignar este recursos, entonces cuando tú le asignabas recursos, o sea, la unidad junto con el operador. Este le dabas en guardar, ya eso era como si tuvieras aceptado. Ese viaje entonces en el programa de ofrecidos estoy haciendo un como refactor para que ahí mismo me me muestre ese modal que también le falta información porque no me ponía la unidad que necesitaba, o sea, lo que está en viajes lo estoy pasando, es decir, otra forma al programa de envíos. Y en viajes únicamente está como los que ya están aceptados con la posibilidad de poder editar este el operador o. La unidad, pero estoy viendo este si lo dejo separado o lo unifico en dos vistas porque prácticamente son una copia, por así decirlo, en la misma te sale el modal exactamente el mismo modal para asignar el operador y el. El el vehículo entonces es lo que estoy trabajando, porque también ya estaba a la vista del programa de Embarques, Ahorita la como ya no he liberado

**14:06 Bruno** El el web up. No aparece, pero estoy este con el rediseño de El detalle del programa de embarques porque se perdieron como algunas cosas que ya estaban o cambiaron de lugar. Eso es ahorita en lo que. Me quedo trabajando. Entonces, ahorita planeaba de los cambios que mencionaste este dárselos a Michael para yo terminar de este lado. Ya todo lo de citas, porque si todavía no queda y es que ayer este igual me tardé por hacer toda la migración, ahorita ya quedó con el nuevo modelo. De este, el facility appoinment, que era de de la migración que habías hecho ya todo está bien y creo que este Michael hace rato y terminó de borrar el modelo viejo. Las funciones que tenía ese modelo viejo, entonces ahorita ya está el modelo nuevo, porque también por tener esos dos, Claudia se andaba confundiendo a las vistas y en una estaba mezclando el viejo y en otra estaba usando el nuevo. Entonces estaban como que conviviendo, pero estaban, o sea, no, no estaba cableado, estaban desconectados entre sí. Entonces, ya de ahí este me fui tendido, pero sí esa fue más la la talacha. Pero sí ceci es como como va

**14:07 Chris/Michael** Vale, entonces sí, sí, sí, yo por ejemplo aquí, si ustedes ya copiaron esta vista, yo lo voy a arreglar porque miren si se dan cuenta. Dice que este va a Guadalajara, este va Mazatlán, pero la realidad es de que todos en sí van al mismo series están de acuerdo. Entonces, más bien aquí tendríamos que agrupar por series.

**14:07 Bruno** Sin planificación del MVC.

**14:07 Chris/Michael** Esa experiencia. Entonces, esos son de los cambios que que estoy haciendo, integrando el tema del de de los destinos. Y las entregas vale, entonces, marcando bien esa diferencia. Es como lo vamos. A diferenciar, vale, entonces yo sigo revisando este NBT, vale, y ustedes carguen las nuevas actualizaciones en las en el contexto de de sus ías. Para que puedan este ya entender bien cómo se va a trabajar esto vale. Vamos para

**14:08 Bruno** Si aquí también está el mismo detalle, sí, porque aquí es la vista de armar plan. Que ella es donde. Sí, o sea, armas el plan, pero sí aquí es este en. IT mes es donde mostramos el mapa al lado para los puntos. Grupo mucho espacio. No sé si se rediseña.

**14:08 Chris/Michael** Sí, porque el manifiesto. O sea, todo eso se tiene que corregir. El manifiesto me va a decir. Que, por ejemplo, voy a entregar. Todo esto, pero en el cevis. O sea, no es un manifiesto por pedido. Es un pedido, es un manifiesto que incluye todos los pedidos, pero que me va a decir que se entrega eso en el CERIS. Así tiene que salir de manifiesto, vale, por eso les digo, yo voy a revisar todo esto, hacemos el refactor y el recableado de de todo eso dentro del MMBC ya está todo, EH, o sea, si llegase a faltar algún algún emp. Este acá lo lo estoy creando. Bueno, por ejemplo, aquí ya ya hizo un aquí, ya creo las. Las este. Externa Markets folios allá ya agregó todos los campos que les estoy este pidiendo, vale. OK, para que va, pues nada más era para eso. La la reunión, entonces los dejo. Continuar, yo sigo acá revisando. Y este y sigan merchán, bueno, estamos en la misma rama, entonces todo lo que yo subo en NBT. Ya lo van a tener ustedes disponible, va para revisar o para que su guía revise. Y lo traslade al al MBC va.

**14:09 Bruno** Este vamos a tener juntas con sin la mañana o esta semana para mostrar estos avances

**14:09 Chris/Michael** Sí, lo más probable. Es este que sea. Déjenme abrir mi calendario, es que teníamos varias. Pero tuvimos que emplazar los tiempos. Teníamos una hoy que se canceló. Porque no nos va a dar tiempo. Entonces, este ahorita estamos revisando el tema de los pedidos, yo estoy revisando este cableado para poder integrar yo a los centralizados. Richard todavía no termina los directos ni los pedidos a tienda, los directos atiendan ni los de paquetería. Él está trabajando en eso. Pero ya una vez teniendo eso, vamos a empezar a trabajar los centralizados, entonces la idea es de que mañana nos reunamos en la tarde, o sea, esta reunión era para. En sí, más adelante, mañana a las 5.

**14:10 Bruno** Para probar el flujo de iTs no y ver los detalles, OK, sí

**14:10 Chris/Michael** Y sacar inclusive nada más el manifiesto vale. Para bien. Y este, con la nueva información, eso el manifiesto es un eso es del API, entonces eso yo me encargo, yo lo trabajo, lo hago pruebas y ya ustedes ya nada más lo consumen, o sea, ustedes no hacen cambios ahí. Nada más. Este lo que sí no sé, Bruno es si los logos de las de las compañías y los fletes y demás se guardan en el MBC verdad.

**14:11 Bruno** Es. Es que como por ejemplo una foto que yo suba desde el ITMC. Este se tiene que ver en el portal desde el transportista. Entonces, en el servidor este la carpeta que comparten no está a nivel del proyecto, sino una general. Donde los dos están, o sea, donde los dos portales tienen la misma, el mismo acceso. O sea, las dos instancias comparten una carpeta que no está en en su raíz. Así es como esta

**14:11 Chris/Michael** OK, sí, porque porque por ejemplo, cuando yo quería ver citas. Ejemplo, vamos aquí más a eso también parte todavía no. Pero cuando yo quería ver una cita. Y ponerme la foto del. Del transportista, por ejemplo

**14:12 Bruno** Ajá, no dejo.

**14:12 Chris/Michael** Me salía así. Me salió sin la foto. Pero eso es porque estoy local, no porque mi APP es local.

**14:12 Bruno** Pero es que ya ya tiene la ruta de las fotos, lo reviso, es que como nada más vi que ya me lo mostraba en los dos portales. Ya no lo lo revisé bien porque sí le o sea, se lo plantea a cloud, que me acuerdo que ese día te pregunté que si las fotos se iban AA ver en un portal y en otro, entonces ahí fue cuando dije no, pues es que se los pongo a nivel race, pues no van a tener acceso, entonces mejor una compartida. Pero igual este lo. Lo reviso. Porque al menos

**14:12 Chris/Michael** Sí, porque no sé si por ejemplo este código QR. Bueno, en este se genera. Pero, por ejemplo, si vamos a imprimir. El este, pues tendría que salir el logo de sila y todo eso no para para que quede personalizado. Y, por ejemplo, para los manifiestos voy a imprimir un manifiesto. Descarga PDF. Ese es 111 programa de embarques. Entonces, por ejemplo, si yo lo descargo. Aquí me dice. Toda esta información. Vale, pero sí me gustaría, por ejemplo, que aquí saliera el logo de Sinla, entonces este programa de embarques, por ejemplo, que es de werfen. El cliente entonces aparezca su su, su, su destino, quién es el portador optar y aparezca su logo, o sea que esté todo visualmente.

**14:13 Bruno** Es un logo así

**14:13 Chris/Michael** A visible no entonces. Chécalo, o sea, ahorita no es importante. Pero si es necesario guardar la imagen en en mapa de bits dentro de la base de datos. Para que navegue porque sí van a hacer varios portales, lo que lo vamos en donde lo vamos AA generar y nuevamente estos estos entregables. Los vamos a descargar desde varias fuentes, lo vamos a descargar en la API, los vamos a descargar en la en el web APP, lo vamos a descargar en el portal de clientes, en el portal de proveedores, por ejemplo, entonces son 3 portales. Que si tú nada más lo guardas en el NBC. En los dos portales, como como acceden a esa en esa vista, ajá, vale

**14:14 Bruno** Sí, por eso es que quedó como esa carpeta general a donde todos accedían, pero todas formas este lo verifico porque te digo que en su momento este le di la idea AA Claudia una forma de que quedarán en una carpeta. Fuera de las instancias y estuviera como compartida. Y como vi que ya me salía en en los dos portales, dije, Bueno, creo que si quedo porque ya lo que subo acá este lo estoy viendo en el otro, pero de todas formas este lo verifico para ver también este, pues cómo sería el tema de liberaciones, no, y también hacer que esa ruta sea no sea configurable de cierta forma para que no sea tan difícil este las las liberaciones que no creo, pero lo lo reviso también es así, yo yo lo reviso

**14:15 Chris/Michael** Va para que va, porfa. Va vientos entonces ya quedó todo claro, entonces nos vemos este. Mañana vale, entonces cualquier detalle, yo los yo les marco, vale preguntamente para aclararles esta parte y este y quede va, pues ahorita pues ya quedó claro, no. Va muy bien, sale, pues entonces nos vemos después, gracias.

**14:15 Bruno** Nos vemos

**14:15 Chris/Michael** El crédito.

