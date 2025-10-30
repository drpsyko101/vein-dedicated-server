#!/bin/bash

set -e

# Set default values from context
: "${GAMEDIR:=$HOME/vein-dedicated-server}"
: "${VEIN_EXPERIMENTAL:=0}"
: "${GAME_PORT:=7777}"
: "${QUERY_PORT:=27015}"
: "${SERVER_NAME:=Vein Server}"
: "${SERVER_DESCRIPTION:=Welcome to Vein Server!}"
: "${SERVER_PASSWORD:=}"
: "${MAX_PLAYERS:=16}"
: "${SUPER_ADMIN_STEAM_IDS:=}"
: "${ADMIN_STEAM_IDS:=}"
: "${VEIN_HUNGER_MULTIPLIER:=1.0}"
: "${VEIN_MAX_THIRD_PERSON_DISTANCE:=400.0}"
: "${VEIN_SHOW_SCOREBOARD_BADGES:=true}"
: "${VEIN_THIRST_MULTIPLIER:=1.0}"
: "${VEIN_ALLOW_PICKPOCKETING:=true}"
: "${VEIN_ALLOW_REMOTE_VIDEO:=true}"
: "${VEIN_ALWAYS_BECOME_ZOMBIE:=false}"
: "${VEIN_BASE_DAMAGE:=1.0}"
: "${VEIN_BASE_RAIDING:=1.0}"
: "${VEIN_BUILD_OBJECT_PVP:=1.0}"
: "${VEIN_BUILD_STRUCTURE_DECAY:=1.0}"
: "${VEIN_CLOTHING_HIDEABLE:=false}"
: "${VEIN_CONTAINERS_RESPAWN:=true}"
: "${VEIN_FURNITURE_RESPAWNS:=true}"
: "${VEIN_HEADSHOT_DAMAGE_MULTIPLIER:=2.0}"
: "${VEIN_HORDES:=1.0}"
: "${VEIN_ITEM_ACTOR_SPAWNERS_RESPAWN:=1.0}"
: "${VEIN_MAX_CHARACTERS:=100}"
: "${VEIN_NIGHTTIME_MULTIPLIER:=3.0}"
: "${VEIN_NO_SAVES:=false}"
: "${VEIN_OFFLINE_RAIDING:=false}"
: "${VEIN_PERMADEATH:=false}"
: "${VEIN_PERSISTENT_CORPSES:=true}"
: "${VEIN_POWER_SHUTOFF_TIME:=46.0}"
: "${VEIN_PVP:=true}"
: "${VEIN_SCARCITY_DIFFICULTY:=2.0}"
: "${VEIN_STAGGER_ODDS:=0.1}"
: "${VEIN_START_TIME:=0.0}"
: "${VEIN_STUNLOCK_CHANCE:=0.6}"
: "${VEIN_STUNLOCK_DURATION:=2.0}"
: "${VEIN_TIME_MULTIPLIER:=16.0}"
: "${VEIN_TIME_WITH_NO_PLAYERS:=0.0}"
: "${VEIN_UTILITY_CABINET_INTERVAL:=4.0}"
: "${VEIN_VEHICLE_OUTGOING_PLAYER_DAMAGE:=true}"
: "${VEIN_WATER_SHUTOFF_TIME:=30.0}"
: "${VEIN_ZOMBIE_CRAWL_SPEED_MULTIPLIER:=1.0}"
: "${VEIN_ZOMBIE_DAMAGE_MULTIPLIER:=1.0}"
: "${VEIN_ZOMBIE_HEARING_MULTIPLIER:=1.0}"
: "${VEIN_ZOMBIE_INFECTION_CHANCE:=0.01}"
: "${VEIN_ZOMBIE_RUNSPEED_MULTIPLIER:=1.0}"
: "${VEIN_ZOMBIES_CAN_CLIMB:=true}"
: "${VEIN_ZOMBIES_HEADSHOTONLY:=false}"
: "${VEIN_ZOMBIES_HEALTH:=40.0}"
: "${VEIN_ZOMBIE_SIGHT_MULTIPLIER:=1.0}"
: "${VEIN_ZOMBIE_SPAWN_COUNT_MULTIPLIER:=1.0}"
: "${VEIN_ZOMBIE_SPEED_MULTIPLIER:=1.0}"
: "${VEIN_ZOMBIE_WALKER_PERCENTAGE:=0.8}"
: "${VEIN_ZOMBIE_WALK_SPEED_MULTIPLIER:=1.0}"
: "${ADDITIONAL_CONSOLE_VARIABLES:=}"

