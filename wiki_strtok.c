#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

int min(int a, int b) {
  return a<b ? a : b;
}

struct _page_hits {
    char *page;
    int hits;
};

int _page_hits_cmp(const void *a, const void *b) {
    if (((struct _page_hits*)a)->hits < ((struct _page_hits*)b)->hits) return 1;
    if (((struct _page_hits*)a)->hits > ((struct _page_hits*)b)->hits) return -1;
    return 0;
}

int main(int argn, char *argc[]) {
    char line[2048];
    char *lang;
    char *page;
    int hits;
    int i;
    FILE *fin;

    struct _page_hits page_hits[1024];
    int idx=0;

    clock_t t0, t1;

    t0 = clock();

    fin = fopen(argc[1], "r");

    while(fgets(line, 2048, fin)) {
        lang = strtok(line, " ");
        if (strcmp(lang, "en")) {
            continue;
        }
        page = strtok(NULL, " ");
        hits = atoi(strtok(NULL, " "));
        if (hits > 500) {
            page_hits[idx].page = strdup(page);
            page_hits[idx].hits = hits;
            ++idx;
        }
    }
    qsort(page_hits, idx, sizeof(struct _page_hits), _page_hits_cmp);

    fclose(fin);
    t1 = clock();

    printf("Query took %.2f seconds\n", (t1-t0)/(double)CLOCKS_PER_SEC);

    for (i=0; i< min(10, idx); ++i) {
        printf("%s (%d)\n", page_hits[i].page, page_hits[i].hits);
    }
    return 0;
}
