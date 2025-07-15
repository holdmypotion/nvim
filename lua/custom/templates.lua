-- Template for C++ competitive programming
local cpp_template = [=[
// author: holdmypotion
#pragma GCC optimize("Ofast")
/* #pragma GCC target("sse2,sse3,ssse3,sse4,popcnt,abm,mmx,avx,avx2,fma") */
#pragma GCC optimize("unroll-loops")
#include <bits/stdc++.h>

using namespace std;

typedef long long ll;
typedef long double ld;
typedef pair<int, int> p32;
typedef pair<ll, ll> p64;
typedef tuple<ll, ll, ll> t64;
typedef pair<double, double> pdd;
typedef vector<ll> v64;
typedef vector<int> v32;
typedef vector<bool> vb;
typedef vector<vector<int> > vv32;
typedef vector<vector<ll> > vv64;
typedef vector<vector<p32> > vvp32;
typedef vector<vector<p64> > vvp64;
typedef vector<vector<bool>> vvb;
typedef priority_queue<int> mx32;
typedef priority_queue<ll> mx64;
typedef priority_queue<int, v32, greater<int>> mn32;
typedef priority_queue<ll, v64, greater<ll>> mn64;
typedef vector<p64> vp64;
typedef vector<t64> vt64;
typedef vector<p32> vp32;
typedef set<p32> sp32;
typedef set<p64> sp64;
ll MOD = 998244353;
double eps = 1e-12;
#define forn(i,e) for(ll i = 0; i < e; i++)
#define forsn(i,s,e) for(ll i = s; i < e; i++)
#define rforn(i,s) for(ll i = s; i >= 0; i--)
#define rforsn(i,s,e) for(ll i = s; i >= e; i--)
#define ln "\n"
#define dbg(x) cout<<#x<<" = "<<x<<ln
#define mp make_pair
#define pb push_back
#define fi first
#define se second
#define INF 2e18
#define fast_cin() ios_base::sync_with_stdio(false); cin.tie(NULL); cout.tie(NULL)
#define all(x) (x).begin(), (x).end()
#define sz(x) ((ll)(x).size())
constexpr int mod = 1e9 + 7;

template<typename... T>
void p(T... args) { ((cout << args << " "), ...) << "\n"; }

template <typename T>
void pv(const vector<T>& vec) {
  for (const auto& elem : vec) cout << elem << " ";
  cout << ln;
}

template <typename T>
void pvv(const vector<T>& vv) {
  for (const auto& v : vv) {
    for (const auto& e : v) cout << e << " ";
    cout << ln;
  }
}

void potion() {

}

signed main() {
  fast_cin();
#ifndef ONLINE_JUDGE
  freopen("/Users/loona-mac/personal/mind-sport/input.txt", "r", stdin);
  // freopen("/Users/loona-mac/personal/mind-sport/output.txt", "w", stdout);
#endif
  int t; cin >> t;
  while (t--) potion();
  return 0;
}
]=]

-- Template for Python competitive programming
local python_template = [=[
# author: holdmypotion
import sys
from collections import defaultdict, Counter, deque
from math import gcd, lcm
from typing import List, Set, Dict, Tuple
import heapq

# Type aliases
Matrix = List[List[int]]
Graph = List[List[int]]

# Constants
MOD = 998244353
INF = float('inf')
NINF = float('-inf')

# Fast I/O setup
sys.stdin = open('/Users/loona-mac/personal/mind-sport/input.txt', 'r')
# sys.stdout = open('/Users/loona-mac/personal/mind-sport/output.txt', 'w', buffering=1)
input = sys.stdin.readline
# Fast input functions
def inp(): return input().strip()
def inpi(): return int(input())
def inpl(): return list(map(int, input().split()))
def inpls(): return list(input().split())


def potion():
    pass

def main():
    # potion()
    t = inpi()
    for _ in range(t):
        potion()


if __name__ == "__main__":
    main()
]=]

-- Function to create a new file with optional template
local function create_new_file(template_type)
    -- Get current buffer's directory path
    local current_dir = vim.fn.expand('%:p:h')
    
    -- Prompt for filename
    local filename = vim.fn.input('New file name: ', current_dir .. '/', 'file')
    
    if filename ~= '' then
        -- Create the parent directories if they don't exist
        local dir = vim.fn.fnamemodify(filename, ':h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, 'p')
        end
        
        -- Create and edit the new file
        vim.cmd('edit ' .. filename)
        
        -- Insert the appropriate template based on type
        if template_type == 'cpp' then
            vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(cpp_template, '\n'))
        elseif template_type == 'python' then
            vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(python_template, '\n'))
        end
    end
end

-- Map <leader>nn to create a blank file
vim.keymap.set('n', '<leader>nn', function()
    create_new_file()
end, { desc = 'Create new blank file in current directory' })

-- Map <leader>nc to create a file with C++ template
vim.keymap.set('n', '<leader>nc', function()
    create_new_file('cpp')
end, { desc = 'Create new C++ file with template in current directory' })

-- Map <leader>np to create a file with Python template
vim.keymap.set('n', '<leader>np', function()
    create_new_file('python')
end, { desc = 'Create new Python file with template in current directory' })
