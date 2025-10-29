# Vein dedicated server with Docker

Run a vein dedicated server using Docker.

## Usage

Assuming that Docker is installed and operational, simply run:

```bash
docker run -dp 7777:7777/udp drpsyko101/vein-dedicated-server
```

### Persistent data

By default, the game data is installed in `/home/steam/vein-dedicated-server` but can be changed with `GAMEDIR` environment variable. Make sure the directory is writable by the `steam` user.

- Save game directory - `/home/steam/vein-dedicated-server/Vein/Saved/SaveGames`
- Logs directory - `/home/steam/vein-dedicated-server/Vein/Saved/Logs`

### Configuration

This image primarily uses environment variables to set the game configurations.

| Variable                              |                Value                | Description                                                                                             |
| ------------------------------------- | :---------------------------------: | ------------------------------------------------------------------------------------------------------- |
| `GAMEDIR`                             | `/home/steam/vein-dedicated-server` | Game installation directory.                                                                            |
| `GAME_PORT`                           |               `7777`                | Main game UDP port.                                                                                     |
| `QUERY_PORT`                          |               `27015`               | Steamwork query TCP port.                                                                               |
| `VEIN_SERVER_NAME`                    |            `Vein Server`            | Server name.                                                                                            |
| `VEIN_SERVER_DESCRIPTION`             |      `Welcome to Vein Server!`      | Server description.                                                                                     |
| `VEIN_PASSWORD`                       |              _(none)_               | Server password.                                                                                        |
| `VEIN_MAX_PLAYERS`                    |                `16`                 | Max player amount.                                                                                      |
| `SUPER_ADMIN_STEAM_IDS`               |              _(none)_               | Server super admin Steam IDs, separated by comma (`,`).                                                 |
| `ADMIN_STEAM_IDS`                     |              _(none)_               | Server admin Steam IDs, separated by comma (`,`).                                                       |
| `VEIN_HUNGER_MULTIPLIER`              |                 1.0                 | How much faster or slower you get thirsty.                                                              |
| `VEIN_MAX_THIRD_PERSON_DISTANCE`      |                `400`                | How far out the camera can zoom. Set to `0` to disable third-person. Default is 400.                    |
| `VEIN_SHOW_SCOREBOARD_BADGES`         |                `1.0`                | Enable or disable admin badges on the scoreboard. If this is off, nobody can tell who is an admin.      |
| `VEIN_THIRST_MULTIPLIER`              |                `1.0`                | How much faster or slower you get thirsty.                                                              |
| `VEIN_ALLOW_PICKPOCKETING`            |               `true`                | Lets players search other players that are not in the same group as them.                               |
| `VEIN_ALLOW_REMOTE_VIDEO`             |               `true`                | Can players play video from the internet on TVs?                                                        |
| `VEIN_ALWAYS_BECOME_ZOMBIE`           |               `false`               | People will turn into a zombie when they die, regardless of if they were infected or not.               |
| `VEIN_BASE_DAMAGE`                    |               `true`                | Can zombies (or other players) damage bases?                                                            |
| `VEIN_BASE_RAIDING`                   |               `true`                | If this is off, players can't claim utility cabinets (they can only build them).                        |
| `VEIN_BUILD_OBJECT_PVP`               |               `true`                | Can other players damage bases and anything inside the UC range?                                        |
| `VEIN_BUILD_STRUCTURE_DECAY`          |                `4.0`                | At what interval (in real hours) do Utility Cabinets consume resources?                                 |
| `VEIN_CLOTHING_HIDEABLE`              |               `true`                | Can clothes and armor be hidden, e.g. for roleplay purposes?                                            |
| `VEIN_CONTAINERS_RESPAWN`             |               `true`                | If this is on, containers that aren't owned by anyone respawn periodically.                             |
| `VEIN_FURNITURE_RESPAWNS`             |               `true`                | If this is on, furniture like tables or chairs respawn periodically. Only has an effect in multiplayer. |
| `VEIN_HEADSHOT_DAMAGE_MULTIPLIER`     |                `2.0`                | How much more or less damage headshots do.                                                              |
| `VEIN_HORDES`                         |               `true`                | If this is on, hordes will spawn if you make too much noise, have a large base, etc.                    |
| `VEIN_ITEM_ACTOR_SPAWNERS_RESPAWN`    |               `true`                | Do items respawn on e.g. shelves, sheds, 66.7                                                           |
| `VEIN_MAX_CHARACTERS`                 |               `100.0`               | How many characters can people make?                                                                    |
| `VEIN_NIGHTTIME_MULTIPLIER`           |                `3.0`                | How much faster time progresses at night.                                                               |
| `VEIN_NO_SAVES`                       |               `false`               | You are not allowed to manually save your game. Autosaves function as normal. Prevents save scumming.   |
| `VEIN_OFFLINE_RAIDING`                |               `true`                | If this is on, players can't claim utility cabinets, damage bases, etc. if the owners are offline.      |
| `VEIN_PERMADEATH`                     |               `false`               | Your character's deleted when you die. Be careful.                                                      |
| `VEIN_PERSISTENT_CORPSES`             |               `true`                |                                                                                                         |
| `VEIN_POWER_SHUTOFF_TIME`             |               `46.0`                | When the power shuts off, relative to April 2033 (days).                                                |
| `VEIN_PVP`                            |               `true`                | Enable or disable player-versus-player damage.                                                          |
| `VEIN_SCARCITY_DIFFICULTY`            |                `2.0`                | Less loot means a more difficult - and fast approaching - endgame.                                      |
| `VEIN_STAGGER_ODDS`                   |                `0.1`                | How likely it is by default for zombies to be staggered from hits.                                      |
| `VEIN_START_TIME`                     |                `0.0`                | You can choose to start the game later than default (days).                                             |
| `VEIN_STUNLOCK_CHANCE`                |                `0.6`                | How likely it is by default for zombies to be stunned from hits.                                        |
| `VEIN_STUNLOCK_DURATION`              |                `2.0`                | The time zombies get stun locked (in seconds).                                                          |
| `VEIN_TIME_MULTIPLIER`                |               `16.0`                | How much faster time runs in-game compared to real life.                                                |
| `VEIN_TIME_WITH_NO_PLAYERS`           |                `0.0`                | Set the time in-game relative to real life when there is no player. Setting to 0 will pause the game.   |
| `VEIN_UTILITY_CABINET_INTERVAL`       |                `4.0`                | At what interval (in real hours) do Utility Cabinets consume resources.                                 |
| `VEIN_VEHICLE_OUTGOING_PLAYER_DAMAGE` |               `true`                | If this is off, vehicles can't damage players.                                                          |
| `VEIN_WATER_SHUTOFF_TIME`             |               `30.0`                | When the water shuts off, relative to April 2033 (days).                                                |
| `VEIN_ZOMBIE_CRAWL_SPEED_MULTIPLIER`  |                `1.0`                | How much faster crawling zombies are.                                                                   |
| `VEIN_ZOMBIE_DAMAGE_MULTIPLIER`       |                `1.0`                | How much more deadly zombie hits are.                                                                   |
| `VEIN_ZOMBIE_HEARING_MULTIPLIER`      |                `1.0`                | How much further zombies can hear you.                                                                  |
| `VEIN_ZOMBIE_INFECTION_CHANCE`        |               `0.01`                | How likely it is that you get infected from zombie attacks.                                             |
| `VEIN_ZOMBIE_RUNSPEED_MULTIPLIER`     |                `1.0`                | How much faster running zombies are.                                                                    |
| `VEIN_ZOMBIES_CAN_CLIMB`              |               `true`                | Can zombies climb over ledges and onto roofs?                                                           |
| `VEIN_ZOMBIES_HEADSHOTONLY`           |               `false`               | Zombies only die from headshots.                                                                        |
| `VEIN_ZOMBIES_HEALTH`                 |               `40.0`                | Zombies base health.                                                                                    |
| `VEIN_ZOMBIE_SIGHT_MULTIPLIER`        |                `1.0`                | How much further zombies can see you.                                                                   |
| `VEIN_ZOMBIE_SPAWN_COUNT_MULTIPLIER`  |                `1.0`                | How many more zombies to spawn. This will impact game performance.                                      |
| `VEIN_ZOMBIE_SPEED_MULTIPLIER`        |                `1.0`                | Base zombies speed rate.                                                                                |
| `VEIN_ZOMBIE_WALKER_PERCENTAGE`       |                `0.8`                | How many zombies are walkers.                                                                           |
| `VEIN_ZOMBIE_WALK_SPEED_MULTIPLIER`   |                `1.0`                | How much faster walking zombies are.                                                                    |