STEAMCMD_DIR="/home/steam/steamcmd"
EXPERIMENTAL_FLAG=$( [ "$VEIN_EXPERIMENTAL" -eq 1 ] && echo " -beta experimental " || echo "" )

log_error() {
  local err_msg="${1:-Unknown error}"
  local exit_code="${2:-1}"
  echo -e "\e[31mError: $err_msg\e[39m"
  exit "$exit_code"
}

bool_to_int() {
  local value="${1:-false}"
  [ "$value" = "true" ] && echo "1" || echo "0"
}

# Check if SteamCMD is installed
if [ ! -d "$STEAMCMD_DIR" ]; then
  log_error "SteamCMD is not installed. Please ensure it is installed in /steamcmd." 1
fi

# Download and install Vein Dedicated Server using SteamCMD
echo "Creating $GAMEDIR"
mkdir -p "$GAMEDIR" || log_error "Failed to create $GAMEDIR."
if [ ! -w "$GAMEDIR" ]; then
  log_error "Directory $GAMEDIR is not writable by $(whoami)." 2
fi
echo "Installing/Updating Vein Dedicated Server to $GAMEDIR"
"${STEAMCMD_DIR}/steamcmd.sh" +force_install_dir "$GAMEDIR" +login anonymous +app_update 2131400 validate +quit || {
  log_error "Failed to install Vein Dedicated Server." 3
}
cd "$GAMEDIR" || exit 1

# Setup steamclient.so symlink
STEAMCLIENT_PATH="$STEAMCMD_DIR/linux64/steamclient.so"
if [ ! -f "$STEAMCLIENT_PATH" ]; then
  log_error "steamclient.so not found in /steamcmd." 2
fi
mkdir -p ~/.steam/sdk64
ln -sf $STEAMCLIENT_PATH ~/.steam/sdk64/steamclient.so

