#!/usr/bin/env bash

echo "NativeScript version:"
tns --version

echo ""
echo "TNS doctor output:"
echo "n" | tns doctor

echo ""
echo "Node version:"
node --version

echo ""
echo "NPM version:"
npm --version

echo ""
echo "Java version:"
java -version

