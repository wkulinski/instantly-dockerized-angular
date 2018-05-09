## Development
This project contains bunch of helpful commands and tools to make development 
and deployment easier.

@TODO Describe all commands

#### Access nginx container shell
```
ins nginx
```
or use alias
```
ins server
```
This command is shortcut for
```
docker-compose exec nginx sh
```


#### Stop docker containers
```
ins stop
```

#### Reload docker containers
```
ins reload
```

#### Others
Calling **ins** with any argument(s) other than shown above is equal to calling
```
docker-compose exec [arguments]
```