# Sistem de operare minimal, componenta de gestiune a dispozitivului de stocare
## Implementarea sistemului cu memorie unidimensionala
In acest caz unidimensional, modul in care functioneaza dispozitivul de stocare este
urmatorul:
- capacitatea de stocare a dispozitivului este data si fixata la 8MB;
- capacitatea de stocare a dispozitivului este impartita in blocuri de cate 8kB fiecare;
- intr-un bloc poate fi stocat continut dintr-un singur fisier;
- un fisier are nevoie de cel putin doua blocuri pentru stocare;
- se presupune ca un fisier stocat este stocat contiguu;
- daca un fisier nu se poate stoca contiguu atunci scrierea sa pe dispozitiv nu este posibila.

Fiecare fisier este identificat printr-un descriptor - ID unic (un numar natural intre 1
si 255); astfel, sistemul nostru poate stoca maximum 255 de fisiere diferite.
Modulul de management al dispozitivului de stocare poate realiza urmatoarele operatii:

- dat un descriptor (ID de fisier), se returneaza intervalul de blocuri (start, end) unde este
stocat fisierul;
- dat un descriptor de fisier si dimensiunea sa in kB, se returneaza intervalul de blocuri unde
poate sa fie stocat fisierul. Se returneaza primul interval liber, in parcurgerea de la stanga la
dreapta. In cazul in care stocarea nu este posibila, se returneaza intervalul (0, 0);
- dat un descriptor, se sterge fisierul respectiv (adica se elibereze blocurile unde continutul
fisierul a fost salvat); se stergere operatia prin care blocurile primesc drept descriptor
valoarea 0;
- operatia de defragmentare: se reordoneaza/recalculeaza blocurile in care sunt stocate fisierele, astfel
incat acestea sa fie stocate compact (adica incepand cu blocul 0 si folosind toate blocurile
consecutive, fara goluri).

## Implementarea sistemului cu memorie bidimensionala 
Avem dimensiune de 8MB in ambele sensuri. Avem o matrice de blocuri, iar o sectiune contigua este considerata pe linii.
- dat un descriptor de fisier, se returneaza intervalul de blocuri ((startX, startY), (endX,
endY)) unde este stocat fisierul;
- dat un descriptor de fisier si dimensiunea sa in kB, se returneaza ID-urile blocurilor unde
poate sa fie stocat fisierul. Se intoarce primul interval in care fisierul poate fi pozitionat.
Daca nu se poate stoca atunci se returneaza intervalul ((0,0), (0,0))
- dat un descriptor de fisier, se sterge fisierul respectiv (adica sa se elibereze blocurile unde
continutul fisierului a fost salvat); exact ca in cazul unidimensional, consideram stergere operatia prin care blocurile primesc drept descriptor valoarea 0;
- operatia de defragmentare bidimensionala; se reordoneaza blocurile in care sunt stocate fisierele,
astfel incat acestea sa fie stocate compact in matrice (se muta golurile in dreapta-jos in matrice).
