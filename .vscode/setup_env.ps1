if (!(Test-Path '.venv')) {
    if (Get-Command uv -ErrorAction SilentlyContinue) {
        Write-Host 'Using uv...'
        Write-Host 'Creating virtual environment with uv...'
        uv venv --seed --clear
        uv sync
    } else {
        Write-Host 'uv not found, installing uv...'
        try {
            powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
            $env:PATH += ";$env:USERPROFILE\.cargo\bin"
            if (Get-Command uv -ErrorAction SilentlyContinue) {
                Write-Host 'uv installed successfully, creating virtual environment...'
                uv venv --seed --clear
                uv sync
            } else {
                throw 'uv installation failed'
            }
        } catch {
            Write-Host 'uv installation failed, trying pyenv...'
            if (Get-Command pyenv -ErrorAction SilentlyContinue) {
                Write-Host 'Using pyenv...'
                if (Test-Path '.python-version') { $pyver = Get-Content '.python-version'; Write-Host "Setting Python version to $pyver"; pyenv local $pyver }
                Write-Host 'Creating virtual environment with pyenv...'
                python -m venv .venv
                .venv\Scripts\Activate.ps1
                pip install -e .
            } elseif (Get-Command conda -ErrorAction SilentlyContinue) {
                Write-Host 'Using conda...'
                if (Test-Path 'environment.yml') {
                    Write-Host 'Creating conda environment from environment.yml...'
                    conda env create -f environment.yml
                } elseif (Test-Path 'pyproject.toml') {
                    Write-Host 'Creating conda environment and installing from pyproject.toml...'
                    conda create -n cflabs python -y
                    conda activate cflabs
                    pip install -e .
                } else {
                    Write-Host 'Creating basic conda environment...'
                    conda create -n cflabs python -y
                }
            } else {
                Write-Host 'No Python environment manager found and uv installation failed. Please install uv, pyenv, or conda manually.'
            }
        }
    }
} else {
    Write-Host 'Virtual environment already exists at .venv'
}
