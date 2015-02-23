#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <chrono>

using namespace std;

struct page {
  string name;
  int hits;
};

bool sort_pages(page a, page b) {
  return a.hits > b.hits;
}

int main(int argc, char** argv) {
  vector<page> pages = vector<page>();
  string lang, name, other;
  int hits;

  std::fstream fin;
  
  chrono::steady_clock::time_point t0 = chrono::steady_clock::now();

  fin.open(argv[1], std::fstream::in);

  while (!fin.eof()) {
    fin >> lang >> name >> hits >> other;
    if (lang == "en" && hits > 500) {
      pages.push_back({name, hits});
    }
  }
  fin.close();
  sort(pages.begin(), pages.end(), sort_pages);
  
  chrono::steady_clock::time_point t1 = chrono::steady_clock::now();

  chrono::duration<double> time_span = chrono::duration_cast<chrono::duration<double>>(t1 - t0);

  cout << "Query took " << time_span.count() << " seconds" << endl;

  for (auto p=pages.begin(); p<pages.begin()+min(10, (int)pages.size()); ++p) {
    cout << p->name << " (" << p->hits << ")" << endl;
  }

  return 0;
}
