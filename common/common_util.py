# common utilities
import os


def make_dir(path):
    if not os.path.exists(path):
        os.makedirs(path)
        

def is_int(str):
    try:
        int(str)
        return True
    except ValueError:
        return False


# THIS IS OBSOLETE. USE read_file_lines()
def remove_nl_from_string_list(list):
    for i in range(0,len(list)):
        list[i] = list[i].strip('\n')
    return list


def read_file_lines(file):
    lines = [line.strip() for line in open(file)]; 
    return lines


def write_file_lines(file,lines,method):
# method: 'w' or 'a'
    file = open(file,method)
    for line in lines:
        file.write(line + "\n")
    file.close()
