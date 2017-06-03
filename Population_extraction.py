# Extract individuals from master file 2 == membership 1 == non-membership
import sys

# load in data
parameters = sys.argv

# parameters = file, ethnic group (3 to 29)
myfile = open(parameters[1])
raw = myfile.readlines()
myfile.close()


# loop through based on (i) CoO (column) & (ii) has to be = 2

# assume KHV == col 3
eg = int(parameters[2])

header_list = raw[0].strip('\n').split(" ")

this_group = []

this_group.append(raw[0])

for this_row in range(1,len(raw)):
   indiv = raw[this_row].strip('\n').split(' ')[eg]
   if indiv == '2':
      this_group.append(raw[this_row])

outfile = parameters[1].split('.')[0]      

newfile = open("%s_eg%d.txt"%(outfile,eg),'w')
newfile.writelines(this_group)
newfile.close()
