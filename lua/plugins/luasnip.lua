return {
  "L3MON4D3/LuaSnip",
  version = "v2.3.0",
  -- install jsregexp (optional!).
  -- build = "make install_jsregexp",
  config = function()
    local ls = require "luasnip"
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local extras = require("luasnip.extras")
    local rep = extras.rep
    local fmt = require("luasnip.extras.fmt").fmt
    local c = ls.choice_node
    local f = ls.function_node
    local d = ls.dynamic_node
    local sn = ls.snippet_node

    vim.keymap.set({ "i", "s" }, "<A-n>", function()
        if ls.choice_active() then
            ls.change_choice(1)
        end
    end)

    vim.keymap.set({ "i", "s" }, "<A-k>", function()
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<A-j>", function()
        if ls.jumpable(-1) then
            ls.jump(-1)
        end
    end, { silent = true })

    ls.add_snippets("cpp", {
        -- Graph structure snippet
        s("graph", {
            t({"struct graph {", "  "}),
            t({"ll n, m;", "  "}),
            t({"vv64 adj;", "  "}),
            t({"vector<bool> vis, dis;", "  ", "  "}),
            t({"graph() = default;", "  "}),
            t({"graph(ll n) : n(n) {", "    "}),
            t({"adj.resize(n + 1);", "    "}),
            t({"vis.resize(n + 1, false);", "  "}),
            t({"};", "  ", "  "}),
            t({"void addEdge(ll a, ll b) {", "    "}),
            t({"adj[a].pb(b);", "  "}),
            t({"}", "  ", "  "}),
            t({"void p() {", "    "}),
            t({"forsn(i, 1, n+1) {", "      "}),
            t({"cout << i << \": \";", "      "}),
            t({"for (auto v: adj[i]) {", "        "}),
            t({"cout << v << \" \";", "      "}),
            t({"}", "      "}),
            t({"cout << ln;", "    "}),
            t({"}", "  "}),
            t({"}", "", ""}),
            i(0),
            t({"};"}),
        }),

        -- DFS snippet
        s("dfs", {
            t({"void dfs(ll u) {", "  "}),
            t({"vis[u] = true;", "  "}),
            t({"cout << u << \" -> \";", "  "}),
            t({"for (auto& v : adj[u]) {", "    "}),
            t({"if (!vis[v]) dfs(v);", "  "}),
            t({"}", "}"}),
        }),

        -- BFS snippet
        s("bfs", {
            t({"void bfs(ll u) {", "  "}),
            t({"vis[u] = true;", "  "}),
            t({"dis[u] = 0;", "  "}),
            t({"q.push(u);", "  "}),
            t({"while (!q.empty()) {", "    "}),
            t({"auto s = q.front(); q.pop();", "    "}),
            t({"cout << s << \" \";", "    "}),
            t({"for (auto v : adj[s]) {", "      "}),
            t({"if (vis[v]) continue;", "      "}),
            t({"vis[v] = true;", "      "}),
            t({"dis[v] = dis[s] + 1;", "      "}),
            t({"q.push(v);", "    "}),
            t({"}", "  "}),
            t({"}", "}"}),
        }),

        -- Common competitive programming template
        s("cpp", {
            t({"// author: holdmypotion", ""}),
            t({"#pragma GCC optimize(\"Ofast\")", ""}),
            t({"/* #pragma GCC target(\"sse2,sse3,ssse3,sse4,popcnt,abm,mmx,avx,avx2,fma\") */", ""}),
            t({"#pragma GCC optimize(\"unroll-loops\")", ""}),
            t({"#include <bits/stdc++.h>", ""}),
            t({"using namespace std;", ""}),
            t({"typedef long long ll;", ""}),
            t({"typedef long double ld;", ""}),
            t({"typedef pair<int, int> p32;", ""}),
            t({"typedef pair<ll, ll> p64;", ""}),
            t({"typedef tuple<ll, ll, ll> t64;", ""}),
            t({"typedef pair<double, double> pdd;", ""}),
            t({"typedef vector<ll> v64;", ""}),
            t({"typedef vector<int> v32;", ""}),
            t({"typedef vector<bool> vb;", ""}),
            t({"typedef vector<vector<int>> vv32;", ""}),
            t({"typedef vector<vector<ll>> vv64;", ""}),
            t({"typedef vector<vector<p32>> vvp32;", ""}),
            t({"typedef vector<vector<p64>> vvp64;", ""}),
            t({"typedef vector<vector<bool>> vvb;", ""}),
            t({"typedef priority_queue<int> mx32;", ""}),
            t({"typedef priority_queue<ll> mx64;", ""}),
            t({"typedef priority_queue<int, v32, greater<int>> mn32;", ""}),
            t({"typedef priority_queue<ll, v64, greater<ll>> mn64;", ""}),
            t({"typedef vector<p64> vp64;", ""}),
            t({"typedef vector<t64> vt64;", ""}),
            t({"typedef vector<p32> vp32;", ""}),
            t({"typedef set<p32> sp32;", ""}),
            t({"typedef set<p64> sp64;", "", ""}),
            t({"ll MOD = 998244353;", ""}),
            t({"double eps = 1e-12;", ""}),
            t({"#define forn(i,e) for(ll i = 0; i < e; i++)", ""}),
            t({"#define forsn(i,s,e) for(ll i = s; i < e; i++)", ""}),
            t({"#define rforn(i,s) for(ll i = s; i >= 0; i--)", ""}),
            t({"#define rforsn(i,s,e) for(ll i = s; i >= e; i--)", ""}),
            t({"#define ln \"\\n\"", ""}),
            t({"#define dbg(x) cout<<#x<<\" = \"<<x<<ln", ""}),
            t({"#define mp make_pair", ""}),
            t({"#define pb push_back", ""}),
            t({"#define fi first", ""}),
            t({"#define se second", ""}),
            t({"#define INF 2e18", ""}),
            t({"#define fast_cin() ios_base::sync_with_stdio(false); cin.tie(NULL); cout.tie(NULL)", ""}),
            t({"#define all(x) (x).begin(), (x).end()", ""}),
            t({"#define sz(x) ((ll)(x).size())", "", ""}),
            t({"constexpr int mod = 1e9 + 7;", "", ""}),
            t({"template<typename... T>", ""}),
            t({"void p(T... args) { ((cout << args << \" \"), ...) << \"\\n\"; }", "", ""}),
            t({"template <typename T>", ""}),
            t({"void pv(const vector<T>& vec) {", ""}),
            t({"  for (const auto& elem : vec) cout << elem << \" \";", ""}),
            t({"  cout << ln;", "}", "", ""}),
            t({"template <typename T>", ""}),
            t({"void pvv(const vector<T>& vv) {", ""}),
            t({"  for (const auto& v : vv) {", ""}),
            t({"    for (const auto& e : v) cout << e << \" \";", ""}),
            t({"    cout << ln;", ""}),
            t({"  }", "}", "", ""}),
            t({"void potion() {", "  "}),
            i(1),
            t({"", "}", "", ""}),
            t({"signed main() {", ""}),
            t({"  fast_cin();", ""}),
            t({"#ifndef ONLINE_JUDGE", ""}),
            t({"  freopen(\"/Users/loona-mac/personal/mind-sport/input.txt\", \"r\", stdin);", ""}),
            t({"  // freopen(\"/Users/loona-mac/personal/mind-sport/output.txt\", \"w\", stdout);", ""}),
            t({"#endif", ""}),
            t({"  int t; cin >> t;", ""}),
            t({"  while (t--) potion();", ""}),
            t({"  return 0;", "}"}),
        }),
    })
  end
}
