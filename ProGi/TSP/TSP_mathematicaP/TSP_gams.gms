scalar
   p number of cities  /29/
   cpd cost incurred per KM distance it travelled  /1/
;

sets
   i /1*29/
;
alias (i,j);
table c(i,j) distance matrix (KM)


      1   2  3   4   5  6    7  8   9   10   11  12 13  14  15  16  17  18  19   20 21  22   23 24  25   26  27 28
 1    97 205 139 86  60 220  65 111 115 227  95  82 225 168 103 266 205 149 120  58 257 152  52 180 136  82  34 145
 2       129 103 71  105 258 154 112  65 204 150  87 176 137 142 204 148 148  49  41 211 226 116 197  89 153 124  74
 3           219 125 175 386 269 134 184 313 201 215 267 248 271 274 236 272 160 151 300 350 239 322  78 276 220  60
 4               167 182 180 162 208  39 102 227  60  86  34  96 129  69  58  60 120 119 192 114 110 192 136 173 173
 5                   51  296 150  42 131 268  88 131 245 201 175 275 218 202 119  50 281 238 131 244  51 166  95  69
 6                      279 114  56 150 278  46 133 266 214 162 302 242 203 146  67 300 205 111 238  98 139  52 120
 7                          178 328 206 147 308 172 203 165 121 251 216 122 231 249 209 111 169  72 338 144 237 331
 8                              169 151 227 133 104 242 182  84 290 230 146 165 121 270  91  48 158 200  39  64 210
 9                                  172 309  68 169 286 242 208 315 259 240 160  90 322 260 160 281  57 192 107  90
 10                                     140 195  51 117  72 104 153  93  88  25  85 152 200 104 139 154 134 149 135
 11                                         320 146  64  68 143 106  88  81 159 219  63 216 187  88 293 191 258 272
 12                                             174 311 258 196 347 288 243 192 113 345 222 144 274 124 165  71 153
 13                                                 144  86  57 189 128  71  71  82 176 150  56 114 168  83 115 160
 14                                                      61 165  51  32 105 127 201  36 254 196 136 260 212 258 234
 15                                                         106 110  56  49  91 153  91 197 136  94 225 151 201 205
 16                                                             215 159  64 126 128 190  98  53  78 218  48 127 214
 17                                                                 61  155 157 235  47 305 243 186 282 261 300 252
 18                                                                     105 100 176  66 253 183 146 231 203 239 204
 19                                                                         113 152 127 150 106  52 235 112 179 221
 20                                                                             79  163 220 119 164 135 152 153 114
 21                                                                                 236 201  90 195  90 127  84  91
 22                                                                                     273 226 148 296 238 291 269
 23                                                                                         112 130 286  74 155 291
 24                                                                                             130 178  38  75 180
 25                                                                                                 281 120 205 270
 26                                                                                                     213 145  36
 27                                                                                                          94 217
 28                                                                                                             162
 29        
;

c(i,j) = max(c(i,j),c(j,i));
Variables x(i,j),F,u(i);

*keeps track of the order in which the cities are visited if u(i)<u(j) means i is visited before city j
Positive Variable u(i);

*x(i,j) is 1 means a route is taken from i to j, 0 means otherwise
Binary Variable x(i,j);


Equations
eq1
eq2(j)
eq4(i,j)
eq3(i)
eq5(i)
eq6(i)
start
end
;
*evaluation of objective function
eq1..  sum(i,sum(j,c(i, j) * x(i, j)*cpd $(ord(i) <> ord(j))))=e=F;

*each city will be visited exactly onces
eq2(j)$(ord(j)>=2).. sum(i$(ord(i) <> ord(j)),x(i,j))=e=1;
eq3(i)$(ord(i)>=2).. sum(j$(ord(i) <> ord(j)),x(i,j))=e=1;

*subtour elimination they are the tours formed by intermideate nodes not connnected to the origin
eq4(i,j).. u(i)-u(j)+p*x(i,j)$(ord(i)>=2)=l=p-1;

eq5(i).. u(i)=g=1;
eq6(i).. u(i)=l=p;
*there is only one instance of salesman entering that city and one instance of salesman exiting
start.. sum(j, x('1',j)) =e= 1;
end.. sum(i, x(i,'1')) =e= 1;



model project /all/;
solve project using mip minimizing F;
