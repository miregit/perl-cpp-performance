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
    word_det(): vowels(0), palindrome(false) {
    }
    unsigned char vowels;
    bool          palindrome;
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


    void vowel_calc () {
        for (words_t::iterator it=words_.begin(); it!=words_.end(); it++) {
            unsigned char nr = 0;
            for (size_t i=0; i<it->first.length(); i++) {
                char a = it->first[i];
                if (
                    a == 'a' || a == 'e' || a == 'i' || a == 'o' || a == 'u' ||
                    a == 'A' || a == 'E' || a == 'I' || a == 'O' || a == 'U'
                )
                    nr++;
            }
            it->second.vowels = nr;
        }
    }

    void palindrome_calc () {
        for (words_t::iterator it=words_.begin(); it!=words_.end(); it++) {

            const string& word = it->first;
            bool f      = true;
            size_t wl   = word.length();
            size_t wlmo = wl - 1;
            for (size_t i=0; i<static_cast<size_t>(wl/2); i++) {
                if (word[i] != word[wlmo - i]) {
                    f = false;
                    break;
                }
            }
            it->second.palindrome = f;
        }
    }

    SV * word_get_hr (char * w) {
        HV * rh = (HV *)sv_2mortal((SV *)newHV());
        const words_t::iterator it = words_.find(w);
        if (it != words_.end()) {
            hv_store(rh, "vowels",      6, newSViv(it->second.vowels),  0);
            hv_store(rh, "palindrome", 10, newSViv(it->second.palindrome?1:0),  0);
        }
        return newRV((SV *) rh);
    }

    ~Osadmin_XS() { 
        // cout << "xs destroy" << endl;
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

void 
Osadmin_XS::vowel_calc()

void 
Osadmin_XS::palindrome_calc()

SV * 
Osadmin_XS::word_get_hr (char * w)

