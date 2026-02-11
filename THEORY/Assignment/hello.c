#include <stdio.h>
#include <string.h>

int main() {
    char stored_sapid[] = "500119435";
    char user_input[20];

    while (1) {
        printf("Enter your SAP ID: ");
        scanf("%s", user_input);

        if (strcmp(user_input, stored_sapid) == 0) {
            printf("Matched\n");
            break; 
        } else {
            printf("Not Matched\n");
        }
    }
    return 0;
}