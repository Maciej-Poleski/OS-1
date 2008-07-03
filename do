#!/bin/bash 
nasm boot.asm -o boot.o
nasm head.asm -o head.o
rm boot.bin
cat boot.o>>boot.bin
cat head.o>>boot.bin
cat boot.bin>>/dev/fd0