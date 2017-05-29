#!/bin/bash

bison -d --debug biflex.y 
flex biflex.l 
g++ -o parser lex.yy.c biflex.tab.c
