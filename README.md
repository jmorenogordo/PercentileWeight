# PercentileWeight
Graph the weight percentile of a child up to five years

You need:  
1. Unix-like shell  
2. Gnuplot  

To obtain the weight evolution of a child you need to fill two files:  
  
1. data_baby/data_baby.txt  
** EXAMPLE **  
*Name of the baby: Zelda  
*Sex of the baby (boy/girl): girl  
*Date of the born(YYYY MM DD): 2023 12 31  
Data appearing in the original file that you download is just an example.  

3. data_weight/weight.csv  
** EXAMPLE **  
*DD/MM/YYYY Weight(kg)  
*12/9/2023 3.335  
*04/10/2023 3.22  
*08/10/2023 3.35  
Data appearing in the original file that you download is just an example.  

Then, the procedure is easy. Go to the root directory in the shell and type "sh weight.sh".  
  
This command produce two files. The first one "weight.png" shows the weight of the child along the time together with the percentile curves. The second one, weight_percentile.png shows the evolution of the percentile of the weight along the time.  
  
The percentile data comes from OMS (for furhter information, see references.txt file).  



