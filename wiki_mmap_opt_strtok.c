#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

struct _page_hits {
    char *page;
    int hits;
};

int _page_hits_cmp(const void *a, const void *b) {
    if (((struct _page_hits*)a)->hits < ((struct _page_hits*)b)->hits) return 1;
    if (((struct _page_hits*)a)->hits > ((struct _page_hits*)b)->hits) return -1;
    return 0;
}

int min(int a, int b) {
  return a<b ? a : b;
}

int main(int argc, char *argv[]) {
    char line[2048];
    char *page;
    int hits;
    int i, line_len;

    struct _page_hits page_hits[1024];
    int idx=0;

    clock_t t0, t1;
    
    int fd_in = open(argv[1], O_RDONLY);
  
    char *addr, *p1, *p2;

    struct stat file_stat;

    stat(argv[1], &file_stat);

    addr = (char*)mmap(0, (size_t)file_stat.st_size, PROT_READ, MAP_PRIVATE, fd_in, 0);
    madvise(addr, (size_t)file_stat.st_size, MADV_SEQUENTIAL|MADV_WILLNEED);

    
    int j;

    t0 = clock();

    for (p1 = addr; p1-addr < (int)file_stat.st_size; p1 = p2 + 1) {
        p2 = strchr(p1, '\n');

        if (!strncmp(p1, "en ", 3)) {
            if (p2 > addr + (int)file_stat.st_size) {
                p2 = addr + (int)file_stat.st_size;
            }

            strncpy(line, p1+3, p2-p1-3);
            line[p2-p1-3] = '\0';
            
            page = strtok(line, " ");
            hits = atoi(strtok(NULL, " "));

            if (hits > 500) {
                page_hits[idx].page = strdup(page);
                page_hits[idx].hits = hits;
                ++idx;
            }
        }
    }

    close(fd_in);

    qsort(page_hits, idx, sizeof(struct _page_hits), _page_hits_cmp);

    t1 = clock();

    printf("Query took %.2f seconds\n", (t1-t0)/(double)CLOCKS_PER_SEC);

    for (i=0; i < min(10, idx); ++i) {
        printf("%s (%d)\n", page_hits[i].page, page_hits[i].hits);
    }
    return 0;
}
