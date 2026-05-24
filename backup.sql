PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE leads (
	id INTEGER NOT NULL, 
	nombre VARCHAR NOT NULL, 
	empresa VARCHAR, 
	correo VARCHAR, 
	telefono VARCHAR, 
	estado VARCHAR(11) NOT NULL, 
	fuente VARCHAR, 
	notas TEXT, 
	creado_en DATETIME DEFAULT CURRENT_TIMESTAMP, 
	fecha_actualizacion DATETIME, 
	PRIMARY KEY (id)
);
INSERT INTO leads VALUES(1,'Juan Perez','KiloTiendas','juan@kilotiendas.com','84355267','cold','WhatsApp','','2026-05-24 18:24:36',NULL);
INSERT INTO leads VALUES(2,'Isabella Castro',NULL,NULL,'+506 7012-4498','warm','WhatsApp',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(3,'Carlos Mendoza',NULL,NULL,'+506 8824-1360','cold','Formulario',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(4,'Ana Lucia Morales',NULL,NULL,'+506 6193-7752','hot','Referido',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(5,'Pablo Cordero',NULL,NULL,'+506 8450-9027','appointment','LinkedIn',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(6,'Maria Jose Aguilar',NULL,NULL,'+506 7288-0145','cold','WhatsApp',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(7,'Esteban Arias',NULL,NULL,'+506 8731-5629','warm','Otro',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(8,'Valentina Gomez',NULL,NULL,'+506 6017-3348','hot','Formulario',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(9,'Luis Fernando Rivas',NULL,NULL,'+506 8966-2201','warm','Referido',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(10,'Daniela Pineda',NULL,NULL,'+506 7105-9483','cold','LinkedIn',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(11,'Nicolas Soto',NULL,NULL,'+506 8312-6570','appointment','WhatsApp',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(12,'Paula Villalobos',NULL,NULL,'+506 6259-7814','warm','Formulario',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(13,'Jorge Alvarado',NULL,NULL,'+506 8890-4352','cold','Otro',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(14,'Samantha Chaves',NULL,NULL,'+506 7044-1986','hot','Referido',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(15,'Miguel Angel Torres',NULL,NULL,'+506 8477-3095','warm','LinkedIn',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(16,'Carolina Urena',NULL,NULL,'+506 6308-5571','cold','WhatsApp',NULL,'2026-05-24 21:48:00',NULL);
INSERT INTO leads VALUES(17,'Rafael Bonilla',NULL,NULL,'+506 8952-6634','appointment','Formulario',NULL,'2026-05-24 21:48:01',NULL);
INSERT INTO leads VALUES(18,'Fernanda Lopez',NULL,NULL,'+506 7221-0059','warm','Referido',NULL,'2026-05-24 21:48:01',NULL);
INSERT INTO leads VALUES(19,'Adrian Campos',NULL,NULL,'+506 6114-8720','hot','Otro',NULL,'2026-05-24 21:48:01',NULL);
INSERT INTO leads VALUES(20,'Luciana Vega',NULL,NULL,'+506 8399-2468','cold','LinkedIn',NULL,'2026-05-24 21:48:01',NULL);
INSERT INTO leads VALUES(21,'Roberto Salas',NULL,NULL,'+506 8706-3197','warm','WhatsApp',NULL,'2026-05-24 21:48:01',NULL);
CREATE TABLE usuarios (
	id INTEGER NOT NULL, 
	correo VARCHAR NOT NULL, 
	password VARCHAR NOT NULL, 
	nombre VARCHAR NOT NULL, 
	telefono VARCHAR, 
	empresa VARCHAR, 
	creado_en DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id)
);
INSERT INTO usuarios VALUES(1,'greivin@bemantis.com','$2b$12$5eT67Bz3sAvUFJ2yPQCth.F0w2Y6F4qgCocLxivOW1T33wvu34W8G','Greivin Cruz Rios','84925499','Bemantis','2026-05-24 05:38:30');
CREATE TABLE interacciones (
	id INTEGER NOT NULL, 
	lead_id INTEGER NOT NULL, 
	fecha DATETIME DEFAULT CURRENT_TIMESTAMP, 
	tipo VARCHAR(18) NOT NULL, 
	estado VARCHAR(11), 
	contenido TEXT NOT NULL, 
	agente VARCHAR NOT NULL, 
	creado_en DATETIME DEFAULT CURRENT_TIMESTAMP, 
	PRIMARY KEY (id), 
	FOREIGN KEY(lead_id) REFERENCES leads (id) ON DELETE CASCADE
);
INSERT INTO interacciones VALUES(1,17,'2026-05-24 22:25:20','nueva_conversacion',NULL,'Hola Arthur, me interesa saber como Bemantis puede ayudarme con los leads que llegan por WhatsApp.','Rafael Bonilla','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(2,17,'2026-05-24 22:25:20','seguimiento',NULL,'Hola, soy Arthur. Puedo responder consultas iniciales, capturar datos clave y registrar cada avance del lead.','Arthur','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(3,17,'2026-05-24 22:25:20','seguimiento',NULL,'Perfecto, ahora mismo perdemos oportunidades porque respondemos tarde en las noches.','Rafael Bonilla','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(4,17,'2026-05-24 22:25:20','seguimiento',NULL,'Ese es un caso ideal. Arthur puede atender 24/7 y dejar al equipo humano solo las oportunidades listas para seguimiento.','Arthur','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(5,17,'2026-05-24 22:25:20','seguimiento',NULL,'Que datos puede pedirle al cliente antes de pasarlo a ventas?','Rafael Bonilla','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(6,17,'2026-05-24 22:25:20','seguimiento',NULL,'Puede pedir nombre, necesidad principal, presupuesto aproximado, urgencia y canal preferido de contacto.','Arthur','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(7,17,'2026-05-24 22:25:20','seguimiento',NULL,'Me interesa verlo con ejemplos reales de mi negocio.','Rafael Bonilla','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(8,17,'2026-05-24 22:25:20','seguimiento',NULL,'Podemos preparar una demo con tus preguntas frecuentes y simular conversaciones completas.','Arthur','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(9,17,'2026-05-24 22:25:20','cierre',NULL,'La demo podria ser esta semana?','Rafael Bonilla','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(10,17,'2026-05-24 22:25:20','cierre',NULL,'Si, puedo dejar registrada la solicitud para que el equipo te proponga horarios disponibles.','Arthur','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(11,18,'2026-05-24 22:25:20','nueva_conversacion',NULL,'Buenas Arthur, vengo de un formulario y quiero conocer el precio del servicio.','Fernanda Lopez','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(12,18,'2026-05-24 22:25:20','seguimiento',NULL,'Con gusto. El precio depende del volumen de conversaciones, canales conectados y nivel de automatizacion.','Arthur','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(13,18,'2026-05-24 22:25:20','seguimiento',NULL,'Tenemos unas 300 conversaciones al mes y queremos iniciar con WhatsApp.','Fernanda Lopez','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(14,18,'2026-05-24 22:25:20','seguimiento',NULL,'Con ese volumen se puede plantear un paquete inicial enfocado en respuesta automatica y seguimiento comercial.','Arthur','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(15,18,'2026-05-24 22:25:20','seguimiento',NULL,'Tambien necesitamos que se asignen estados al lead.','Fernanda Lopez','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(16,18,'2026-05-24 22:25:20','seguimiento',NULL,'Arthur puede clasificar cada lead como frio, tibio, caliente o cita segun su intencion.','Arthur','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(17,18,'2026-05-24 22:25:20','seguimiento',NULL,'Eso nos ayudaria mucho para priorizar llamadas.','Fernanda Lopez','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(18,18,'2026-05-24 22:25:20','seguimiento',NULL,'Exactamente. La idea es que el equipo vea primero los contactos con mayor probabilidad de cierre.','Arthur','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(19,18,'2026-05-24 22:25:20','cierre',NULL,'Puedes enviarme una propuesta?','Fernanda Lopez','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(20,18,'2026-05-24 22:25:20','cierre',NULL,'Puedo registrar la solicitud y pedir al equipo que te contacte con una propuesta ajustada a tu volumen.','Arthur','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(21,19,'2026-05-24 22:25:20','nueva_conversacion',NULL,'Hola Arthur, quiero saber si se puede integrar con mi base de clientes actual.','Adrian Campos','2026-05-24 22:25:20');
INSERT INTO interacciones VALUES(22,19,'2026-05-24 22:25:21','seguimiento',NULL,'Hola. Si tu base puede exportarse o conectarse por API, podemos revisar una importacion inicial.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(23,19,'2026-05-24 22:25:21','seguimiento',NULL,'La tenemos en hojas de calculo y tambien en un CRM sencillo.','Adrian Campos','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(24,19,'2026-05-24 22:25:21','seguimiento',NULL,'Perfecto. Podemos partir de un archivo estructurado y luego evaluar una integracion mas automatica.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(25,19,'2026-05-24 22:25:21','seguimiento',NULL,'Me preocupa duplicar contactos.','Adrian Campos','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(26,19,'2026-05-24 22:25:21','seguimiento',NULL,'Podemos usar telefono o correo como criterio para detectar duplicados antes de cargar la informacion.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(27,19,'2026-05-24 22:25:21','seguimiento',NULL,'Y se pueden guardar notas de cada conversacion?','Adrian Campos','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(28,19,'2026-05-24 22:25:21','seguimiento',NULL,'Si, cada interaccion puede quedar registrada en el historial del lead para que el equipo tenga contexto.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(29,19,'2026-05-24 22:25:21','cierre',NULL,'Eso es justo lo que buscamos.','Adrian Campos','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(30,19,'2026-05-24 22:25:21','cierre',NULL,'Entonces el siguiente paso seria revisar una muestra de datos y definir los campos importantes.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(31,20,'2026-05-24 22:25:21','nueva_conversacion',NULL,'Arthur, necesito automatizar respuestas para clientes que preguntan por disponibilidad.','Luciana Vega','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(32,20,'2026-05-24 22:25:21','seguimiento',NULL,'Claro. Arthur puede responder disponibilidad, recopilar datos y derivar casos que requieran confirmacion humana.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(33,20,'2026-05-24 22:25:21','seguimiento',NULL,'La disponibilidad cambia seguido, eso se puede controlar?','Luciana Vega','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(34,20,'2026-05-24 22:25:21','seguimiento',NULL,'Si existe una fuente actualizada, podemos conectarla o definir un flujo donde Arthur valide antes de confirmar.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(35,20,'2026-05-24 22:25:21','seguimiento',NULL,'No quiero que prometa algo que no existe.','Luciana Vega','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(36,20,'2026-05-24 22:25:21','seguimiento',NULL,'Correcto. Se pueden configurar respuestas prudentes y escalamiento cuando la informacion sea sensible.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(37,20,'2026-05-24 22:25:21','seguimiento',NULL,'Tambien quiero que pregunte por fecha deseada.','Luciana Vega','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(38,20,'2026-05-24 22:25:21','seguimiento',NULL,'Ese dato se puede incluir como pregunta obligatoria dentro del flujo de calificacion.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(39,20,'2026-05-24 22:25:21','cierre',NULL,'Muy bien, quiero avanzar con una revision tecnica.','Luciana Vega','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(40,20,'2026-05-24 22:25:21','cierre',NULL,'Queda registrado. El equipo puede revisar tu flujo y recomendar la mejor forma de conectarlo.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(41,21,'2026-05-24 22:25:21','nueva_conversacion',NULL,'Hola, soy nuevo usando soluciones de IA y quiero entender que hace Arthur.','Roberto Salas','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(42,21,'2026-05-24 22:25:21','seguimiento',NULL,'Hola, soy Arthur. Actuo como asistente conversacional para atender leads, responder preguntas y apoyar ventas.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(43,21,'2026-05-24 22:25:21','seguimiento',NULL,'Significa que reemplaza al vendedor?','Roberto Salas','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(44,21,'2026-05-24 22:25:21','seguimiento',NULL,'No necesariamente. Arthur cubre la primera atencion y ayuda a que el vendedor reciba leads mas ordenados.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(45,21,'2026-05-24 22:25:21','seguimiento',NULL,'Eso suena bien, porque mi equipo se satura con preguntas repetidas.','Roberto Salas','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(46,21,'2026-05-24 22:25:21','seguimiento',NULL,'Justo ahi aporta mucho: responde preguntas frecuentes, registra datos y mantiene el seguimiento activo.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(47,21,'2026-05-24 22:25:21','seguimiento',NULL,'Cuanto tiempo toma configurarlo?','Roberto Salas','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(48,21,'2026-05-24 22:25:21','seguimiento',NULL,'Depende del alcance, pero un primer flujo puede prepararse rapidamente si ya tenemos preguntas frecuentes.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(49,21,'2026-05-24 22:25:21','cierre',NULL,'Tenemos un documento con esas preguntas.','Roberto Salas','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(50,21,'2026-05-24 22:25:21','cierre',NULL,'Excelente. Con ese material se puede construir una primera version de respuestas para validar.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(51,2,'2026-05-24 22:25:21','nueva_conversacion',NULL,'Arthur, me interesa usar IA para recuperar leads que dejaron de responder.','Isabella Castro','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(52,2,'2026-05-24 22:25:21','seguimiento',NULL,'Podemos crear secuencias de seguimiento con mensajes naturales y horarios definidos.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(53,2,'2026-05-24 22:25:21','seguimiento',NULL,'No quiero que los mensajes se sientan insistentes.','Isabella Castro','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(54,2,'2026-05-24 22:25:21','seguimiento',NULL,'Se puede manejar un tono consultivo, breve y con opciones claras para que el lead decida.','Arthur','2026-05-24 22:25:21');
INSERT INTO interacciones VALUES(55,2,'2026-05-24 22:25:22','seguimiento',NULL,'Por ejemplo, que pregunte si aun le interesa o si prefiere otra fecha.','Isabella Castro','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(56,2,'2026-05-24 22:25:22','seguimiento',NULL,'Exacto. Arthur puede ofrecer alternativas y actualizar el estado segun la respuesta.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(57,2,'2026-05-24 22:25:22','seguimiento',NULL,'Tambien deberia detenerse si el lead no quiere mas mensajes.','Isabella Castro','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(58,2,'2026-05-24 22:25:22','seguimiento',NULL,'Si. Se puede registrar la preferencia y evitar nuevos seguimientos para ese contacto.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(59,2,'2026-05-24 22:25:22','cierre',NULL,'Eso me da confianza.','Isabella Castro','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(60,2,'2026-05-24 22:25:22','cierre',NULL,'La automatizacion debe ayudar sin incomodar, y ese control es parte del flujo.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(61,3,'2026-05-24 22:25:22','nueva_conversacion',NULL,'Buenas Arthur, quiero una cita con alguien de Bemantis.','Carlos Mendoza','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(62,3,'2026-05-24 22:25:22','seguimiento',NULL,'Con gusto. Puedo ayudarte a coordinar una cita. Que dia y horario te funciona mejor?','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(63,3,'2026-05-24 22:25:22','seguimiento',NULL,'Miercoles en la tarde o jueves en la manana.','Carlos Mendoza','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(64,3,'2026-05-24 22:25:22','seguimiento',NULL,'Perfecto. Voy a registrar esas opciones para que el equipo confirme disponibilidad.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(65,3,'2026-05-24 22:25:22','seguimiento',NULL,'La llamada seria para revisar WhatsApp y CRM.','Carlos Mendoza','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(66,3,'2026-05-24 22:25:22','seguimiento',NULL,'Anotado: integracion de WhatsApp y CRM como temas principales de la reunion.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(67,3,'2026-05-24 22:25:22','seguimiento',NULL,'Tambien quiero ver metricas de conversion.','Carlos Mendoza','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(68,3,'2026-05-24 22:25:22','seguimiento',NULL,'Arthur puede apoyar con trazabilidad de interacciones y estados para medir mejor el avance de cada lead.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(69,3,'2026-05-24 22:25:22','cierre',NULL,'Excelente, quedo atento a la confirmacion.','Carlos Mendoza','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(70,3,'2026-05-24 22:25:22','cierre',NULL,'Listo. La solicitud queda con prioridad de cita y el equipo te contactara para confirmar.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(71,4,'2026-05-24 22:25:22','nueva_conversacion',NULL,'Hola Arthur, mi negocio recibe leads desde Instagram y WhatsApp.','Ana Lucia Morales','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(72,4,'2026-05-24 22:25:22','seguimiento',NULL,'Podemos revisar ambos canales y definir donde conviene iniciar la automatizacion.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(73,4,'2026-05-24 22:25:22','seguimiento',NULL,'WhatsApp es el mas importante por ahora.','Ana Lucia Morales','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(74,4,'2026-05-24 22:25:22','seguimiento',NULL,'Entonces podemos empezar por WhatsApp y dejar la estructura preparada para otros canales luego.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(75,4,'2026-05-24 22:25:22','seguimiento',NULL,'Necesito que Arthur entienda cuando una persona esta lista para comprar.','Ana Lucia Morales','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(76,4,'2026-05-24 22:25:22','seguimiento',NULL,'Podemos definir senales como presupuesto, urgencia, necesidad concreta y solicitud de cita.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(77,4,'2026-05-24 22:25:22','seguimiento',NULL,'Y si solo esta preguntando precios?','Ana Lucia Morales','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(78,4,'2026-05-24 22:25:22','seguimiento',NULL,'Arthur puede responder informacion inicial y seguir calificando sin presionar el cierre.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(79,4,'2026-05-24 22:25:22','cierre',NULL,'Ese tono me interesa.','Ana Lucia Morales','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(80,4,'2026-05-24 22:25:22','cierre',NULL,'Lo podemos configurar con lenguaje claro, cercano y alineado a tu marca.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(81,5,'2026-05-24 22:25:22','nueva_conversacion',NULL,'Arthur, quiero saber si puedo ver todo el historial de mensajes por lead.','Pablo Cordero','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(82,5,'2026-05-24 22:25:22','seguimiento',NULL,'Si. Cada interaccion queda asociada al lead para consultar el hilo completo cuando lo necesites.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(83,5,'2026-05-24 22:25:22','seguimiento',NULL,'Eso incluye mensajes del cliente y respuestas de Arthur?','Pablo Cordero','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(84,5,'2026-05-24 22:25:22','seguimiento',NULL,'Correcto. El historial puede mostrar ambas partes para entender el contexto de la conversacion.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(85,5,'2026-05-24 22:25:22','seguimiento',NULL,'Me sirve porque varios agentes atienden el mismo cliente.','Pablo Cordero','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(86,5,'2026-05-24 22:25:22','seguimiento',NULL,'Con el historial centralizado, cualquier agente puede retomar sin pedir la misma informacion.','Arthur','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(87,5,'2026-05-24 22:25:22','seguimiento',NULL,'Tambien queremos etiquetar oportunidades calientes.','Pablo Cordero','2026-05-24 22:25:22');
INSERT INTO interacciones VALUES(88,5,'2026-05-24 22:25:23','seguimiento',NULL,'Arthur puede actualizar estados y resaltar leads con senales de compra o solicitud de cita.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(89,5,'2026-05-24 22:25:23','cierre',NULL,'Perfecto, eso era lo que necesitaba confirmar.','Pablo Cordero','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(90,5,'2026-05-24 22:25:23','cierre',NULL,'Queda anotado como prioridad: historial completo y clasificacion de oportunidades.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(91,6,'2026-05-24 22:25:23','nueva_conversacion',NULL,'Hola Arthur, estoy evaluando contratar IA pero tengo dudas de seguridad.','Maria Jose Aguilar','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(92,6,'2026-05-24 22:25:23','seguimiento',NULL,'Es normal. Podemos revisar permisos, datos tratados y reglas para proteger informacion sensible.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(93,6,'2026-05-24 22:25:23','seguimiento',NULL,'No quiero que cualquier persona vea datos de clientes.','Maria Jose Aguilar','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(94,6,'2026-05-24 22:25:23','seguimiento',NULL,'Se pueden definir accesos por usuario y limitar la informacion visible segun el rol.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(95,6,'2026-05-24 22:25:23','seguimiento',NULL,'Y que pasa si Arthur no sabe responder?','Maria Jose Aguilar','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(96,6,'2026-05-24 22:25:23','seguimiento',NULL,'Puede reconocer limites, pedir mas contexto o escalar la conversacion a una persona del equipo.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(97,6,'2026-05-24 22:25:23','seguimiento',NULL,'Eso es importante para no dar respuestas incorrectas.','Maria Jose Aguilar','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(98,6,'2026-05-24 22:25:23','seguimiento',NULL,'Exacto. La automatizacion debe operar con reglas claras y escalamiento cuando hay incertidumbre.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(99,6,'2026-05-24 22:25:23','cierre',NULL,'Me gustaria hablar con alguien tecnico.','Maria Jose Aguilar','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(100,6,'2026-05-24 22:25:23','cierre',NULL,'Registro la solicitud para una revision tecnica enfocada en seguridad, permisos y manejo de datos.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(101,7,'2026-05-24 22:25:23','nueva_conversacion',NULL,'Hola Arthur, me interesa saber como Bemantis puede ayudarme con los leads que llegan por WhatsApp.','Esteban Arias','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(102,7,'2026-05-24 22:25:23','seguimiento',NULL,'Hola, soy Arthur. Puedo responder consultas iniciales, capturar datos clave y registrar cada avance del lead.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(103,7,'2026-05-24 22:25:23','seguimiento',NULL,'Perfecto, ahora mismo perdemos oportunidades porque respondemos tarde en las noches.','Esteban Arias','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(104,7,'2026-05-24 22:25:23','seguimiento',NULL,'Ese es un caso ideal. Arthur puede atender 24/7 y dejar al equipo humano solo las oportunidades listas para seguimiento.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(105,7,'2026-05-24 22:25:23','seguimiento',NULL,'Que datos puede pedirle al cliente antes de pasarlo a ventas?','Esteban Arias','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(106,7,'2026-05-24 22:25:23','seguimiento',NULL,'Puede pedir nombre, necesidad principal, presupuesto aproximado, urgencia y canal preferido de contacto.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(107,7,'2026-05-24 22:25:23','seguimiento',NULL,'Me interesa verlo con ejemplos reales de mi negocio.','Esteban Arias','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(108,7,'2026-05-24 22:25:23','seguimiento',NULL,'Podemos preparar una demo con tus preguntas frecuentes y simular conversaciones completas.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(109,7,'2026-05-24 22:25:23','cierre',NULL,'La demo podria ser esta semana?','Esteban Arias','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(110,7,'2026-05-24 22:25:23','cierre',NULL,'Si, puedo dejar registrada la solicitud para que el equipo te proponga horarios disponibles.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(111,8,'2026-05-24 22:25:23','nueva_conversacion',NULL,'Buenas Arthur, vengo de un formulario y quiero conocer el precio del servicio.','Valentina Gomez','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(112,8,'2026-05-24 22:25:23','seguimiento',NULL,'Con gusto. El precio depende del volumen de conversaciones, canales conectados y nivel de automatizacion.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(113,8,'2026-05-24 22:25:23','seguimiento',NULL,'Tenemos unas 300 conversaciones al mes y queremos iniciar con WhatsApp.','Valentina Gomez','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(114,8,'2026-05-24 22:25:23','seguimiento',NULL,'Con ese volumen se puede plantear un paquete inicial enfocado en respuesta automatica y seguimiento comercial.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(115,8,'2026-05-24 22:25:23','seguimiento',NULL,'Tambien necesitamos que se asignen estados al lead.','Valentina Gomez','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(116,8,'2026-05-24 22:25:23','seguimiento',NULL,'Arthur puede clasificar cada lead como frio, tibio, caliente o cita segun su intencion.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(117,8,'2026-05-24 22:25:23','seguimiento',NULL,'Eso nos ayudaria mucho para priorizar llamadas.','Valentina Gomez','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(118,8,'2026-05-24 22:25:23','seguimiento',NULL,'Exactamente. La idea es que el equipo vea primero los contactos con mayor probabilidad de cierre.','Arthur','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(119,8,'2026-05-24 22:25:23','cierre',NULL,'Puedes enviarme una propuesta?','Valentina Gomez','2026-05-24 22:25:23');
INSERT INTO interacciones VALUES(120,8,'2026-05-24 22:25:24','cierre',NULL,'Puedo registrar la solicitud y pedir al equipo que te contacte con una propuesta ajustada a tu volumen.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(121,9,'2026-05-24 22:25:24','nueva_conversacion',NULL,'Hola Arthur, quiero saber si se puede integrar con mi base de clientes actual.','Luis Fernando Rivas','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(122,9,'2026-05-24 22:25:24','seguimiento',NULL,'Hola. Si tu base puede exportarse o conectarse por API, podemos revisar una importacion inicial.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(123,9,'2026-05-24 22:25:24','seguimiento',NULL,'La tenemos en hojas de calculo y tambien en un CRM sencillo.','Luis Fernando Rivas','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(124,9,'2026-05-24 22:25:24','seguimiento',NULL,'Perfecto. Podemos partir de un archivo estructurado y luego evaluar una integracion mas automatica.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(125,9,'2026-05-24 22:25:24','seguimiento',NULL,'Me preocupa duplicar contactos.','Luis Fernando Rivas','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(126,9,'2026-05-24 22:25:24','seguimiento',NULL,'Podemos usar telefono o correo como criterio para detectar duplicados antes de cargar la informacion.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(127,9,'2026-05-24 22:25:24','seguimiento',NULL,'Y se pueden guardar notas de cada conversacion?','Luis Fernando Rivas','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(128,9,'2026-05-24 22:25:24','seguimiento',NULL,'Si, cada interaccion puede quedar registrada en el historial del lead para que el equipo tenga contexto.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(129,9,'2026-05-24 22:25:24','cierre',NULL,'Eso es justo lo que buscamos.','Luis Fernando Rivas','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(130,9,'2026-05-24 22:25:24','cierre',NULL,'Entonces el siguiente paso seria revisar una muestra de datos y definir los campos importantes.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(131,10,'2026-05-24 22:25:24','nueva_conversacion',NULL,'Arthur, necesito automatizar respuestas para clientes que preguntan por disponibilidad.','Daniela Pineda','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(132,10,'2026-05-24 22:25:24','seguimiento',NULL,'Claro. Arthur puede responder disponibilidad, recopilar datos y derivar casos que requieran confirmacion humana.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(133,10,'2026-05-24 22:25:24','seguimiento',NULL,'La disponibilidad cambia seguido, eso se puede controlar?','Daniela Pineda','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(134,10,'2026-05-24 22:25:24','seguimiento',NULL,'Si existe una fuente actualizada, podemos conectarla o definir un flujo donde Arthur valide antes de confirmar.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(135,10,'2026-05-24 22:25:24','seguimiento',NULL,'No quiero que prometa algo que no existe.','Daniela Pineda','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(136,10,'2026-05-24 22:25:24','seguimiento',NULL,'Correcto. Se pueden configurar respuestas prudentes y escalamiento cuando la informacion sea sensible.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(137,10,'2026-05-24 22:25:24','seguimiento',NULL,'Tambien quiero que pregunte por fecha deseada.','Daniela Pineda','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(138,10,'2026-05-24 22:25:24','seguimiento',NULL,'Ese dato se puede incluir como pregunta obligatoria dentro del flujo de calificacion.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(139,10,'2026-05-24 22:25:24','cierre',NULL,'Muy bien, quiero avanzar con una revision tecnica.','Daniela Pineda','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(140,10,'2026-05-24 22:25:24','cierre',NULL,'Queda registrado. El equipo puede revisar tu flujo y recomendar la mejor forma de conectarlo.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(141,11,'2026-05-24 22:25:24','nueva_conversacion',NULL,'Hola, soy nuevo usando soluciones de IA y quiero entender que hace Arthur.','Nicolas Soto','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(142,11,'2026-05-24 22:25:24','seguimiento',NULL,'Hola, soy Arthur. Actuo como asistente conversacional para atender leads, responder preguntas y apoyar ventas.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(143,11,'2026-05-24 22:25:24','seguimiento',NULL,'Significa que reemplaza al vendedor?','Nicolas Soto','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(144,11,'2026-05-24 22:25:24','seguimiento',NULL,'No necesariamente. Arthur cubre la primera atencion y ayuda a que el vendedor reciba leads mas ordenados.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(145,11,'2026-05-24 22:25:24','seguimiento',NULL,'Eso suena bien, porque mi equipo se satura con preguntas repetidas.','Nicolas Soto','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(146,11,'2026-05-24 22:25:24','seguimiento',NULL,'Justo ahi aporta mucho: responde preguntas frecuentes, registra datos y mantiene el seguimiento activo.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(147,11,'2026-05-24 22:25:24','seguimiento',NULL,'Cuanto tiempo toma configurarlo?','Nicolas Soto','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(148,11,'2026-05-24 22:25:24','seguimiento',NULL,'Depende del alcance, pero un primer flujo puede prepararse rapidamente si ya tenemos preguntas frecuentes.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(149,11,'2026-05-24 22:25:24','cierre',NULL,'Tenemos un documento con esas preguntas.','Nicolas Soto','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(150,11,'2026-05-24 22:25:24','cierre',NULL,'Excelente. Con ese material se puede construir una primera version de respuestas para validar.','Arthur','2026-05-24 22:25:24');
INSERT INTO interacciones VALUES(151,12,'2026-05-24 22:25:25','nueva_conversacion',NULL,'Arthur, me interesa usar IA para recuperar leads que dejaron de responder.','Paula Villalobos','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(152,12,'2026-05-24 22:25:25','seguimiento',NULL,'Podemos crear secuencias de seguimiento con mensajes naturales y horarios definidos.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(153,12,'2026-05-24 22:25:25','seguimiento',NULL,'No quiero que los mensajes se sientan insistentes.','Paula Villalobos','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(154,12,'2026-05-24 22:25:25','seguimiento',NULL,'Se puede manejar un tono consultivo, breve y con opciones claras para que el lead decida.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(155,12,'2026-05-24 22:25:25','seguimiento',NULL,'Por ejemplo, que pregunte si aun le interesa o si prefiere otra fecha.','Paula Villalobos','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(156,12,'2026-05-24 22:25:25','seguimiento',NULL,'Exacto. Arthur puede ofrecer alternativas y actualizar el estado segun la respuesta.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(157,12,'2026-05-24 22:25:25','seguimiento',NULL,'Tambien deberia detenerse si el lead no quiere mas mensajes.','Paula Villalobos','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(158,12,'2026-05-24 22:25:25','seguimiento',NULL,'Si. Se puede registrar la preferencia y evitar nuevos seguimientos para ese contacto.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(159,12,'2026-05-24 22:25:25','cierre',NULL,'Eso me da confianza.','Paula Villalobos','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(160,12,'2026-05-24 22:25:25','cierre',NULL,'La automatizacion debe ayudar sin incomodar, y ese control es parte del flujo.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(161,13,'2026-05-24 22:25:25','nueva_conversacion',NULL,'Buenas Arthur, quiero una cita con alguien de Bemantis.','Jorge Alvarado','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(162,13,'2026-05-24 22:25:25','seguimiento',NULL,'Con gusto. Puedo ayudarte a coordinar una cita. Que dia y horario te funciona mejor?','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(163,13,'2026-05-24 22:25:25','seguimiento',NULL,'Miercoles en la tarde o jueves en la manana.','Jorge Alvarado','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(164,13,'2026-05-24 22:25:25','seguimiento',NULL,'Perfecto. Voy a registrar esas opciones para que el equipo confirme disponibilidad.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(165,13,'2026-05-24 22:25:25','seguimiento',NULL,'La llamada seria para revisar WhatsApp y CRM.','Jorge Alvarado','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(166,13,'2026-05-24 22:25:25','seguimiento',NULL,'Anotado: integracion de WhatsApp y CRM como temas principales de la reunion.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(167,13,'2026-05-24 22:25:25','seguimiento',NULL,'Tambien quiero ver metricas de conversion.','Jorge Alvarado','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(168,13,'2026-05-24 22:25:25','seguimiento',NULL,'Arthur puede apoyar con trazabilidad de interacciones y estados para medir mejor el avance de cada lead.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(169,13,'2026-05-24 22:25:25','cierre',NULL,'Excelente, quedo atento a la confirmacion.','Jorge Alvarado','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(170,13,'2026-05-24 22:25:25','cierre',NULL,'Listo. La solicitud queda con prioridad de cita y el equipo te contactara para confirmar.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(171,14,'2026-05-24 22:25:25','nueva_conversacion',NULL,'Hola Arthur, mi negocio recibe leads desde Instagram y WhatsApp.','Samantha Chaves','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(172,14,'2026-05-24 22:25:25','seguimiento',NULL,'Podemos revisar ambos canales y definir donde conviene iniciar la automatizacion.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(173,14,'2026-05-24 22:25:25','seguimiento',NULL,'WhatsApp es el mas importante por ahora.','Samantha Chaves','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(174,14,'2026-05-24 22:25:25','seguimiento',NULL,'Entonces podemos empezar por WhatsApp y dejar la estructura preparada para otros canales luego.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(175,14,'2026-05-24 22:25:25','seguimiento',NULL,'Necesito que Arthur entienda cuando una persona esta lista para comprar.','Samantha Chaves','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(176,14,'2026-05-24 22:25:25','seguimiento',NULL,'Podemos definir senales como presupuesto, urgencia, necesidad concreta y solicitud de cita.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(177,14,'2026-05-24 22:25:25','seguimiento',NULL,'Y si solo esta preguntando precios?','Samantha Chaves','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(178,14,'2026-05-24 22:25:25','seguimiento',NULL,'Arthur puede responder informacion inicial y seguir calificando sin presionar el cierre.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(179,14,'2026-05-24 22:25:25','cierre',NULL,'Ese tono me interesa.','Samantha Chaves','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(180,14,'2026-05-24 22:25:25','cierre',NULL,'Lo podemos configurar con lenguaje claro, cercano y alineado a tu marca.','Arthur','2026-05-24 22:25:25');
INSERT INTO interacciones VALUES(181,15,'2026-05-24 22:25:26','nueva_conversacion',NULL,'Arthur, quiero saber si puedo ver todo el historial de mensajes por lead.','Miguel Angel Torres','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(182,15,'2026-05-24 22:25:26','seguimiento',NULL,'Si. Cada interaccion queda asociada al lead para consultar el hilo completo cuando lo necesites.','Arthur','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(183,15,'2026-05-24 22:25:26','seguimiento',NULL,'Eso incluye mensajes del cliente y respuestas de Arthur?','Miguel Angel Torres','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(184,15,'2026-05-24 22:25:26','seguimiento',NULL,'Correcto. El historial puede mostrar ambas partes para entender el contexto de la conversacion.','Arthur','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(185,15,'2026-05-24 22:25:26','seguimiento',NULL,'Me sirve porque varios agentes atienden el mismo cliente.','Miguel Angel Torres','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(186,15,'2026-05-24 22:25:26','seguimiento',NULL,'Con el historial centralizado, cualquier agente puede retomar sin pedir la misma informacion.','Arthur','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(187,15,'2026-05-24 22:25:26','seguimiento',NULL,'Tambien queremos etiquetar oportunidades calientes.','Miguel Angel Torres','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(188,15,'2026-05-24 22:25:26','seguimiento',NULL,'Arthur puede actualizar estados y resaltar leads con senales de compra o solicitud de cita.','Arthur','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(189,15,'2026-05-24 22:25:26','cierre',NULL,'Perfecto, eso era lo que necesitaba confirmar.','Miguel Angel Torres','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(190,15,'2026-05-24 22:25:26','cierre',NULL,'Queda anotado como prioridad: historial completo y clasificacion de oportunidades.','Arthur','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(191,16,'2026-05-24 22:25:26','nueva_conversacion',NULL,'Hola Arthur, estoy evaluando contratar IA pero tengo dudas de seguridad.','Carolina Urena','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(192,16,'2026-05-24 22:25:26','seguimiento',NULL,'Es normal. Podemos revisar permisos, datos tratados y reglas para proteger informacion sensible.','Arthur','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(193,16,'2026-05-24 22:25:26','seguimiento',NULL,'No quiero que cualquier persona vea datos de clientes.','Carolina Urena','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(194,16,'2026-05-24 22:25:26','seguimiento',NULL,'Se pueden definir accesos por usuario y limitar la informacion visible segun el rol.','Arthur','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(195,16,'2026-05-24 22:25:26','seguimiento',NULL,'Y que pasa si Arthur no sabe responder?','Carolina Urena','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(196,16,'2026-05-24 22:25:26','seguimiento',NULL,'Puede reconocer limites, pedir mas contexto o escalar la conversacion a una persona del equipo.','Arthur','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(197,16,'2026-05-24 22:25:26','seguimiento',NULL,'Eso es importante para no dar respuestas incorrectas.','Carolina Urena','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(198,16,'2026-05-24 22:25:26','seguimiento',NULL,'Exacto. La automatizacion debe operar con reglas claras y escalamiento cuando hay incertidumbre.','Arthur','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(199,16,'2026-05-24 22:25:26','cierre',NULL,'Me gustaria hablar con alguien tecnico.','Carolina Urena','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(200,16,'2026-05-24 22:25:26','cierre',NULL,'Registro la solicitud para una revision tecnica enfocada en seguridad, permisos y manejo de datos.','Arthur','2026-05-24 22:25:26');
INSERT INTO interacciones VALUES(201,1,'2026-05-24 22:40:34','nueva_conversacion',NULL,'Hola Arthur, vi la informacion de Bemantis y quiero saber como me puede ayudar con mis leads.','Juan Perez','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(202,1,'2026-05-24 22:40:34','seguimiento',NULL,'Hola Juan, soy Arthur. Puedo ayudarte a responder consultas, calificar leads y registrar cada avance en el historial.','Arthur','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(203,1,'2026-05-24 22:40:34','seguimiento',NULL,'Actualmente recibo muchos mensajes por WhatsApp y no siempre puedo responder rapido.','Juan Perez','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(204,1,'2026-05-24 22:40:34','seguimiento',NULL,'Ese es un buen caso para automatizar. Puedo atender el primer contacto, pedir datos clave y avisar cuando el lead esta listo para seguimiento.','Arthur','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(205,1,'2026-05-24 22:40:34','seguimiento',NULL,'Me interesa que el cliente sienta una conversacion natural, no una respuesta generica.','Juan Perez','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(206,1,'2026-05-24 22:40:34','seguimiento',NULL,'Podemos configurar el tono, las preguntas frecuentes y las rutas de respuesta para que la conversacion se sienta alineada a tu negocio.','Arthur','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(207,1,'2026-05-24 22:40:34','seguimiento',NULL,'Tambien necesito saber si el sistema puede distinguir entre alguien curioso y alguien listo para comprar.','Juan Perez','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(208,1,'2026-05-24 22:40:34','seguimiento',NULL,'Si. Puedo identificar senales como urgencia, presupuesto, necesidad concreta y solicitud de cita para marcar oportunidades mas calientes.','Arthur','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(209,1,'2026-05-24 22:40:34','seguimiento',NULL,'Eso ayudaria mucho, porque mi equipo pierde tiempo revisando mensajes sin prioridad.','Juan Perez','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(210,1,'2026-05-24 22:40:34','seguimiento',NULL,'La idea es ordenar el trabajo comercial: leads frios quedan en seguimiento y los calientes pasan primero al equipo.','Arthur','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(211,1,'2026-05-24 22:40:34','seguimiento',NULL,'Que datos le pedirias al cliente al inicio?','Juan Perez','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(212,1,'2026-05-24 22:40:34','seguimiento',NULL,'Normalmente pediria nombre, telefono, necesidad principal, fecha estimada, presupuesto aproximado y canal preferido de contacto.','Arthur','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(213,1,'2026-05-24 22:40:34','seguimiento',NULL,'Podria funcionar tambien fuera de horario?','Juan Perez','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(214,1,'2026-05-24 22:40:34','seguimiento',NULL,'Si, puedo responder 24/7 y dejar las conversaciones registradas para que tu equipo las revise al iniciar el dia.','Arthur','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(215,1,'2026-05-24 22:40:34','seguimiento',NULL,'Me preocupa que Arthur responda algo incorrecto si no tiene suficiente informacion.','Juan Perez','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(216,1,'2026-05-24 22:40:34','seguimiento',NULL,'En esos casos puedo pedir mas contexto o escalar la conversacion a una persona del equipo antes de confirmar algo sensible.','Arthur','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(217,1,'2026-05-24 22:40:34','seguimiento',NULL,'Perfecto. Me gustaria ver una demo con ejemplos parecidos a mis clientes.','Juan Perez','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(218,1,'2026-05-24 22:40:34','seguimiento',NULL,'Con gusto. Podemos preparar una demo usando preguntas reales de tu negocio y simular el flujo completo del lead.','Arthur','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(219,1,'2026-05-24 22:40:34','cierre',NULL,'Entonces agendemos una llamada esta semana para revisar el alcance.','Juan Perez','2026-05-24 22:40:34');
INSERT INTO interacciones VALUES(220,1,'2026-05-24 22:40:34','cierre',NULL,'Listo Juan. Registro el interes para una llamada esta semana y marco este hilo como oportunidad lista para cita.','Arthur','2026-05-24 22:40:34');
CREATE INDEX ix_leads_telefono ON leads (telefono);
CREATE INDEX ix_leads_id ON leads (id);
CREATE INDEX ix_usuarios_id ON usuarios (id);
CREATE UNIQUE INDEX ix_usuarios_correo ON usuarios (correo);
CREATE INDEX ix_interacciones_lead_id ON interacciones (lead_id);
CREATE INDEX ix_interacciones_id ON interacciones (id);
COMMIT;
