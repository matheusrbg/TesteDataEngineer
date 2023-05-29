import matplotlib.pyplot as plt

def makeDic(s):
    dic = {}
    for date in s:
        if date in dic:
            dic[date] += 1
        else:
            dic[date] = 1
    return dic

with open("casosTesteQ10.txt", "r") as f:
    content = f.read()
    lines = content.split('\n')

    dic = makeDic(lines)

    fig, ax = plt.subplots()

    dates = dic.keys()
    counts = dic.values()
    bar_colors = ['tab:red', 'tab:blue']

    ax.bar(dates, counts, color=bar_colors)

    plt.show()