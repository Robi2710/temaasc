#include <iostream>
#include <fstream>  
using namespace std;
ifstream fin("input1.txt");
ofstream fout("output1.txt");
void ADD(int v[],int desc, int dim)
{
    int i, cnt, startindex = -1;
    if (dim%8==0)
    {
        cnt=dim/8;
    }
    else
    {
        cnt=dim/8+1;
    }
    for (i = 0; i < 256; i++) 
    {
        bool canFit = true;
        for (int j = 0; j < cnt; j++) 
        {
            if (v[i + j] != 0) 
            {
                canFit = false;
                break;
            }
        }
        if (canFit) 
        {
            startindex = i;
            break;
        }
    }
    if (startindex != -1) 
    {
        for (i = 0; i < cnt; i++) 
        {
            v[startindex + i] = desc;
        }
        fout << desc << ": (" << startindex << ", " << startindex + cnt - 1 << ")\n";
    }
    else {
        fout << desc << ": (0, 0)\n";
    }
}
void GET(int v[],int desc)
{
    int start=-1, end=-1;
    for (int i=0; i<256; i++)
    {
        if (v[i]==desc)
        {
            if (start==-1)
            {
                start=i;
            }
            end=i;
        }
    }
    if (start!=-1)
    {
        fout<<"("<<start<<","<<end<<")"<<endl;
    }
    else {
        fout<<"(0,0)"<<endl;
    }
}
void DELETE(int v[], int desc)
{
    int i;
    bool found = false;
    for (i = 0; i < 256; i++)
    {
        if (v[i] == desc)
        {
            v[i] = 0;
            found = true;
        }
    }
    if (found)
    {
        for (i = 0; i < 256; )
        {
            if (v[i] != 0)
            {
                int start = i;
                int currentDesc = v[i];
                while (i < 256 && v[i] == currentDesc)
                {
                    i++;
                }
                fout << currentDesc << ": (" << start << ", " << i - 1 << ")\n";
            }
            else
            {
                i++;
            }
        }
    }
}
void DEFRAGMENTATION(int v[])
{
    int temp[256] = {0};
    int index = 0;
    for (int i = 0; i < 256; i++)
    {
        if (v[i] != 0)
        {
            temp[index++] = v[i];
        }
    }
    for (int i = 0; i < 256; i++)
    {
        v[i] = temp[i];
    }
    
    int start = -1, end = -1, currentDesc = 0;
    for (int i = 0; i < 256; i++)
    {
        if (v[i] != currentDesc && v[i] != 0)
        {
            if (start != -1)
            {
                fout << currentDesc << ": (" << start << ", " << end << ")\n";
            }
            currentDesc = v[i];
            start = i;
        }
        if (v[i] != 0)
        {
            end = i;
        }
    }
    if (start != -1)
    {
        fout << currentDesc << ": (" << start << ", " << end << ")\n";
    }
}
int main()
{
    int v[256]={0},n,i,j,nrfis,desc,dim,instr; 
    fin>>n;
    for (i=1; i<=n; i++)
    {
        fin>>instr;
        if (instr==1){
                fin>>nrfis;
                for (j=1; j<=nrfis; j++)
                {
                    fin>>desc>>dim;
                    ADD(v,desc,dim);
                }
                fout<<endl;
        }
        else if (instr==2){
                fin>>desc;
                GET(v,desc);
                fout<<endl;
        }
        else if (instr==3)
        {
            fin>>desc;
            DELETE(v,desc);
            fout<<endl;
        }
        else if (instr==4)
        {
            DEFRAGMENTATION(v);
            fout<<endl;
        }
    }


        
        
    /*ADD(v,5,20);
    for (int i=0; i<20; i++) 
    {
        cout<<v[i]<<" ";
    }
    cout<<endl;
    ADD(v,143,14);
    for (int i=0; i<20; i++) 
    {
        cout<<v[i]<<" ";
    }
    cout<<endl; 
    GET(v,143);
    DELETE(v,5);
    for (int i=0; i<20; i++) 
    {
        cout<<v[i]<<" ";
    }
    cout<<endl;
    ADD(v,25,73);
    for (int i=0; i<20; i++) 
    {
        cout<<v[i]<<" ";
    }
    ADD(v,251,12);
    cout<<endl;
    for (int i=0; i<20; i++) 
    {
        cout<<v[i]<<" ";
    }
    cout<<endl;
    DELETE(v,25);
    for (int i=0; i<20; i++) 
    {
        cout<<v[i]<<" ";
    }
    cout<<endl;
    DEFRAGMENTATION(v);
    for (int i=0; i<20; i++) 
    {
        cout<<v[i]<<" ";
    }
    cout<<endl;
    ADD(v,4,22);
    for (int i=0; i<20; i++) 
    {
        cout<<v[i]<<" ";
    }*/
}