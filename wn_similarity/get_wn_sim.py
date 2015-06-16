# generate csv files for verb noun pairs
#    sys.argv[1]: base dir, e.g. /home/ywchao/codes/action_base/
#    sys.argv[2]: wid list file, e.g. /home/ywchao/codes/action_base/wn_similarity/n_pascal_list
#    sys.argv[3]: POS, e.g. v or n
#    sys.argv[4]: is use simulate_root


# add paths
import sys
sys.path.append(sys.argv[1] + 'common/')


from nltk.corpus import wordnet as wn
import common_util as cm_util
import wordnet_util as wn_util


# get pos
pos = sys.argv[3]

if pos != "n" and pos != "v":
    print "pos error\n",
    sys.exit()
else:
    if pos == "n":
        synset_list = list(wn.all_synsets('n'))
    if pos == "v":
        synset_list = list(wn.all_synsets('v'))


# get is_simulate_root
is_simulate_root = sys.argv[4] == 1
if is_simulate_root:
    print "aaa"
    assert(pos == "v")
    

# read input
f = open(sys.argv[2], 'r')
wid_list = f.readlines()  # will include "\n"
f.close()
 
# remove newline
wid_list = cm_util.remove_nl_from_string_list(wid_list)
 
# get offset list
offset_list = wn_util.get_offset_from_wid_list(wid_list)
 
# create offset dictionary
offset_list_all = [(s.offset(), s) for s in synset_list]
offset_dict     = dict(offset_list_all)
 
 
# path, lch, wup
sim_path = [];
sim_lch  = [];
sim_wup  = [];
 
for i in range(0,len(offset_list)):
     
    offset_i = offset_list[i]
    if offset_i > 0:
        synset_i = offset_dict[offset_i]
     
    for j in range(0,len(offset_list)):
         
        offset_j = offset_list[j]
        if offset_j > 0:
            synset_j = offset_dict[offset_j]
         
        if is_simulate_root:
            sim_path.append(synset_i.path_similarity(synset_j,simulate_root=True));
            sim_lch.append(synset_i.lch_similarity(synset_j,simulate_root=True));
            sim_wup.append(synset_i.wup_similarity(synset_j,simulate_root=True));
        else:
            sim_path.append(synset_i.path_similarity(synset_j,simulate_root=False));
            sim_lch.append(synset_i.lch_similarity(synset_j,simulate_root=False));
            sim_wup.append(synset_i.wup_similarity(synset_j,simulate_root=False));
             
 
# output file
op_file = sys.argv[2] + "_sim" 
file = open(op_file,"w")
 
file.write("path lch wup" + "\n")
for i in range(0,len(sim_path)):
    file.write( "%10.8f" % sim_path[i] + " " + "%10.8f" % sim_lch[i] + " " + "%10.8f" % sim_wup[i] + "\n")
     
file.close()
        
