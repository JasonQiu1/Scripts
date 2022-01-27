// Prints out remaining power info to stdout on WINDOWS ONLY.

#include <stdio.h>
#include <Windows.h>
#include <winbase.h>

int main() {
    SYSTEM_POWER_STATUS powerStatus;
    GetSystemPowerStatus(&powerStatus);

    long seconds = powerStatus.BatteryLifeTime;
    int hours = seconds / 3600;
    seconds -= hours * 3600;
    int mins = seconds / 60;
    printf("Battery remaining: %i%%\nEstimated: %i hr %i mins\n", powerStatus.BatteryLifePercent, hours, mins);
    return 0;
}
