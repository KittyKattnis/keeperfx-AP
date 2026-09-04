#include "pre_inc.h"
#include "ap_data.h"
#include <stdbool.h>
#include "post_inc.h"

struct APState g_ap_state;

void ap_state_init(struct APState* ap)
{
if (!ap) return;

    ap->items_count = 0;
    ap->locations_count = 0;
    for (int i = 0; i < AP_LOCATION_NO; i++) {
        ap->checked_locations[i] = 0; 
        ap->items_recieved[i] = 0;
    }
}

void ap_state_update_items(struct APState* ap, int itemid)
{
    int item_count = ap->items_count;

    for (int i = 0; i < item_count ; i++)
    {
        if (itemid == ap->items_recieved[i])
        {
            return;
        }
        
    }

    ap->items_recieved[item_count] = itemid;
    ap->items_count++;
    
}

void ap_state_update_locations(struct APState* ap, int locationid)
{
    int location_count = ap->locations_count;

    for (int i = 0; i < location_count ; i++)
    {
        if (locationid == ap->checked_locations[i])
        {
            return;
        }
        
    }

    ap->checked_locations[location_count] = locationid;
    ap->locations_count++;
    
}