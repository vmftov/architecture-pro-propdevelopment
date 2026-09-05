# Доступ от обычного фронтенда

```
winpty kubectl run test-frontend --labels="role=front-end" --rm -i -t --image=alpine -- sh
```

```
# ok:
wget -qO- --timeout=2 http://back-end-api-app

# timeout:
wget -qO- --timeout=2 http://admin-back-end-api-app
```

# Доступ от админского фронтенда

```
winpty kubectl run test-admin --labels="role=admin-front-end" --rm -i -t --image=alpine -- sh
```

```
# timeout:
wget -qO- --timeout=2 http://back-end-api-app

# ok:
wget -qO- --timeout=2 http://admin-back-end-api-app
```
