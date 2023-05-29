import sys

def makeDic(s):
    dic = {}
    for letter in s:
        if letter in dic:
            dic[letter] += 1
        else:
            dic[letter] = 1
    return dic

def check(dicA,dicB):
    for i in dicA:
        if i not in dicB or dicB[i] < dicA[i]:
            return 'False'
    return 'True'  


# Posso escrever no prompt ou ler o arquivo de casos de teste 
try:
    presc = sys.argv[1]
    est = sys.argv[2]

    dicPresc = makeDic(presc)
    dicEst = makeDic(est)

    print(check(dicPresc,dicEst))
except:
    with open("casosTesteQ9.txt", "r") as f:
        content = f.read()
        lines = content.split('\n')

        for line in lines:
            presc, est = line.split(', ')
            _, presc = presc.split("=")
            _, est = est.split("=")

            
            dicPresc = makeDic(presc)
            dicEst = makeDic(est)


            print(check(dicPresc,dicEst))