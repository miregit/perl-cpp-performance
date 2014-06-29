#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#ifdef __cplusplus
}
#endif

#include <cstring>
#include <iostream>
#include <fstream>
#include <map>

using namespace std;

struct word_det {
    word_det(): vowels(0), ord_sum(0) {
    }
    unsigned char vowels;
    size_t        ord_sum;
};

typedef map<string, word_det> words_t;

class Osadmin_XS {
public:
    Osadmin_XS(char * dict_fp):dict_fp_(dict_fp) {
    }

    void dict_load_words () {
        string l;
        ifstream fho (dict_fp_.c_str());
        if (fho.is_open()) {
            while ( getline (fho,l) ) {
                words_[l] = word_det();
            }
            fho.close();
        } else 
            croak("ERROR: problem loading %s\n", dict_fp_.c_str()); 
    }

    ~Osadmin_XS() { 
    }

private:
    string dict_fp_;
    words_t words_;
};

MODULE = Osadmin		PACKAGE = Osadmin_XS

PROTOTYPES: ENABLE

Osadmin_XS *
Osadmin_XS::new(char * dict_fp)

void
Osadmin_XS::DESTROY()

void 
Osadmin_XS::dict_load_words()

