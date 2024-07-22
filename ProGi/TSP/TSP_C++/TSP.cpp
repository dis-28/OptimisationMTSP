#include <bits/stdc++.h>
using namespace std;

class Solution
{
public:
    int total_cost(vector<vector<int>> &cost)
    {

        int n = cost.size(); // no of cities

        int bit = 0;

        vector<vector<int>> dp(n, vector<int>(1 << n, -1)); // a cache memory to store the prevously computed answer using memoization
        return f(cost, 0, bit, n, 1, dp);
    }

    int f(vector<vector<int>> &cost, int cur, int bit, int n, int numV, vector<vector<int>> &dp)
    {

        if (numV == n)
        {
            return cost[cur][0]; // completed the tour also add the cost from returning to main vertex from last stop
        }
        if (dp[cur][bit] != -1) // if the answer to this state is already computed return it
            return dp[cur][bit];

        bit = bit | (1 << cur); // marking this city to be visited
        int res = 1e9;
        for (int i = 0; i < n; i++) // trying all possible combination to visit the reamining unvisited cities
        {
            int mask = 1 << i;
            if ((bit & mask) == 0)
                res = min(res, cost[cur][i] + f(cost, i, bit, n, numV + 1, dp));
        }
        bit = bit ^ (1 << cur); // after computing the result marking the cur city to be unvisited so can be use dby others
        dp[cur][bit] = res;
        return res;
    }
};
int main()
{
    int T;
    cin >> T;
    while (T--)
    {
        int n;
        cin >> n;
        vector<vector<int>> cost(n, vector<int>(n, 0));
        for (int i = 0; i < n; i++)
            for (int j = 0; j < n; j++)
                cin >> cost[i][j];

        Solution obj;                   // initializing adajency matrix
        int ans = obj.total_cost(cost); // retriving ans to problem of TSP
        cout << ans << "\n";
    }
    return 0;
}