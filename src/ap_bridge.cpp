#include "pre_inc.h"
#include "ap_bridge.h"

#include "ap_data.h"
#include "Archipelago.h"
#include "config_terrain.h"
#include "config_campaigns.h"
#include "frontmenu_ingame_tabs.h"
#include "lua_triggers.h"
#include <cstdio>
#include <string>
#include <iostream>
#include <math.h>
#include "frontend.h"
#include "game_legacy.h"
#include "config_rules.h"
#include "post_inc.h"


void ap_location_info_callback(std::vector<AP_NetworkItem> locations);

void RedirectStdoutToFile() {
    FILE* fp;
    // Redirects all future printf / stdout calls to ap_debug.log
    freopen_s(&fp, "ap_debug.log", "w", stdout);
    
    // Disable buffering so errors write to disk immediately upon crashing
    setvbuf(stdout, NULL, _IONBF, 0);
}

void ap_connect(char* ip, char* slot, char* password) {

RedirectStdoutToFile();
    if(AP_IsInit())
    {
        AP_Shutdown();
    }

    AP_Init(ip, "Dungeon Keeper", slot, password);
    AP_SetSocketConnectedCallback(ap_socketconnected);
    AP_SetSocketErrorCallback([](std::string err) {
        frontend_archipelago_error(err.c_str());
        JUSTLOG("AP error");
    });
    AP_SetItemClearCallback(ap_clear);
    AP_SetItemRecvCallback(ap_receive);
    AP_SetLocationCheckedCallback(ap_send);
    AP_SetLocationInfoCallback(ap_location_info_callback);    
    AP_SetRoomUpdateCallback(ap_room_update);
    AP_SetSlotConnectedCallback(ap_slot_connected);
    ap_location_info_init();    
    ap_state_init(&g_ap_state);
    AP_Start();
}

void ap_socketconnected(){

    JUSTLOG("AP CONNECTED");
}

void ap_slot_connected(){
    g_ap_state.connected = true;
    frontend_archipelago_connected();
    //callback once connected to AP server, send scounts for all locations not checked yet, so that ap_location_info_callback will be triggered. 
    ap_refresh_missing();
}

void ap_room_update()
{

}

void ap_refresh_missing()
{
    AP_SendLocationScouts(AP_GetMissingLocations(),0);
    for (int64_t loc : AP_GetCheckedLocations()) {
        ap_state_update_locations(&g_ap_state, (int)loc);
    }
    ap_missing_init(&g_ap_state);
    for (int64_t loc : AP_GetMissingLocations()) {
        ap_state_update_missing_locations(&g_ap_state, (int)loc);
    }
}

void ap_receive(int id, bool notify)
{
    if(game.game_kind == GKind_LocalGame)
    {
        lua_on_item_received(id);
    }
    ap_state_update_items(&g_ap_state, id);

 //   pre lua version testing code   
 //   TbBool available = 1;
 //   long roomid = id % 100;    


 //   switch (ap_getitem_type(id))
 //   {
 //   case 1: // Rooms
 //       set_room_available(0, roomid, available, available);
 //       update_room_tab_to_config();
 //       break;  

 //   case 2: // Spells
       // set_power_available(1, spellid, 1, 1);
 //       break;  

 //  default:
 //      break;
 //  }

}

void ap_send(int id)
{
    ap_state_update_locations(&g_ap_state, id);
}

void ap_clear()
{
    ap_location_info_clear();
}

bool ap_connection_status()
{
    return g_ap_state.connected;
}

void ap_location_info_callback(std::vector<AP_NetworkItem> locations)
{
    // store the details of locations remaining so that tooltips can get set etc.
    for (const AP_NetworkItem &info : locations)
    {
        ap_location_info_update(
            info.item,
            info.location,
            info.player,
            info.flags,
            info.itemName.c_str(),
            info.locationName.c_str(),
            info.playerName.c_str()
        );
    }
}

void ap_bridge_scout_locations(const int *locations, int count)
{
    std::set<int64_t> location_set;

    for (int i = 0; i < count; i++)
    {
        location_set.insert((int64_t)locations[i]);
    }

    if (!location_set.empty())
    {
        AP_SendLocationScouts(location_set, 0);
    }
}

// probably dont need this anymore, was used to get the first digit from received item ids: 1 = room, 2 = spell
int ap_getitem_type(int id)
{
int digits = log10(id);
int itemType = (id / pow(10, digits));

return itemType;
}

// Functions below are run through the C compiler so that lua/console can call them

#ifdef __cplusplus
extern "C" {
#endif

void ap_bridge_connect(char* ip, char* slot, char* password)
{
    ap_connect(ip, slot, password);
}

void ap_bridge_location_check(int id)
{
    AP_SendItem(id);
    ap_state_update_locations(&g_ap_state, id);
}

bool ap_bridge_connection_status(void)
{
    return ap_connection_status();
}

void ap_bridge_refresh_missing(void)
{
    ap_refresh_missing();
}

void ap_process_sacrifice_recipe(struct SacrificeRecipe *sac)
{
    char recipe_name[128] = {0};
    switch (sac->action)
    { 
        case SacA_MkGoodHero:
        case SacA_MkCreature:
        {
            const char* creature_name = creature_code_name(sac->param);
            snprintf(recipe_name, sizeof(recipe_name), "Recipe %s", creature_name);
            break;
        }
        case SacA_NegSpellAll:
        case SacA_PosSpellAll:{
            const char* spell_name = spell_code_name(sac->param);        
            snprintf(recipe_name, sizeof(recipe_name), "Recipe %s", spell_name);
            break;
        }
        case SacA_NegUniqFunc:
        case SacA_PosUniqFunc:
            switch (sac->param)
            {
                case UnqF_MkAllAngry:
                    strcpy(recipe_name, "Recipe Make Angry");
                    break;
                case UnqF_MkAllVerAngry:
                    strcpy(recipe_name, "Recipe Make Very Angry");
                    break;
                case UnqF_ComplResrch:
                    strcpy(recipe_name, "Recipe Complete Research");
                    break;
                case UnqF_ComplManufc:
                    strcpy(recipe_name, "Recipe Complete Manufacture");
                    break;
                case UnqF_KillChickns:
                    strcpy(recipe_name, "Recipe Kill Chickens");
                    break;
                case UnqF_CheaperImp:                    
                    strcpy(recipe_name, "Recipe Cheaper Imps");
                    break;
                case UnqF_CostlierImp:
                    strcpy(recipe_name, "Recipe Costlier Imps");
                    break;
                case UnqF_MkAllHappy:
                    strcpy(recipe_name, "Recipe Make Happy");
                    break;
                default:
                    break;
            }
        case SacA_CustomReward:
            break;
        case SacA_CustomPunish:
            break;
    }
    if (recipe_name[0] != '\0') {
        const AP_LocationInfo* info = ap_location_info_get_by_name(recipe_name);
        if(info != NULL && ap_location_is_missing(&g_ap_state, info->item)){
            AP_SendItem(info->item);
        }
    }
}

#ifdef __cplusplus
}
#endif