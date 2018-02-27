#!/usr/bin/env python3

import re
import sys, os
import matplotlib.pyplot as plt
from pprint import pprint
from datetime import time
# Return a list of consensus time from node.log
def readConsensusLog(fileName, path="data/"):
    consensusRegex = re.compile(r'have\ a\ consensus\ on\ the\ block')
    with open(path+fileName, 'r') as logFile:
        #pprint ([line for line in logFile if consensusRegex.search(line)!=None])
        cTimeLst = [line[12:20] for line in logFile if consensusRegex.search(line)!=None]
    return cTimeLst
def writeResult():
    pass
# Find all the consensus time record from the given logfile
def getConsensusTime(logFile):
    consensusRegex = re.compile('[have a consensus on the block]')
    print (type(logFile))
#    consensusTimeLst = [timeRecord[12:20] for timeRecord in consensusRegex.findall(logFile)]
#    return consensusTimeLst
def calcuPerform(consensusTimeLst):
    Lst = consensusTimeLst
    try:
        first = time(int(Lst[0][:2]),int(Lst[0][3:5]),int(Lst[0][6:]))
        last  = time(int(Lst[-1][:2]),int(Lst[-1][3:5]),int(Lst[-1][6:]))
        totalTime = last.second - first.second
        return totalTime/(len(Lst)-1)
    except:
        print ('consensusTimeLst:', consensusTimeLst)
def plotResult():
    pass
def main():
    Logs = ['n1.log', 'n2.log', 'n3.log', 'n4.log']
    performLst = [ calcuPerform(readConsensusLog(log)) for log in Logs ]
    print ('sec/block',performLst)
    print ('txs/sec',sum(performLst)/len(performLst)*472)
if __name__=='__main__':
    main()
