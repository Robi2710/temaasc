#include <iostream>
#include <fstream>
using namespace std;
ifstream fin("bid.in");
ofstream fout("bid.out");
int a[1024][1024] = {0}, desc, dim, nrfis, cnt, canfit = true;
void ADD()
{
    fin >> nrfis;

    for (int k = 0; k < nrfis; k++)
    {
        fin >> desc >> dim;

        cnt = (dim + 7) / 8; 

        bool found = false;
        int start_row = 0, start_col = 0;

        for (int i = 0; i < 1024 && !found; i++)
        {
            for (int j = 0; j <= 1024 - cnt; j++)
            {
                bool can_fit = true;

                for (int l = 0; l < cnt; l++)
                {
                    if (a[i][j + l] != 0)
                    {
                        can_fit = false;
                        break;
                    }
                }

                if (can_fit)
                {
                    start_row = i;
                    start_col = j;
                    found = true;
                    break;
                }
            }
        }

        if (found)
        {
            for (int l = 0; l < cnt; l++)
            {
                a[start_row][start_col + l] = desc;
            }

            fout << desc << ": ((" << start_row << ", " << start_col
                 << "), (" << start_row << ", " << start_col + cnt - 1 << "))\n";
        }
        else
        {
            fout << desc << ": ((0, 0), (0, 0))\n";
        }
    }
}
void GET()
{
    fin >> desc;
    int start = -1, end_column = -1, row, start_column = -1;
    for (int i = 0; i < 1024; i++)
    {
        for (int j = 0; j < 1024; j++)
        {
            if (a[i][j] == desc)
            {
                if (start_column == -1)
                {
                    start_column = j;
                }
                end_column = j;
                row = i;
            }
        }
    }
    if (start_column != -1)
    {
        fout << "((" << row << ", " << start_column << "), (" << row << ", " << end_column << "))\n";
    }
    else
    {
        fout << "((0, 0), (0, 0))\n";
    }
}
void DELETE()
{
    fin >> desc;
    for (int i = 0; i < 1024; i++)
    {
        for (int j = 0; j < 1024; j++)
        {
            if (a[i][j] == desc)
            {
                a[i][j] = 0;
            }
        }
    }
    for (int i = 0; i < 1024; i++)
    {
        for (int j = 0; j < 1024;)
        {
            if (a[i][j] != 0)
            {
                int row = i;
                int start_column = j;
                int currentDesc = a[i][j];
                while (j < 1024 && a[i][j] == currentDesc)
                {
                    j++;
                }
                fout << currentDesc << ": ((" << row << ", " << start_column << "), (" << row << ", " << j - 1 << "))\n";
            }
            else
            {
                j++;
            }
        }
    }
}
void DEFRAGMENTATION()
{
    int temp[1024][1024] = {0},index;
    int currentRow = 0;
    int currentCol = 0;
    for (int i=0; i<1024; i++)
    {
        index=0;
        for (int j=0; j<1024;)
        {
            if (a[i][j]!=0)
            {
                int currentDesc=a[i][j];
                int cnt=0;
                while (j+cnt<1024 && a[i][j+cnt]==currentDesc)
                {
                    cnt++;
                }
                if (currentCol+cnt>1024)
                {
                    currentRow++;
                    currentCol=0;
                }
                for (int k=0; k<cnt; k++)
                {
                    temp[currentRow][currentCol+k]=currentDesc;
                }
                currentCol+=cnt;
                j+=cnt;
            }
            else
            {
                j++;
            }
        }
    }
    for (int i=0; i<1024; i++)
    {
        for (int j=0; j<1024; j++)
        {
            a[i][j]=temp[i][j];
        }
    }
    for (int i = 0; i < 1024; i++)
    {
        for (int j = 0; j < 1024;)
        {
            if (a[i][j] != 0)
            {
                int row = i;
                int start_column = j;
                int currentDesc = a[i][j];
                while (j < 1024 && a[i][j] == currentDesc)
                {
                    j++;
                }
                fout << currentDesc << ": ((" << row << ", " << start_column << "), (" << row << ", " << j - 1 << "))\n";
            }
            else
            {
                j++;
            }
        }
    }
}
int main()
{
    int nrinstr, instr;
    fin >> nrinstr;
    for (int i = 1; i <= nrinstr; i++)
    {
        fin >> instr;
        if (instr == 1)
        {
            ADD();
        }
        else if (instr == 2)
        {
            GET();
        }
        else if (instr == 3)
        {
            DELETE();
        }
        else if (instr == 4)
        {
            DEFRAGMENTATION();
        }
    }
}
