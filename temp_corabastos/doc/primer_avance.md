# La producción del espacio urbano en la UPZ Corabastos: análisis exploratorio de fuentes censales

<div align="right">

**Jorge Luis González–Castellanos**  
*Estudiante de sociología. Universidad Nacional de Colombia, Sede Bogotá*  

jlgonzalezca@unal.edu.co  

2025  

</div>


<div align="center">

___

**PRIMER AVANCE**  

**Asignatura:** [Análisis y procesamiento de datos para ciencias sociales en R](https://github.com/sebichas1015/curso_r_cs)  
</div>



## Introducción

La UPZ Corabastos, ubicada en la ciudad de Bogotá, alberga un nodo logístico de carácter critico para la República de Colombia, en ella se encuentra la segunda central abastos más grande de América, la Corporación de Abastos S.A (Corabastos).  Para que esto sea posible, miles de personas han construido su materialidad de manera continua desde hace más de 40 años; asimismo muchos de ellos han producido el espacio urbano circundante a la gran plaza, lugar que surge, principalmente, en torno a su economía. 

Esto implica el ensamblaje de una plétora de subredes y circuitos comerciales en la órbita de la principal central de abastos de la capital, produciendo así un espacio social diverso y constante re-configuración. Tanto como la materialidad que le sustenta, aunque negociada con las autoridades gubernamentales, es mayormente un producto de la auto-construcción.  Una consecuencia de este intrincado proceso relacional se refleja en la producción de una experiencia urbana intensa y característica, que a su vez transforma la espacialidad de sus barrios manera permanente y dando sustento a la existencia de su lugar. 

De ahí la importancia que encuentro en caracterizar a sus pobladores. Para ello, es fundamental construir insumos que permitan un enfoque de investigación amplio y plural, que implique distintos abordajes metodológicos, técnicos, y orientados a construir una representación detallada del tejido urbano, especialmente de sus gentes. Con este breve proceso de investigación se busca construir un producto orientado a complementar mi objeto de estudio. 

Las actuales herramientas computacionales disponibles hacen más posible que nunca su aplicación para la investigación social aplicada, con estas realizaré un breve perfil demográfico del sector usando como base el Censo Nacional de Población y Vivienda 2018 del Departamento Administrativo Nacional de Estadística - DANE. Queda abierta la posibilidad de usar otras fuentes censales para construir una representación más longitudinal de la población residente en la zona de interés.

Dicho producto servirá como insumo para una investigación más amplia que actualmente llevo a cabo, y que implica un enfoque metodológico más amplio que el aquí planteado. 

## Justificación

Considero que es muy importante aplicar una metodología cuantitativa para crear este insumo, ya que si bien, algunos trabajos previos en la zona se nutren de estadísticas oficiales –entre otras–, no pude encontrar un estudio sociológico del sector que implemente directamente técnicas de análisis de datos cuantitativos, esto me plantea la necesidad de explorar estas fuentes de datos de manera más específica (e.g. microdatos) para responder a mis preguntas de investigación. Además, creo que es necesario para mi actual proceso de formación profesional contar con un mínimo de habilidades técnicas que me permitan entender de manera detallada y plural la realidad social, los métodos cuantitativos y computacionales brindan una herramienta indispensable para ello. 

En ese sentido, creo que para construir el objeto de estudio puedo valerme del poder que ofrecen las herramientas informáticas disponibles, y que considero fundamentales para hacer investigación, al menos, en los albores del siglo XXI. El lenguaje de programación estadística R y su amplio ecosistema de software es una de ellas, por tanto, considero que es la herramienta adecuada para realizar esta primera etapa de extracción y análisis de datos cuantitativos.

## Pregunta de investigación

De muchas preguntas surgidas, la más pertinente para este proyecto de investigación –y aprendizaje– es quizás la siguiente: ***¿cómo se compone la población de la UPZ 80 en un sentido demográfico, al menos, para el corte del año 2018?*** 

## Hipótesis

En un sentido más *heurístico* que estrictamente *nomotético*, quisiera plantear una hipótesis abierta para este ejercicio. Dicho así, planteo que, posiblemente, los habitantes la UPZ 80 son familias de origen rural, de escasos recursos y mayormente jóvenes, aunque dicha población se encuentra en un continuo proceso de envejecimiento, además de una tendencia decreciente de la natalidad. A pesar de ello, las tasas de escolaridad han aumentado en las generaciones más jóvenes de la UPZ, indicando un lento aunque continuo proceso de movilidad social *relativamente* ascendente. 

Es posible que para corroborar este planteamiento deba valerme de otras fuentes estadísticas, así como de un contraste con un ejercicio ampliado de investigación documental, y una exploración *in-situ*. Esto último se dejará para otro momento de la investigación, que no se contempla en este ejercicio de aprendizaje.

## Revisión de literatura

Para este apartado, sólo selecciono algunas fuentes consultadas previamente, las cuales considero como las más pertinentes para el caso.

***Trabajo y economía popular en Corabastos:*** El trabajo de Suárez Forero (2020) caracteriza a los trabajadores de la economía popular en Corabastos (bicitaxistas, vendedores ambulantes, recicladores), describiendo cómo la ocupación informal de la vía pública –producto de carencia de espacios formales– genera una materialidad precaria: puestos móviles, cobertizos improvisados y trazados de circulación peatonal definidos según la lógica del flujo de mercancías. Esta “infraestructura popular” es co-creada día a día entre los propios trabajadores y actitudes institucionales contradictorias de control y tolerancia, lo cual evidencia la coproducción socioespacial del sector, en tanto campo en disputa (Suárez Forero, 2020).

**Investigación participante, interaccionismo y micropoder:** Por su parte, Gil Torres (2021) a través de un enfoque _interaccionista_ inspirado en la escuela de Chicago de Irving Goffman, analiza y participa de las interacciones entre coteros (y _performando_ dicho rol) y otros trabajadores de la economía popular dentro de la territorialidad de Corabastos S.A. Sus observaciones de campo muestran que la tensión entre lo formal e informal se traduce en relaciones de poder y resistencia, fruto de alianzas de solidaridad y negociaciones diarias. Estas estructuras provisionales acaban adoptando una materialidad más duradera, configurando un espacio que resiste intentos de erradicación y redefine la experiencia de uso de Corabastos (Gil Torres, 2021).

Si bien, estos insumos son clave para caracterizar a los habitantes de la UPZ Corabastos, en tanto los actores de la economía popular no sólo habitan el espacio de manera itinerante, sino incluso, en gran parte son los residentes de los barrios que configuran el “*hinterland*” de principal central de abastos de Colombia, las estadísticas oficiales ofrecen una mirada complementaria del lugar que si bien, en el caso de Suárez (op. cit) usa de manera directa, su enfoque está orientado en el estudio de las prácticas económicas de dos sectores específicos de la economía popular la UPZ Corabastos, especialmente en la zona norte. Esto me lleva a considerar un uso más directo de los recursos oficiales, disponibles de manera abierta.

## Presentación del conjunto de datos

El Censo Nacional de Población y Vivienda 2018 (DANE) es uno, de varios conjuntos de datos abiertos, que permite la construcción de un insumo clave para una caracterización detallada del sector. Los microdatos disponibles desde los repositorios del Departamento Administrativo Nacional de Estadística cuentan con un nivel de detalle sobre la población colombiana, altos estándares de calidad y seguridad, así como un nivel de desagregación suficiente. considero que este conjunto de datos merece ser usado en la investigación social aplicada.

## Descripción del conjunto de datos

El conjunto de datos cuenta con información estadística segmentada en cinco categorías, para este breve ejercicio sólo usaré la tabla correspondiente a la categoría de personas.
De esta, por el momento sólo usaré algunas de sus variables, a saber.

| Código               | Etiqueta                                                                                     |
| -------------------- | -------------------------------------------------------------------------------------------- |
| P_SEXO_VS1           | Sexo                                                                                         |
| P_EDADR_VS1          | Edad en Grupos Quinquenales                                                                  |
| P_PARENTESCOR_VS1    | Relación de parentesco con el jefe(a) del hogar (recodificada)                               |
| PA1_GRP_ETNIC_VS1    | Reconocimiento étnico                                                                        |
| PA_HABLA_LENG_VS1    | Habla la lengua nativa de su pueblo                                                          |
| PA1_ENTIENDE_VS1     | Entiende la lengua nativa de su pueblo                                                       |
| PB_OTRAS_LENG_VS1    | Habla otra(s) lengua(s) nativa(s)                                                            |
| PA_LUG_NAC_VS1       | Lugar de nacimiento                                                                          |
| PA_VIVIA_5ANOS_VS1   | Lugar de residencia hace 5 años                                                              |
| PA_VIVIA_1ANO_VS1    | Lugar de residencia hace 12 meses                                                            |
| CONDICION_FISICA_VS1 | Alguna dificultad en su vida diaria                                                          |
| P_ALFABETA_VS1       | Sabe leer y escribir                                                                         |
| PA_ASISTENCIA_VS1    | Asistencia escolar (de forma presencial o virtual)                                           |
| P_NIVEL_ANOSR_VS1    | Nivel educativo más alto alcanzado y último año o grado aprobado en ese nivel (recodificado) |
| P_TRABAJO_VS1        | Que hizo durante la semana pasada                                                            |
| P_EST_CIVIL_VS1      | Estado civil                                                                                 |
| PA_HNV_VS1           | Ha tenido algún hijo(a) nacido vivo(a)                                                       |
| PA1_THNV_VS1         | Hijos(as) nacidos vivos: Total                                                               |
| PA2_HNVH_VS1         | Hijos(as) nacidos vivos: Hombres                                                             |
| PA3_HNVM_VS1         | Hijos(as) nacidos vivos: Mujeres                                                             |
| PA_HNVS_VS1          | Hijos(as) sobrevivientes                                                                     |
| PA1_THSV_VS1         | Hijos(as) sobrevivientes: Total                                                              |
| PA2_HSVH_VS1         | Hijos(as) sobrevivientes: Hombres                                                            |
| PA3_HSVM_VS1         | Hijos(as) sobrevivientes: Mujeres                                                            |

Para consultar información detallada sobre el diccionario, así como del conjunto de datos y la operación estadística en general, [pulse aquí.](https://microdatos.dane.gov.co/index.php/catalog/643/data-dictionary/F11?file_name=PERSONAS)

## Análisis inicial del conjunto de datos

Siguiendo las recomendaciones dadas en el curso, presento el código solicitado para este primer ejercicio exploratorio. 

Para ir al recurso [pulse aquí.](https://github.com/JlGonzalezK/UPZ_Corabastos/blob/main/R/primer_avance.R)

___

## Bibliografía

1. Departamento Administrativo Nacional de Estadística - DANE. (s/f). _Catálogo Central de Datos_. Recuperado el 20 de mayo de 2025, de [https://microdatos.dane.gov.co/index.php/catalog/central/about](https://microdatos.dane.gov.co/index.php/catalog/central/about)

2. Gil Torres, Á. D. (2021). _El teatro de lo marginal: Coteros y trabajadores informales semiestacionarios en la Corporación de Abastos de Bogotá_ [Trabajo de grado - Maestría, Universidad Nacional de Colombia]. [https://repositorio.unal.edu.co/handle/unal/80432](https://repositorio.unal.edu.co/handle/unal/80432)

3. Suárez, E. (2020). _Trabajadores de la economía popular en la avenida de Los Muiscas y barrios aledaños en UPZ Corabastos_. en RELET.
