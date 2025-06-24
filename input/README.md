# Sobre el manejo de fuentes de datos

En este directorio se deben incluir manualmente los datasets a utilizar en este proyecto.

### Estructura del directorio

```
...
  └── input/                             # Fuentes del proyecto (descarga manual)
  |   └── origen_fuente/                 # Nombre de la organización y/o productor de los datos (e.g. DANE)
  |       └── titulo_dataset/            # Nombre del conjunto de datos
  |           └── formato_fuente/        # Formato de la fuente de datos (e.g. CSV, DTA, parquet, etc.)
  |               ├── fichero_1.format
  |               ├── fichero_2.format
  |               └── fichero_n.format   # n = cantidad de ficheros asociados

```

### Ejemplo usando el CNPV2018 (DANE)

```
...
  └── DANE/
  |   └── CNPV2018_11/                          # Datasets del CNPV2018 (DANE)
  |       └── CSV/
  |           └── CNPV2018_MGN_A2_11.CSV
  |               ├── CNPV2018_1VIV_A2_11.CSV
  |               ├── CNPV2018_2HOG_A2_11.CSV
  |               ├── CNPV2018_3FALL_A2_11.CSV
  |               └── CNPV2018_5PER_A2_11.CSV

```