# Setup Game.ini
echo "Setting up game configurations..."
CONFIG_DIR="$GAMEDIR/Vein/Saved/Config/LinuxServer"
mkdir -p "$CONFIG_DIR"
GAMEINI="$CONFIG_DIR/Game.ini"
rm -f "$GAMEINI"
cat > "$GAMEINI" <<EOL
[/Script/Vein.ServerSettings]
GS_HungerMultiplier=$VEIN_HUNGER_MULTIPLIER
GS_MaxThirdPersonDistance=$VEIN_MAX_THIRD_PERSON_DISTANCE
GS_ShowScoreboardBadges=$(bool_to_int "$VEIN_SHOW_SCOREBOARD_BADGES")
GS_ThirstMultiplier=$VEIN_THIRST_MULTIPLIER
GS_AllowPickpocketing=$(bool_to_int "$VEIN_ALLOW_PICKPOCKETING")
GS_AllowRemoteVideo=$(bool_to_int "$VEIN_ALLOW_REMOTE_VIDEO")
GS_AlwaysBecomeZombie=$(bool_to_int "$VEIN_ALWAYS_BECOME_ZOMBIE")
GS_BaseDamage=$VEIN_BASE_DAMAGE
GS_BaseRaiding=$(bool_to_int "$VEIN_BASE_RAIDING")
GS_BuildObjectPVP=$(bool_to_int "$VEIN_BUILD_OBJECT_PVP")
GS_BuildStructureDecay=$VEIN_BUILD_STRUCTURE_DECAY
GS_ClothingHideable=$(bool_to_int "$VEIN_CLOTHING_HIDEABLE")
GS_ContainersRespawn=$(bool_to_int "$VEIN_CONTAINERS_RESPAWN")
GS_FurnitureRespawns=$(bool_to_int "$VEIN_FURNITURE_RESPAWNS")
GS_HeadshotDamageMultiplier=$VEIN_HEADSHOT_DAMAGE_MULTIPLIER
GS_Hordes=$VEIN_HORDES
GS_ItemActorSpawnersRespawn=$VEIN_ITEM_ACTOR_SPAWNERS_RESPAWN
GS_MaxCharacters=$VEIN_MAX_CHARACTERS
GS_NightTimeMultiplier=$VEIN_NIGHT_TIME_MULTIPLIER
GS_NoSaves=$(bool_to_int "$VEIN_NO_SAVES")
GS_OfflineRaiding=$(bool_to_int "$VEIN_OFFLINE_RAIDING")
GS_Permadeath=$(bool_to_int "$VEIN_PERMADEATH")
GS_PersistentCorpses=$(bool_to_int "$VEIN_PERSISTENT_CORPSES")
GS_PowerShutoffTime=$VEIN_POWER_SHUTOFF_TIME
GS_PVP=$(bool_to_int "$VEIN_PVP")
GS_ScarcityDifficulty=$VEIN_SCARCITY_DIFFICULTY
GS_StaggerOdds=$VEIN_STAGGER_ODDS
GS_StartTime=$VEIN_START_TIME
GS_StunLockChance=$VEIN_STUNLOCK_CHANCE
GS_StunLockDuration=$VEIN_STUNLOCK_DURATION
GS_TimeMultiplier=$VEIN_TIME_MULTIPLIER
GS_TimeWithNoPlayers=$VEIN_TIME_WITH_NO_PLAYERS
GS_UtilityCabinetInterval=$VEIN_UTILITY_CABINET_INTERVAL
GS_VehicleOutgoingPlayerDamage=$(bool_to_int "$VEIN_VEHICLE_OUTGOING_PLAYER_DAMAGE")
GS_WaterShutoffTime=$VEIN_WATER_SHUTOFF_TIME
GS_ZombieCrawlSpeedMultiplier=$VEIN_ZOMBIE_CRAWL_SPEED_MULTIPLIER
GS_ZombieDamageMultiplier=$VEIN_ZOMBIE_DAMAGE_MULTIPLIER
GS_ZombieHearingMultiplier=$VEIN_ZOMBIE_HEARING_MULTIPLIER
GS_ZombieInfectionChance=$VEIN_ZOMBIE_INFECTION_CHANCE
GS_ZombieRunSpeedMultiplier=$VEIN_ZOMBIE_RUNSPEED_MULTIPLIER
GS_ZombiesCanClimb=$(bool_to_int "$VEIN_ZOMBIES_CAN_CLIMB")
GS_ZombiesHeadshotOnly=$(bool_to_int "$VEIN_ZOMBIES_HEADSHOTONLY")
GS_ZombiesHealth=$VEIN_ZOMBIES_HEALTH
GS_ZombieSightMultiplier=$VEIN_ZOMBIE_SIGHT_MULTIPLIER
GS_ZombieSpawnCountMultiplier=$VEIN_ZOMBIE_SPAWN_COUNT_MULTIPLIER
GS_ZombieSpeedMultiplier=$VEIN_ZOMBIE_SPEED_MULTIPLIER
GS_ZombieWalkerPercentage=$VEIN_ZOMBIE_WALKER_PERCENTAGE
GS_ZombieWalkSpeedMultiplier=$VEIN_ZOMBIE_WALK_SPEED_MULTIPLIER

[/Script/Vein.VeinGameSession]
ServerName=$SERVER_NAME
ServerDescription=$SERVER_DESCRIPTION
Password=$SERVER_PASSWORD
MaxPlayers=$MAX_PLAYERS
EOL

for id in ${SUPER_ADMIN_STEAM_IDS//,/ }; do
  echo "SuperAdminSteamIDs=$id" >> "$CONFIG_DIR/Game.ini"
done

for id in ${ADMIN_STEAM_IDS//,/ }; do
  echo "AdminSteamIDs=$id" >> "$CONFIG_DIR/Game.ini"
done

# Setup Engine.ini
ENGINEINI="$CONFIG_DIR/Engine.ini"
if [ ! -f "$ENGINEINI" ]; then
  touch "$ENGINEINI"
fi

if ! grep -q "\[ConsoleVariables\]" "$ENGINEINI"; then
  echo "[ConsoleVariables]" >> "$ENGINEINI"
fi

for var in ${ADDITIONAL_CONSOLE_VARIABLES//,/ }; do
  if ! grep -q "${var%%=*}" "$ENGINEINI"; then
    sed -i "/\[ConsoleVariables\]/a $var" "$ENGINEINI"
  else
    sed -i "s/${var%%=*}=.*/${var}/" "$ENGINEINI"
  fi
done

# Start the Vein Dedicated Server with logging enabled
./VeinServer.sh -log -Port=$GAME_PORT -QueryPort=$QUERY_PORT "$@"
