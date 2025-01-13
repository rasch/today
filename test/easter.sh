#!/bin/sh

. src/easter.sh

diagnostic 'easter()'

given='2019 7 17'
should='return -87 (87 days after Easter)'
actual=$(easter 2019 7 17)
expected=-87

assert "$given" "$should" "$actual" "$expected"

given='2019 4 20'
should='return 1 (1 day before Easter)'
actual=$(easter 2019 4 20)
expected=1

assert "$given" "$should" "$actual" "$expected"

given='2019 04 21'
should='return 0 (Easter day)'
actual=$(easter 2019 04 21)
expected=0

assert "$given" "$should" "$actual" "$expected"

given='2019 04 19'
should='return 2 (Good Friday)'
actual=$(easter 2019 04 19)
expected=2

assert "$given" "$should" "$actual" "$expected"

given='2020 04 10'
should='return 2 (Good Friday)'
actual=$(easter 2020 04 10)
expected=2

assert "$given" "$should" "$actual" "$expected"

given='2038 04 25'
should='return 0 (Easter)'
actual=$(easter 2038 04 25)
expected=0

assert "$given" "$should" "$actual" "$expected"

given='1987 12 25'
should='return -250 (250 days after Easter)'
actual=$(easter 1987 12 25)
expected=-250

assert "$given" "$should" "$actual" "$expected"

given='2020 01 01'
should='return 102 (102 days before Easter)'
actual=$(easter 2020 01 01)
expected=102

assert "$given" "$should" "$actual" "$expected"

given='2020 12 31'
should='return -263 (263 days after Easter)'
actual=$(easter 2020 12 31)
expected=-263

assert "$given" "$should" "$actual" "$expected"

given='2019 01 01'
should='return 110 (110 days before Easter)'
actual=$(easter 2019 01 01)
expected=110

assert "$given" "$should" "$actual" "$expected"

given='2019 12 31'
should='return -254 (254 days after Easter)'
actual=$(easter 2019 12 31)
expected=-254

assert "$given" "$should" "$actual" "$expected"

given='2020 04'
should='return an empty string (2 args is invalid)'
actual=$(easter 2020 04)
expected=''

assert "$given" "$should" "$actual" "$expected"

given='2020'
should='return a string representing the date'
actual=$(easter 2020)
expected='2020-04-12'

assert "$given" "$should" "$actual" "$expected"

diagnostic 'easter() - check every Easter from 2000 to 2199'

for i in \
'2000 04 23' '2001 04 15' '2002 03 31' '2003 04 20' '2004 04 11' \
'2005 03 27' '2006 04 16' '2007 04 08' '2008 03 23' '2009 04 12' \
'2010 04 04' '2011 04 24' '2012 04 08' '2013 03 31' '2014 04 20' \
'2015 04 05' '2016 03 27' '2017 04 16' '2018 04 01' '2019 04 21' \
'2020 04 12' '2021 04 04' '2022 04 17' '2023 04 09' '2024 03 31' \
'2025 04 20' '2026 04 05' '2027 03 28' '2028 04 16' '2029 04 01' \
'2030 04 21' '2031 04 13' '2032 03 28' '2033 04 17' '2034 04 09' \
'2035 03 25' '2036 04 13' '2037 04 05' '2038 04 25' '2039 04 10' \
'2040 04 01' '2041 04 21' '2042 04 06' '2043 03 29' '2044 04 17' \
'2045 04 09' '2046 03 25' '2047 04 14' '2048 04 05' '2049 04 18' \
'2050 04 10' '2051 04 02' '2052 04 21' '2053 04 06' '2054 03 29' \
'2055 04 18' '2056 04 02' '2057 04 22' '2058 04 14' '2059 03 30' \
'2060 04 18' '2061 04 10' '2062 03 26' '2063 04 15' '2064 04 06' \
'2065 03 29' '2066 04 11' '2067 04 03' '2068 04 22' '2069 04 14' \
'2070 03 30' '2071 04 19' '2072 04 10' '2073 03 26' '2074 04 15' \
'2075 04 07' '2076 04 19' '2077 04 11' '2078 04 03' '2079 04 23' \
'2080 04 07' '2081 03 30' '2082 04 19' '2083 04 04' '2084 03 26' \
'2085 04 15' '2086 03 31' '2087 04 20' '2088 04 11' '2089 04 03' \
'2090 04 16' '2091 04 08' '2092 03 30' '2093 04 12' '2094 04 04' \
'2095 04 24' '2096 04 15' '2097 03 31' '2098 04 20' '2099 04 12' \
'2100 03 28' '2101 04 17' '2102 04 09' '2103 03 25' '2104 04 13' \
'2105 04 05' '2106 04 18' '2107 04 10' '2108 04 01' '2109 04 21' \
'2110 04 06' '2111 03 29' '2112 04 17' '2113 04 02' '2114 04 22' \
'2115 04 14' '2116 03 29' '2117 04 18' '2118 04 10' '2119 03 26' \
'2120 04 14' '2121 04 06' '2122 03 29' '2123 04 11' '2124 04 02' \
'2125 04 22' '2126 04 14' '2127 03 30' '2128 04 18' '2129 04 10' \
'2130 03 26' '2131 04 15' '2132 04 06' '2133 04 19' '2134 04 11' \
'2135 04 03' '2136 04 22' '2137 04 07' '2138 03 30' '2139 04 19' \
'2140 04 03' '2141 03 26' '2142 04 15' '2143 03 31' '2144 04 19' \
'2145 04 11' '2146 04 03' '2147 04 16' '2148 04 07' '2149 03 30' \
'2150 04 12' '2151 04 04' '2152 04 23' '2153 04 15' '2154 03 31' \
'2155 04 20' '2156 04 11' '2157 03 27' '2158 04 16' '2159 04 08' \
'2160 03 23' '2161 04 12' '2162 04 04' '2163 04 24' '2164 04 08' \
'2165 03 31' '2166 04 20' '2167 04 05' '2168 03 27' '2169 04 16' \
'2170 04 01' '2171 04 21' '2172 04 12' '2173 04 04' '2174 04 17' \
'2175 04 09' '2176 03 31' '2177 04 20' '2178 04 05' '2179 03 28' \
'2180 04 16' '2181 04 01' '2182 04 21' '2183 04 13' '2184 03 28' \
'2185 04 17' '2186 04 09' '2187 03 25' '2188 04 13' '2189 04 05' \
'2190 04 25' '2191 04 10' '2192 04 01' '2193 04 21' '2194 04 06' \
'2195 03 29' '2196 04 17' '2197 04 09' '2198 03 25' '2199 04 14'
do
  # shellcheck disable=SC2086
  set -- $i

  given="$1 $2 $3"
  should='return 0'
  actual=$(easter "$1" "$2" "$3")
  expected=0

  assert "$given" "$should" "$actual" "$expected"

  given="$1"
  should="return $1-$2-$3"
  actual=$(easter "$1")
  expected="$1-$2-$3"

  assert "$given" "$should" "$actual" "$expected"
done
