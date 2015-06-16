# Wordnet utilities
from nltk.corpus import wordnet as wn


def get_syn_from_lemmas(lemmas):
    lemmas_str = []
    for lemma in lemmas:
        lemmas_str.append(lemma.name());
    return lemmas_str


# list: list of strings
def match_words_from_lemmas(list, lemmas):
    lemmas_str = get_syn_from_lemmas(lemmas)
    
    is_match = False
    for l in lemmas_str:
        for j in list:
            if l == j:
                is_match = True
                break
        if is_match:
            break
        
    return is_match


# name:  synset.name()
def get_name_lemma_from_name(name):
    return name[0:name.find('.')]


def match_words_from_name_lemma(list,name):
    name_lemma = get_name_lemma_from_name(name)
    
    is_match = False
    for j in list:
        if name_lemma == j:
            is_match = True
            break
        
    return is_match


# return -1 if empty wid
def get_offset_from_wid_list(list):
    offset_list = []
    for wid in list:
        if len(wid) > 0:
            # empty wid
            offset = int(wid[1:len(wid)])
            offset_list.append(offset)
        else:
            offset_list.append(-1)
    return offset_list


def write_column_names(file):
    file.write("\"hit_id\"" + ",");
    word_per_hit = 10
    for i in range(0,word_per_hit):
        file.write("\"vid_" + "%d" % (i+1) + "\"" + ","); 
        file.write("\"vname_" + "%d" % (i+1) + "\"" + ","); 
        file.write("\"vsyn_" + "%d" % (i+1) + "\"" + ","); 
        file.write("\"vdef_" + "%d" % (i+1) + "\"" + ","); 
        file.write("\"vexam_" + "%d" % (i+1) + "\"" + ",");
        file.write("\"va1_" + "%d" % (i+1) + "\"" + ",");
        file.write("\"va2_" + "%d" % (i+1) + "\"" + ",");
        file.write("\"va3_" + "%d" % (i+1) + "\"" + ",");
    for i in range(0,word_per_hit):
        file.write("\"nid_" + "%d" % (i+1) + "\"" + ","); 
        file.write("\"nname_" + "%d" % (i+1) + "\"" + ","); 
        file.write("\"nsyn_" + "%d" % (i+1) + "\"" + ","); 
        file.write("\"ndef_" + "%d" % (i+1) + "\"" + ","); 
        file.write("\"nexam_" + "%d" % (i+1) + "\"");
        if ((i+1) != word_per_hit):
            file.write(",")
        else:
            file.write("\n")


def convert_lemmas_to_str_list(lemmas):
    synonyms = []
    for lemma in lemmas:
        synonyms.append(lemma.name());
    return synonyms


def replace_quotation(string):
    return string.replace("\"","''")


def write_one_verb(file,wid,word,lemmas,definition,examples,a1,a2,a3):
    file.write("\"" + wid + "\""); file.write(",");
    file.write("\"" + word + "\""); file.write(",");
    
    file.write("\"")
    for lemma in lemmas:
        file.write(lemma.name())
        if lemma.name() != lemmas[len(lemmas)-1].name():
            file.write(" ")
    file.write("\""); file.write(",")
    
    file.write("\"" + replace_quotation(definition) + "\""); file.write(",");
    
    if len(examples) > 0:
        file.write("\"" + replace_quotation(examples[0]) + "\"");
    else:
        file.write("\"\"")
    file.write(",");
    
    file.write("\"" + replace_quotation(a1) + "\""); file.write(",");
    file.write("\"" + replace_quotation(a2) + "\""); file.write(",");
    file.write("\"" + replace_quotation(a3) + "\"");


def write_one_noun(file,wid,word,lemmas,definition,examples):
    file.write("\"" + wid + "\""); file.write(",");
    file.write("\"" + word + "\""); file.write(",");
    
    file.write("\"")
    for lemma in lemmas:
        file.write(lemma.name())
        if lemma.name() != lemmas[len(lemmas)-1].name():
            file.write(" ")
    file.write("\""); file.write(",")
    
    file.write("\"" + replace_quotation(definition) + "\""); file.write(",");
    
    if len(examples) > 0:
        file.write("\"" + replace_quotation(examples[0]) + "\"");
    else:
        file.write("\"\"")


def write_one_word_blank(file,num_item):
    assert num_item > 2
    file.write("\"NA\""); file.write(",");
    file.write("\"NO NEED TO ANSWER THIS QUESTION\""); file.write(",");
    for i in range(2,num_item):
        file.write("\"\"");
        if (i+1) != num_item:
            file.write(",");


def display_one_synset(*args):
# args[0]: synset
# args[1]: id
# args[2]: (optional) is_check-- v
# args[3]: (optional) is_check-- o
    synset = args[0]
    id     = args[1]
    
    lemmas_str = get_syn_from_lemmas(synset.lemmas())

    if len(args) >= 4:
        if args[3]:
            print "o ",
        else:
            print "  ",
    if len(args) >= 3:
        if args[2]:
            print "v ",
        else:
            print "  ",
    print "[" + "%d" % id + "]" + " " + synset.name() \
        + " " \
        + "(" + "%d" % sum_lemma_count_for_synset_list([synset])[0] + ")" \
        + " --  " \
        + synset.definition() + "\n",
    
    if len(args) >= 4:
        print "  ",
    if len(args) >= 3:
        print "  ",
    print " ",
    for lemma in lemmas_str:
        print lemma,
    print "\n",   
    
    if len(synset.examples()) > 0:
        if len(args) >= 4:
            print "  ",
        if len(args) >= 3:
            print "  ",
        print "  " + synset.examples()[0] + "\n",
    else:    
        print "\n",


def sum_lemma_count_for_synset_list(syns_list):
    count_list = []
    for syn in syns_list:
        count = 0
        for lem in syn.lemmas():
            count = count + lem.count()
        count_list.append(count)
    return count_list

