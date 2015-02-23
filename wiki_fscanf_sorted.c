#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>

int min(int a, int b) {
  return a<b ? a : b;
}

struct page {
  char* name;
  int hits;
};

int sort_pages(const void *a, const void *b) {
  int x, y;
  x = ((struct page *)a)->hits;
  y = ((struct page *)b)->hits;

  return x>y?-1:(x<y?1:0);
}

int main(int argn, char *argc[]) {
  struct page *pages;

  char lang[1024], name[1024];
  int i, hits, n=0, ans;
  char other[1024];
  FILE *fin;

  time_t t0 = clock();
  pages = (struct page *)calloc(11, sizeof(struct page));
  fin = fopen(argc[1], "r");

  while (!feof(fin)) {
    ans = fscanf(fin, "%s %s %d %s\n", lang, name, &hits, other);
    if ((!strcmp(lang, "en")) && hits > 500) {
      if (n < 10 || hits > pages[10].hits) {
        pages[n].name = strdup(name);
        pages[n].hits = hits;
        ++n;
        qsort(pages, n, sizeof(struct page), sort_pages);
        if (n>10) {
            n=10;
        }
      }
    }
  }
  fclose(fin);
  
  time_t t1 = clock();

  printf("Query took %.2f seconds\n", (t1-t0)/(float)CLOCKS_PER_SEC);

  for (i=0; i<min(10, n); ++i) {
    printf("%s (%d)\n", pages[i].name, pages[i].hits);
  }

  return 0;
}
