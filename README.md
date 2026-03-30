# EC4417 Group Project — Portfolio Optimisation

This project analyses monthly stock price data (Jan 2015 – Dec 2025) for a set of individual equities, constructs optimal portfolios using mean-variance optimisation, and visualises the efficient frontier.

## Quick Start

1. **Install [uv](https://docs.astral.sh/uv/getting-started/installation/)** if you don't already have it (it manages Python and packages for us).

2. **Install dependencies** — from the project folder, run:

   ```bash
   uv sync
   ```

   This reads the `uv.lock` file and sets up everything you need (Python 3.10, pandas, numpy, PyPortfolioOpt, plotnine, etc.) in a local virtual environment.

3. **Open the notebook** — launch Jupyter and open `groupproject.ipynb`:

   ```bash
   uv run jupyter notebook
   ```

4. **Run all cells** from top to bottom (`Cell → Run All` or `Kernel → Restart & Run All`). The notebook is designed to be executed in order.

## Project Structure

```
.
├── groupproject.ipynb          # The main (and only) notebook — all analysis lives here
├── Data/
│   ├── pricedata.csv           # Source data: monthly adjusted close prices (wide format)
│   ├── F-F_Research_Data_Factors.csv  # Fama-French factors (used for the risk-free rate)
│   ├── returns.csv             # Generated: monthly returns in long format
│   ├── prices_wide.csv         # Generated: pivoted price table
│   └── pricedataalt.csv        # Alternate price data file
├── uv.lock                     # Locked dependency versions (don't edit by hand)
└── README.md                   # You are here
```

Files in `Data/` labelled "Generated" are created when you run the notebook — you don't need to worry about them.

## What the Notebook Does

### Part 1 — Descriptive Statistics

- **Loads price data** for 10 assets: GOOGL, MSFT, AMZN, WMT, KR, CVX, T, F, plus the S&P 500 index (SPX) and its ETF (SPY).
- **Computes monthly returns** from adjusted closing prices.
- **Calculates summary statistics** for each asset: annualised mean return, annualised volatility, skewness, and kurtosis.
- **Runs a Jarque–Bera test** on each asset's return series to check whether returns are normally distributed.

### Part 2 — Portfolio Optimisation

- **Drops SPX and SPY** from the investable universe (they serve as benchmarks, not as assets we'd hold).
- **Estimates the covariance matrix** of the remaining 8 stocks.
- **Derives the risk-free rate** from the Fama-French 1-month T-bill series, averaged over the sample period.
- **Finds two key portfolios:**
  - **Minimum-variance portfolio** — lowest possible risk.
  - **Maximum Sharpe ratio (tangency) portfolio** — best risk-adjusted return.
- **Traces the efficient frontier** across a range of target returns (P1–P8) and reports the weights for each.
- **Plots everything** — efficient frontier curve, individual asset positions, the Capital Allocation Line, and the special portfolios — using `plotnine`.

## Key Libraries

| Library | What it does |
|---|---|
| `pandas` / `numpy` | Data wrangling and numerical computation |
| `PyPortfolioOpt` | Mean-variance optimisation, covariance estimation, Sharpe maximisation |
| `cvxpy` | Convex optimisation solver (used under the hood by PyPortfolioOpt) |
| `plotnine` | ggplot2-style plotting |
| `scipy` | Statistical tests (Jarque–Bera) |

## Troubleshooting

- **`uv` not found** — install it with `curl -LsSf https://astral.sh/uv/install.sh | sh` (macOS/Linux) or see the [uv docs](https://docs.astral.sh/uv/getting-started/installation/).
- **Kernel errors in Jupyter** — make sure you're using the kernel that `uv` created. In Jupyter, go to `Kernel → Change kernel` and select the `.venv` environment from this project folder.
- **Plots not rendering** — the notebook uses `plotnine`, which renders via matplotlib. If plots don't appear, try restarting the kernel and re-running all cells.
