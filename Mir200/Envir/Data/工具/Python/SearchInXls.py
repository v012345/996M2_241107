try:
    import xlrd
except:
    import subprocess
    import sys
    subprocess.Popen([sys.executable, "-m", "pip", "install", "xlrd"],
                     creationflags=subprocess.CREATE_NEW_CONSOLE).wait()
    import xlrd
import os
from optparse import OptionParser

if __name__ == '__main__':
    
    parser = OptionParser()
    (_, args) = parser.parse_args()
    toSearch = input("搜索 ：")
    while toSearch == "":
        os.system("cls")
        toSearch = input("搜索 ：")
    xlsFiles = []
    for p in args:
        for f in os.listdir(p):
            if f.endswith('.xls'):
                xlsFiles.append(p+f)
    n = 0
    with open("搜索结果.txt", 'w', encoding='utf-8') as f:
        for xls in xlsFiles:
            try:
                workbook = xlrd.open_workbook(
                    xls, logfile=open(os.devnull, 'w'))
            except:
                print(xls, "不是 xls 文件")
                exit(-1)
            sheet = workbook.sheet_by_index(0)
            num_rows = sheet.nrows
            num_cols = sheet.ncols
            for row in range(num_rows):
                for col in range(num_cols):
                    cell = sheet.cell(row, col)
                    if cell.ctype == xlrd.XL_CELL_NUMBER:
                        if cell.value.is_integer():
                            value = str(int(cell.value))  # 转成整数字符串
                        else:
                            value = str(cell.value)       # 保留浮点数
                    else:
                        value = str(cell.value)           # 直接输出文本
                    if toSearch in value:
                        print(f"{xls}@({row},{col}) : {value}")
                        f.write(f"{xls}@({row},{col}) : {value}\n")
                        n += 1

    print(f"找到 {n} 个结果, 已经输出到 搜索结果.txt 中")
