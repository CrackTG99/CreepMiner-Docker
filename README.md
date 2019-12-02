# CreepMiner-Docker
![](https://github.com/Creepsky/creepMiner) github build running in Ubuntu 16.04 

![](https://github.com/Creepsky/creepMiner/blob/1.7.19/resources/icon.png)

# Usage 
Compile your image with run.sh and start your container
```
docker create \
--name=CreepMiner \
-p 8124:8124 \
-p 9001:9001 \
-v </path/to/local/config/dir>:/config \
-v </path/to/plot_dir_02>:/plots \
-e AUTO_START=TRUE \
creepminer:CrackTG99    
```
By default, the miner uses a default setting if a new one is not indicated. 

The password and the default user of CreepMiner is ```admin admin```

It is recommended that you indicate your own configuration ```</path/to/local/config/dir>:/config```

The password and the default user of Supervisor is ```admin admin```

The Supervisor password can be modified in the ```resources/supervisorord.conf``` file

# Connection
| Interface  | URL  |
| -----------| ------------- |
| CreepMiner  | http://ip:8124  |
| Supervisor  | http://ip:9001  |

# Advanced settings
CreepMiner auto start
```AUTO_START to TRUE / FALSE```

Ssh log in to the container
```ENABLE_SSH in TRUE```
