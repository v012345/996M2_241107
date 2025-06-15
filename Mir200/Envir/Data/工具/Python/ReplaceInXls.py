try:
    import xlrd
except:
    import subprocess
    import sys
    subprocess.Popen([sys.executable, "-m", "pip", "install", "xlrd"],
                     creationflags=subprocess.CREATE_NEW_CONSOLE).wait()
    import xlrd
try:
    import xlwt
except:
    import subprocess
    import sys
    subprocess.Popen([sys.executable, "-m", "pip", "install", "xlwt"],
                     creationflags=subprocess.CREATE_NEW_CONSOLE).wait()
    import xlwt

try:
    import xlutils
except:
    import subprocess
    import sys
    subprocess.Popen([sys.executable, "-m", "pip", "install", "xlutils"],
                     creationflags=subprocess.CREATE_NEW_CONSOLE).wait()
    import xlutils
from xlutils.copy import copy  # 注意是从 xlutils.copy 导入 copy
import os
from optparse import OptionParser

def openXlsFile(path):
    try:
        workbook = xlrd.open_workbook(path, logfile=open(os.devnull, 'w'))
    except:
        print(path, "不是 xls 文件")
        exit(-1)
    return workbook

if __name__ == '__main__':

    parser = OptionParser()
    parser.add_option("--config_xls", action="store",
                      dest="config_xls", type="string")
    parser.add_option("--revert", action="store_true",
                      dest="revert",default=False)
    (opts, args) = parser.parse_args()

    xlsFiles = []
    for p in args:
        for f in os.listdir(p):
            if f.endswith('.xls'):
                xlsFiles.append(p+f)

    toReplaceText = []
    workbook = openXlsFile(opts.config_xls)

    sheet = workbook.sheet_by_index(0)
    num_rows = sheet.nrows
    num_cols = sheet.ncols
    for row in range(num_rows):
        row_data = []
        for col in range(2):
            cell = sheet.cell(row, col)
            if cell.ctype == xlrd.XL_CELL_NUMBER:
                if cell.value.is_integer():
                    value = str(int(cell.value))  # 转成整数字符串
                else:
                    value = str(cell.value)       # 保留浮点数
            else:
                value = str(cell.value)           # 直接输出文本
            row_data.append(value)
        toReplaceText.append(row_data)

    n = 0
    needToReplace = {}
    total = len(xlsFiles)
    cell_total = 0
    for xls in xlsFiles:
        n = n + 1
        print(f"遍历全部表 : {n}/{total}",end="\r")
        try:
            workbook = xlrd.open_workbook(
                xls, logfile=open(os.devnull, 'w'))
        except:
            print(xls, "不是 xls 文件")
            exit(-1)
        sheet = workbook.sheet_by_index(0)
        num_rows = sheet.nrows
        num_cols = sheet.ncols
        key = (workbook,xls)
        toneedToReplaceCell = []
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
                for replaceText in toReplaceText:
                    if value == replaceText[0]:
                        toneedToReplaceCell.append([row,col,replaceText[1]])
                        cell_total += 1
        needToReplace[key] = toneedToReplaceCell
    print()
    n = 0
    with open("替换结果.txt", 'w', encoding='utf-8') as f:
        for xls,cells in needToReplace.items():
            print(f"开始替换 : {n}/{cell_total}",end="\r")
            wb = copy(xls[0])
            sheet = wb.get_sheet(0)
            if len(cells) > 0 :
                for cell in cells:
                    n = n + 1
                    print(f"开始替换 : {n}/{cell_total}",end="\r")
                    sheet.write(cell[0], cell[1], f"<`已被替喽`>{cell[2]}<`已被替喽`>")
                    f.write(f"{xls[1]}@({cell[0]},{cell[1]}) : {cell[2]}\n")
                wb.save(xls[1])
            
    print()
    print(f"替换 {n} 个结果, 已经输出到 替换结果.txt 中")
