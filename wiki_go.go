package main

import (
    "fmt"
    "os"
    "bufio"
    "strings"
    "strconv"
    "sort"
    "time"
)

type PageHits struct {
    Page string
    Hits int
}

func (a PageHits) String() string {
    return fmt.Sprintf("%s (%d)", a.Page, a.Hits)
}

type PageHitsList []PageHits

func (a PageHitsList) Len() int           { return len(a) }
func (a PageHitsList) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a PageHitsList) Less(i, j int) bool { return a[i].Hits > a[j].Hits }

func main() {
    file, _ := os.Open(os.Args[1]);
    reader := bufio.NewReader(file)
    pages := []PageHits{}
    
    t0 := time.Now()

    for {
        line, err := reader.ReadString('\n')
        if err != nil {break}
        words := strings.Split(line, " ")
        if words[0] == "en" {
            hits, _ := strconv.Atoi(words[2])
            if hits > 500 {
                pages = append(pages, PageHits{words[1], hits})
            }
        }
    }
    sort.Sort(PageHitsList(pages))

    fmt.Printf("Query took %.2f seconds\n", time.Now().Sub(t0).Seconds())
    n := 10
    if len(pages) < 10 {
        n = len(pages)
    }
    for i := 0; i < n; i += 1 {
        fmt.Println(pages[i])
    }
}
