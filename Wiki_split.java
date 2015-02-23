import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.FileReader;
import java.io.File;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Comparator;
import java.util.Arrays;
import java.util.Collections;

class Wiki_split {
    class Page implements Comparable<Page>, Comparator<Page> {
        public String page;
        public int hits;
        public Page() { }
        public Page(String page, int hits) {
            this.page = page;
            this.hits = hits;
        }
        public int compareTo(Page b) {
            if (this.hits > b.hits) {
                return -1;
            }
            else if (this.hits < b.hits) {
                return 1;
            }
            else {
                return 0;
            }
        }
        public int compare(Page a, Page b) {
            return a.compareTo(b);
        }
    }


    public void _main(String argv[]) {
        File file = new File(argv[0]);
        BufferedReader rd;
        String line;
        List<Page> pages = new ArrayList<>();
        long t0, t1;

        try {
            t0 = System.currentTimeMillis();
            rd = new BufferedReader(new FileReader(file));        
            while ((line = rd.readLine()) != null) {
                  String[] words = line.split(" ");   
                  if (words[0].equals("en")) {
                    int hits = Integer.parseInt(words[2]);
                    if (hits > 500) {
                        pages.add(new Page(words[1], hits));
                    }
                }
            }
            Collections.sort(pages);

            t1 = System.currentTimeMillis();

            System.out.format("Query took %.2f seconds\n", (t1-t0)*0.001); 
            for (int i=0; i < Math.min(10, pages.size()); ++i) {
                System.out.format("%s (%d)\n", pages.get(i).page, pages.get(i).hits);
            }
        }
        catch (IOException e) {
            System.out.println("Something happened.");
        }
    }
    public static void main(String argv[]) {
        new Wiki_split()._main(argv);
    }
}

