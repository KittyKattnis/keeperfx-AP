#ifndef AP_DATA_H
#define AP_DATA_H


#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

#define AP_LOCATION_NO 166
extern struct APState g_ap_state;

struct APState
{
int checked_locations[AP_LOCATION_NO];
int items_recieved[AP_LOCATION_NO];   
int items_count; 
int locations_count;
};

void ap_state_init(struct APState* ap);
void ap_state_update_items(struct APState* ap, int itemid);
void ap_state_update_locations(struct APState* ap, int locationid);


#ifdef __cplusplus
}
#endif
#endif
