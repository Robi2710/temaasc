#include <iostream>
#include <fstream>
using namespace std;
ifstream fin("bid.in");
ofstream fout("bid.out");
int a[1024][1024]={0},desc,dim,nrfis,cnt,canfit=true;
void ADD() {
    fin >> nrfis;
    
    for (int k = 0; k < nrfis; k++) {
        fin >> desc >> dim;
        
        // Calculate needed blocks (round up division)
        cnt = (dim + 7) / 8; // Convert kB to blocks
        
        
        bool found = false;
        int start_row = 0, start_col = 0;
        
        // Search for first available space
        for (int i = 0; i < 1024 && !found; i++) {
            for (int j = 0; j <= 1024 - cnt; j++) {
                bool can_fit = true;
                
                // Check if we have enough consecutive free blocks
                for (int l = 0; l < cnt; l++) {
                    if (a[i][j + l] != 0) {
                        can_fit = false;
                        break;
                    }
                }
                
                if (can_fit) {
                    start_row = i;
                    start_col = j;
                    found = true;
                    break;
                }
            }
        }
        
        if (found) {
            // Fill the blocks with descriptor
            for (int l = 0; l < cnt; l++) {
                a[start_row][start_col + l] = desc;
            }
            
            // Output result
            fout << desc << ": ((" << start_row << ", " << start_col 
                 << "), (" << start_row << ", " << start_col + cnt - 1 << "))\n";
        } else {
            // No space found
            fout << desc << ": ((0, 0), (0, 0))\n";
        }
    }
}
int main()
{
    int nrinstr,instr;
    fin>>nrinstr;
    for (int i=1; i<=nrinstr; i++)
    {
        fin>>instr;
        if (instr==1)
        {
            ADD();
        }
    }
}