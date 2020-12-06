#include "labels.h"

// Function that searches for a label in id_list
int search_label(labels *id_list, char *name, int start, int end) {
  int i;
  for (i = start; i < end; i++) {
    if (!strcmp(name, id_list[i].name))
      return i; // Found
  }
  return -1; // Not found
}

int search_label_with_type(labels *id_list, char *name, int start, int end,
                           int type) {
  int i;
  for (i = start; i < end; i++) {
    if ((!strcmp(name, id_list[i].name)) && (id_list[i].type == type))
      return i; // Found
  }
  return -1; // Not found
}
