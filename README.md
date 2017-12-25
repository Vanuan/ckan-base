# CKAN base

This is a base CKAN image

## Usage

1. Clone this repo
2. Copy config folder (ckan.ini file)
3. Create data/pgdata folder (postgres database)
4. Copy solr folder (solr schema and data), chown it to 8983:8983 or use o+w
5. Create docker-compose.yml file:

```
version: '2'
services:
  ckan:
    image: vanuan/ckan-base
    environment:
      - CKAN_SQLALCHEMY_URL=postgres://postgres:pass@postgres/ckan
      - CKAN_CONFIG=/etc/ckan
      - CKAN_SOLR_URL=http://solr:8983/solr/ckancore
      - CKAN_REDIS_URL=redis://redis:6379/1
      - CKAN_DATAPUSHER_URL=http://datapusher:8800
      - CKAN_SITE_URL=http://localhost:5000
    ports:
      - 5000:5000
    volumes:
      - ./config/ckan.ini:/etc/ckan/ckan.ini
    depends_on:
      - postgres
      - solr
      - redis
      - datapusher
  postgres:
    image: postgres:9.6-alpine
    environment:
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=ckan
      - PGDATA=/data
    volumes:
      - ./data/pgdata:/data
  solr:
    image: solr:6.6-alpine
    volumes:
      - ./solr:/opt/solr/server/solr/ckancore/
  datapusher:
    image: vanuan/ckan-datapusher
  redis:
    image: redis:4-alpine
```

6. Run docker-compose up (or docker deploy if using swarm mode)
7. Open localhost:5000
8. Register a new user
9. Add admin privilegs: paster --plugin=ckan sysadmin add USERNAME -c /etc/ckan/ckan.ini


## Customization

To customize it you need to create and install a CKAN extension.

Examples:

* https://github.com/datagovau/ckanext-datagovau
* https://github.com/okfn/ckanext-pdeu
* https://github.com/datagovuk/ckanext-dgu
* https://github.com/GSA/ckanext-geodatagov
* https://github.com/open-data/ckanext-canada
